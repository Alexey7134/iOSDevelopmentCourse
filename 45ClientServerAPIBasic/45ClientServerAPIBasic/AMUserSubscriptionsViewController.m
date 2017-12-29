//
//  AMUserSubscriptionsViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 07.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMUserSubscriptionsViewController.h"
#import "AMUser.h"
#import "AMServerManager.h"
#import "AMSubscription.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIColor+AMCustomColor.h"

const NSInteger countInRequest = 10;
BOOL isLoadingMoreResults = NO;

@interface AMUserSubscriptionsViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray* requestResults;

@end

@implementation AMUserSubscriptionsViewController

- (void) setUserID:(long)userID {
    
    _userID = userID;
    
    __weak typeof(self) weakSelf = self;
    
    isLoadingMoreResults = YES;
    
    if (self.requestType == AMRequestTypeSubscription) {
        
        [[AMServerManager sharedManager] getSubscriptionsForUserID:userID
                                                        withOffset:[weakSelf.requestResults count]
                                                             count:countInRequest
                                                         onSuccess:^(NSArray *subscriptions) {
                                                             
                                                             [weakSelf.requestResults addObjectsFromArray:subscriptions];
                                                             [weakSelf.tableView reloadData];
                                                             isLoadingMoreResults = NO;
                                                             [weakSelf updateDetailUsers];
                                                             
                                                         }
                                                         onFailure:^(NSError *error) {
                                                             
                                                         }];
    
    } else {
        
        [[AMServerManager sharedManager] getFollowersForUserID:userID
                                                    withOffset:[weakSelf.requestResults count]
                                                         count:countInRequest
                                                    onSuccess:^(NSArray *followers) {
                                                        [weakSelf.requestResults addObjectsFromArray:followers];
                                                        [weakSelf.tableView reloadData];
                                                        isLoadingMoreResults = NO;
                                                    }
                                                    onFailure:^(NSError *error) {
                                                        
                                                    }];
        
    }

    
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.requestResults = [NSMutableArray array];
    

}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.requestType == AMRequestTypeSubscription) {
        
        self.navigationItem.title = @"Subscriptions";
    } else {
        
        self.navigationItem.title = @"Followers";
    }
    
    self.tableView.layer.cornerRadius = 20.f;
    self.tableView.layer.borderColor = [UIColor orangeCustomColor].CGColor;
    self.tableView.layer.borderWidth = 3.0f;
    
}

#pragma mark - Methods

- (void) updateDetailUsers {
    
    __weak typeof(self) weakSelf = self;
    
    for (NSInteger subIndex = 0; subIndex < [weakSelf.requestResults count]; subIndex++) {
        
        id anyResult = [weakSelf.requestResults objectAtIndex:subIndex];
        
        if ([anyResult isKindOfClass:[AMUser class]] && [anyResult valueForKey:@"photo50"] == nil) {
            
            AMUser* anyUser = anyResult;
            
            [[AMServerManager sharedManager] getDetailUserForID:anyUser.userID
                                                      onSuccess:^(AMUser *user) {
                                                          
                                                          [weakSelf.requestResults replaceObjectAtIndex:subIndex withObject:user];
                                                          
                                                          [weakSelf.tableView beginUpdates];
                                                          
                                                          [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:subIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                          
                                                          [weakSelf.tableView endUpdates];

                                                          
                                                      }
                                                      onFailure:nil];
            
        }
    }
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - (CGRectGetHeight(self.tableView.frame)) - CGRectGetHeight(self.tableView.frame) / countInRequest;
    
    if (actualPosition >= contentHeight && !isLoadingMoreResults) {
        
        isLoadingMoreResults = YES;
        NSInteger offset = [self.requestResults count];
        __weak typeof(self) weakSelf = self;
        
        if (self.requestType == AMRequestTypeSubscription) {
            
            [[AMServerManager sharedManager] getSubscriptionsForUserID:self.userID
                                                            withOffset:offset
                                                                 count:countInRequest
                                                             onSuccess:^(NSArray *subscriptions) {
                                                                 
                                                                 [weakSelf.requestResults addObjectsFromArray:subscriptions];
                                                                 
                                                                 [weakSelf.tableView beginUpdates];
                                                                 NSMutableArray* arrayPaths = [NSMutableArray array];
                                                                 for (NSInteger index = [weakSelf.requestResults count] - [subscriptions count]; index < [weakSelf.requestResults count]; index++) {
                                                                     [arrayPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                                                                 }
                                                                 [weakSelf.tableView insertRowsAtIndexPaths:arrayPaths withRowAnimation:UITableViewRowAnimationTop];
                                                                 [weakSelf.tableView endUpdates];
                                                                 
                                                                 isLoadingMoreResults = NO;
                                                                 [weakSelf updateDetailUsers];
                                                             }
                                                             onFailure:^(NSError *error) {
                                                                 
                                                             }];
            
        } else {
            
            [[AMServerManager sharedManager] getFollowersForUserID:self.userID
                                                        withOffset:offset
                                                             count:countInRequest
                                                         onSuccess:^(NSArray *followers) {
                                                             
                                                             [weakSelf.requestResults addObjectsFromArray:followers];
                                                             [weakSelf.tableView beginUpdates];
                                                             
                                                             NSMutableArray* arrayPaths = [NSMutableArray array];
                                                             for (NSInteger index = [weakSelf.requestResults count] - [followers count]; index < [weakSelf.requestResults count]; index++) {
                                                                 [arrayPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                                                             }
                                                             [weakSelf.tableView insertRowsAtIndexPaths:arrayPaths withRowAnimation:UITableViewRowAnimationTop];
                                                             [weakSelf.tableView endUpdates];
                                                             
                                                             isLoadingMoreResults = NO;
                                                             
                                                         }
                                                         onFailure:^(NSError *error) {
                                                             
                                                         }];
        }
        

        
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor orangeCustomColor];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    UIImage* withoutPhoto = [UIImage imageNamed:@"nophoto.png"];
    NSURLRequest* request = nil;
    
    if ([[self.requestResults objectAtIndex:indexPath.row] isKindOfClass:[AMUser class]]) {
        
        AMUser* subscription  = [self.requestResults objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", subscription.firstName, subscription.lastName];
        request = [NSURLRequest requestWithURL:subscription.photo50];
        
    } else if ([[self.requestResults objectAtIndex:indexPath.row] isKindOfClass:[AMSubscription class]]) {
        
        AMSubscription* subscription  = [self.requestResults objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", subscription.name];
        request = [NSURLRequest requestWithURL:subscription.photo50];
        
    }
    
    __weak UITableViewCell* weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:withoutPhoto
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       weakCell.imageView.layer.cornerRadius = 5.f;
                                       weakCell.imageView.layer.masksToBounds = YES;
                                       weakCell.imageView.image = image;
                                   }
                                   failure:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGRectGetHeight(self.tableView.bounds) / countInRequest;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.requestResults count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
    
}

@end
