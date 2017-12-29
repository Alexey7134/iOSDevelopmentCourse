//
//  AMMessagesViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 21.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMMessagesViewController.h"
#import "AMServerManager.h"
#import "UIColor+AMCustomColor.h"
#import "AMNewMessageTableViewCell.h"
#import "AMInMessageTableViewCell.h"
#import "AMOutMessageTableViewCell.h"
#import "AMMessage.h"
#import "AMUser.h"
#import "AMGroup.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIView+UITableViewCell.h"
#import "UIColor+AMCustomColor.h"

const NSInteger messagesInRequest = 12;
BOOL isLoadingMoreMessages = NO;

@interface AMMessagesViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, AMNewMessageTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray* messages;
@property (strong, nonatomic) UIRefreshControl* refreshControl;

@end

@implementation AMMessagesViewController

- (void) setUserID:(long)userID {
    
    _userID = userID;
    
    self.messages = [NSMutableArray array];
    
    isLoadingMoreMessages = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [[AMServerManager sharedManager] getMessagesForUserID:userID
                                               withOffset:[self.messages count]
                                                    count:messagesInRequest
                                                onSuccess:^(NSArray *messages) {
                                                    
                                                    [weakSelf.messages addObjectsFromArray:messages];
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [weakSelf.tableView reloadData];
                                                    });
                                                    
                                                    isLoadingMoreMessages = NO;
                                                    
                                                }
                                                onFailure:nil];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    
    self.tableView.layer.cornerRadius = 20.f;
    self.tableView.layer.borderColor = [UIColor orangeCustomColor].CGColor;
    self.tableView.layer.borderWidth = 3.0f;
    
    __weak typeof(self) weakSelf = self;
    
    [[AMServerManager sharedManager] getDetailForOwnerID:self.userID
                                               onSuccess:^(AMUser *user, AMGroup *group) {

                                                   if (user) {
                                                       
                                                       weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
                                                   } else if (group) {
                                                       
                                                       weakSelf.navigationItem.title = group.name;
                                                   }
                                                   
                                                   
                                               }
                                               onFailure:nil];
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(actionRefreshMessages) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:refreshControl];
    
}

#pragma mark - Actions

