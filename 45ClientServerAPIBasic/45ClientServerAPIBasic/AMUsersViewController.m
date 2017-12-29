//
//  AMUsersViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 05.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMUsersViewController.h"
#import "AMServerManager.h"
#import "AMUser.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AMUserDetailTableViewController.h"
#import "UIColor+AMCustomColor.h"
#import "AMLoginViewController.h"
#import "AMGroupsViewController.h"
#import "AMDialogsViewController.h"

const NSInteger objectInRequest = 12;
BOOL isLoadingMoreObjects = NO;

@interface AMUsersViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray* friends;
@property (strong, nonatomic) UIBarButtonItem* loginBarButtonItem;
@property (strong, nonatomic) UIImageView* userImageView;
@property (strong, nonatomic) AMUser* user;

@end

@implementation AMUsersViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.friends = [NSMutableArray array];
    isLoadingMoreObjects = YES;
    
    [[AMServerManager sharedManager] getFriendsWithOffset:0
                                                    count:objectInRequest
                                                onSuccess:^(NSArray *friends) {
                                                    
                                                    [self.friends addObjectsFromArray:friends];
                                                    [self.tableView reloadData];
                                                    isLoadingMoreObjects = NO;
                                                    
                                                }
                                                onFailure:nil];
   
    self.tableView.layer.cornerRadius = 20.f;
    self.tableView.layer.borderColor = [UIColor orangeCustomColor].CGColor;
    self.tableView.layer.borderWidth = 3.0f;
    
    UIBarButtonItem* loginBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log In"
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(actionLogInBarButton:)];
    
    self.loginBarButtonItem = loginBarButtonItem;
    self.navigationItem.leftBarButtonItem = self.loginBarButtonItem;

  
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - (CGRectGetHeight(self.tableView.frame)) - CGRectGetHeight(self.tableView.frame) / objectInRequest;
    
    if (actualPosition >= contentHeight && !isLoadingMoreObjects) {
        
        isLoadingMoreObjects = YES;
        NSInteger offset = [self.friends count];
        __weak typeof(self) weakSelf = self;
        [[AMServerManager sharedManager] getFriendsWithOffset:offset count:objectInRequest onSuccess:^(NSArray *friends) {
            
            [weakSelf.friends addObjectsFromArray:friends];
            
            [weakSelf.tableView beginUpdates];
            
            NSMutableArray* arrayPaths = [NSMutableArray array];
            for (NSInteger index = [weakSelf.friends count] - [friends count]; index < [weakSelf.friends count]; index++) {
                [arrayPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
            }
            [weakSelf.tableView insertRowsAtIndexPaths:arrayPaths withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView endUpdates];
            isLoadingMoreObjects = NO;

            
        } onFailure:nil];
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMUser* friend = [self.friends objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"AMUserDetailTableViewController" sender:friend];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    AMUser* friend = [self.friends objectAtIndex:indexPath.row];
    
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor orangeCustomColor];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    
    UIImage* withoutPhoto = [UIImage imageNamed:@"nophoto.png"];
    NSURLRequest* request = [NSURLRequest requestWithURL:friend.photo50];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGRectGetHeight(self.tableView.bounds) / objectInRequest;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.friends count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    return cell;
    
}


#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    if ([segue.destinationViewController isKindOfClass:[AMUserDetailTableViewController class]]) {
        
        AMUserDetailTableViewController* detailController = segue.destinationViewController;
        detailController.user = sender;
        
    } else if ([segue.destinationViewController isKindOfClass:[AMGroupsViewController class]]) {
        
        AMGroupsViewController* groupsController = segue.destinationViewController;
        groupsController.userID = [sender longValue];
        
    }
    
}

#pragma mark - Actions

- (void) actionLogInBarButton:(UIBarButtonItem *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    [[AMServerManager sharedManager] logInUser:^(AMUser *user) {
        
        weakSelf.user = user;
        UIImage* placeholderImage = [UIImage imageNamed:@"nophoto.png"];
        UIImageView* loginImageView = [[UIImageView alloc] init];

        weakSelf.userImageView = loginImageView;
        
        [loginImageView setImageWithURLRequest:[NSURLRequest requestWithURL:user.photo50]
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           UIButton* userButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                           [userButton setImage:image forState:UIControlStateNormal];
                                           [userButton setFrame:CGRectMake(0, 0, 30, 30)];
                                           [userButton addTarget:self action:@selector(actionLogOutUser:) forControlEvents:UIControlEventTouchDown];
                                           
                                           userButton.clipsToBounds = YES;
                                           userButton.layer.cornerRadius = 15.f;
                                           
                                           UIBarButtonItem* userBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userButton];
                                           weakSelf.navigationItem.leftBarButtonItem = userBarButtonItem;
                                           [weakSelf.navigationItem.titleView setNeedsDisplay];
                                           
                                       }
         
                                       failure:nil];
        
    }];
    
}

- (void) actionLogOutUser:(UIBarButtonItem*)sender {

    [[AMServerManager sharedManager] logOutUser];
    self.user = nil;
    self.navigationItem.leftBarButtonItem = self.loginBarButtonItem;
    [self.navigationItem.titleView setNeedsDisplay];
    
}

- (IBAction)actionGroups:(UIBarButtonItem*)sender {
    
    if (self.user) {
        
        [self performSegueWithIdentifier:@"AMGroupsViewController" sender:@(self.user.userID)];
        
    }
    
}

- (IBAction)actionMessages:(UIBarButtonItem *)sender {
    
    if (self.user) {
        
        [self performSegueWithIdentifier:@"AMDialogsViewController" sender:nil];
        
    }
    
}

@end
