//
//  AMGroupsViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 19.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMGroupsViewController.h"
#import "AMServerManager.h"
#import "AMGroup.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIColor+AMCustomColor.h"
#import "AMUserWallViewController.h"
#import "AMDialogsViewController.h"
#import "AMAlbumsViewController.h"

const NSInteger groupsInRequest = 12;
BOOL isLoadingMoreGroups = NO;

@interface AMGroupsViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray* groups;

@end

@implementation AMGroupsViewController

- (void) setUserID:(long)userID {
    
    _userID = userID;
    
    self.groups = [NSMutableArray array];
    
    isLoadingMoreGroups = YES;
    __weak typeof(self) weakSelf = self;
    
    [[AMServerManager sharedManager] getGroupsForUserID:userID
                                             withOffset:0
                                                  count:groupsInRequest
                                              onSuccess:^(NSArray *groups) {
                                                 
                                                 [weakSelf.groups addObjectsFromArray:groups];
                                                 [weakSelf.tableView reloadData];
                                                 isLoadingMoreGroups = NO;
                                                 
                                             }
                                              onFailure:nil];
    
}

#pragma mark - UIView Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.layer.cornerRadius = 20.f;
    self.tableView.layer.borderColor = [UIColor orangeCustomColor].CGColor;
    self.tableView.layer.borderWidth = 3.0f;
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - (CGRectGetHeight(self.tableView.frame)) - CGRectGetHeight(self.tableView.frame) / groupsInRequest;
    
    if (actualPosition >= contentHeight && !isLoadingMoreGroups) {
        
        isLoadingMoreGroups = YES;
        NSInteger offset = [self.groups count];
        __weak typeof(self) weakSelf = self;
        
        [[AMServerManager sharedManager] getGroupsForUserID:self.userID
                                                 withOffset:offset
                                                      count:groupsInRequest
                                                  onSuccess:^(NSArray *groups) {
                                                      
                                                      [weakSelf.groups addObjectsFromArray:groups];
                                                      
                                                      [weakSelf.tableView beginUpdates];
                                                      
                                                      NSMutableArray* arrayPaths = [NSMutableArray array];
                                                      for (NSInteger index = [weakSelf.groups count] - [groups count]; index < [weakSelf.groups count]; index++) {
                                                          [arrayPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                                                      }
                                                      [weakSelf.tableView insertRowsAtIndexPaths:arrayPaths withRowAnimation:UITableViewRowAnimationTop];
                                                      [weakSelf.tableView endUpdates];
                                                      
                                                      isLoadingMoreGroups = NO;
                                                      
                                                  }
                                                  onFailure:nil];
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMGroup* group = [self.groups objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"AMGroupWallViewController" sender:@(group.groupID)];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AMGroup* group = [self.groups objectAtIndex:indexPath.row];
    
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor orangeCustomColor];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    cell.textLabel.text = group.name;
    
    UIImage* withoutPhoto = [UIImage imageNamed:@"nophoto.png"];
    NSURLRequest* request = [NSURLRequest requestWithURL:group.photo50];
    
    __weak UITableViewCell* weakCell = cell;
    
    cell.imageView.layer.cornerRadius = 5.f;
    cell.imageView.layer.masksToBounds = YES;
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:withoutPhoto
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       weakCell.imageView.image = image;
                                   }
                                   failure:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {//
    
    return CGRectGetHeight(self.tableView.bounds) / groupsInRequest;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.groups count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
    
}


#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[AMUserWallViewController class]]) {
        
        AMUserWallViewController* wallController = segue.destinationViewController;
        wallController.userID = (-1) * [sender longValue];
        
    }
    
}

#pragma mark - Actions

- (IBAction)actionMessages:(UIBarButtonItem *)sender {
        
    [self performSegueWithIdentifier:@"AMDialogsViewController" sender:nil];
    
}

@end