- (void)actionRefreshMessages {
    
    __weak typeof(self) weakSelf = self;
    
    isLoadingMoreMessages = YES;
    
    [[AMServerManager sharedManager] getMessagesForUserID:self.userID
                                               withOffset:0
                                                    count:MAX(messagesInRequest, [self.messages count])
                                                onSuccess:^(NSArray *messages) {
                                                    
                                                    [weakSelf.messages removeAllObjects];
                                                    [weakSelf.messages addObjectsFromArray:messages];
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [weakSelf.tableView reloadData];
                                                    });
                                                    
                                                    [weakSelf.refreshControl endRefreshing];
                                                    isLoadingMoreMessages = NO;
                                                    
                                                }
                                                onFailure:nil];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - (CGRectGetHeight(self.tableView.frame)) - CGRectGetHeight(self.tableView.frame) / messagesInRequest;
    
    if (actualPosition >= contentHeight && !isLoadingMoreMessages) {
        
        isLoadingMoreMessages = YES;
        
        NSInteger offset = [self.messages count];
        __weak typeof(self) weakSelf = self;
        
        [[AMServerManager sharedManager] getMessagesForUserID:self.userID
                                                   withOffset:offset
                                                        count:messagesInRequest
                                                    onSuccess:^(NSArray *messages) {
                                                        
                                                        [weakSelf.messages addObjectsFromArray:messages];
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            [weakSelf.tableView beginUpdates];
                                                            
                                                            NSMutableArray* arrayPaths = [NSMutableArray array];
                                                            for (NSInteger index = [weakSelf.messages count] - [messages count]; index < [weakSelf.messages count]; index++) {
                                                                [arrayPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                                                            }
                                                            [weakSelf.tableView insertRowsAtIndexPaths:arrayPaths withRowAnimation:UITableViewRowAnimationTop];
                                                            [weakSelf.tableView endUpdates];
                                                            
                                                        });
                                                        
                                                        isLoadingMoreMessages = NO;
                                                        
                                                    }
                                                    onFailure:nil];
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
    
    if (indexPath.row > 0) {
        
        AMMessage* message = [self.messages objectAtIndex:indexPath.row - 1];
        UIImage* withoutPhoto = [UIImage imageNamed:@"nophoto.png"];
        
        if ([cell isKindOfClass:[AMOutMessageTableViewCell class]]) {
            
            
            
            AMOutMessageTableViewCell* outCell = (AMOutMessageTableViewCell*)cell;
            
            CGRect frame = outCell.messageLabel.frame;
            frame.size.width = CGRectGetWidth(outCell.bounds) - 60;
            [outCell.messageLabel setFrame:frame];
            
            outCell.messageLabel.text = message.text;
            [outCell.messageLabel sizeToFit];
            
            AMUser* user = [[AMServerManager sharedManager] isLogin];
            
            NSURLRequest* request = [NSURLRequest requestWithURL:user.photo50];
            
            __weak typeof(outCell) weakCell = outCell;
            
            outCell.userImageView.layer.cornerRadius = 5.f;
            outCell.userImageView.layer.masksToBounds = YES;
            
            [outCell.userImageView setImageWithURLRequest:request
                                  placeholderImage:withoutPhoto
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                               
                                               weakCell.userImageView.image = image;
                                               
                                           }
                                           failure:nil];
            
        } else if ([cell isKindOfClass:[AMInMessageTableViewCell class]]) {
         
            AMInMessageTableViewCell* inCell = (AMInMessageTableViewCell*)cell;
            
            CGRect frame = inCell.messageLabel.frame;
            frame.size.width = CGRectGetWidth(inCell.bounds) - 60;
            [inCell.messageLabel setFrame:frame];
            inCell.messageLabel.text = message.text;
            [inCell.messageLabel sizeToFit];
            
            __weak typeof(inCell) weakCell = inCell;
            
            [[AMServerManager sharedManager] getDetailForOwnerID:self.userID
                                                       onSuccess:^(AMUser *user, AMGroup *group) {
                                                           
                                                           NSURLRequest* request = nil;
                                                           
                                                           if (user) {
                                                               
                                                               request = [NSURLRequest requestWithURL:user.photo50];
                                                           } else if (group) {
                                                               
                                                               request = [NSURLRequest requestWithURL:group.photo50];
                                                           }
                                                           
                                                           weakCell.userImageView.layer.cornerRadius = 5.f;
                                                           weakCell.userImageView.layer.masksToBounds = YES;
                                                           
                                                           [weakCell.userImageView setImageWithURLRequest:request
                                                                                 placeholderImage:withoutPhoto
                                                                                          success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                                                              
                                                                                              weakCell.userImageView.image = image;
                                                                                              
                                                                                          }
                                                                                          failure:nil];
                                                           
                                                       }
                                                       onFailure:nil];
            
        }
        

        
    }
    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 200;
    }
    
    AMMessage* message = [self.messages objectAtIndex:indexPath.row - 1];
    
    if (message.outState == 1) {
        
        return [AMOutMessageTableViewCell heightCellForTextPost:message.text withImage:NO];
        
    } else {
        
        return [AMInMessageTableViewCell heightCellForTextPost:message.text withImage:NO];
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.messages count] + 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        AMNewMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AMNewMessageTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    } else {
        
        AMMessage* message = [self.messages objectAtIndex:indexPath.row - 1];
        
        if (message.outState == 0) {
            
            AMInMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AMInMessageTableViewCell" forIndexPath:indexPath];
            
            return cell;
            
        } else {
            
            AMOutMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AMOutMessageTableViewCell" forIndexPath:indexPath];
            
            return cell;
            
        }
        
    }
    
}

#pragma mark - AMNewMessageTableViewCellDelegate

- (void) didTouchSendButton:(UIButton*)sender {
    
    AMNewMessageTableViewCell* cell = (AMNewMessageTableViewCell*)[sender superCell];
    
    if ([cell.messageTextView.text isEqualToString:@""]) {
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    
    [[AMServerManager sharedManager] sendMessage:cell.messageTextView.text
                                        toUserID:self.userID
                                       onSuccess:^(long messageID) {
                                           
                                           weakCell.messageTextView.text = @"";
                                           [weakSelf actionRefreshMessages];
                                           
                                           
                                       }
                                       onFailure:nil];
    
}

@end
