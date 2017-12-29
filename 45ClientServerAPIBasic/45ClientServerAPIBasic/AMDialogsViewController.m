//
//  AMDialogsViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 21.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDialogsViewController.h"
#import "AMServerManager.h"
#import "AMUser.h"
#import "AMGroup.h"
#import "AMMessage.h"
#import "UIColor+AMCustomColor.h"
#import "AMDialogTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AMMessagesViewController.h"

const NSInteger dialogsInRequest = 6;
BOOL isLoadingMoreDialogs = NO;

@interface AMDialogsViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray* dialogs;

@end

@implementation AMDialogsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"Dialogs";
    
    self.tableView.layer.cornerRadius = 20.f;
    self.tableView.layer.borderColor = [UIColor orangeCustomColor].CGColor;
    self.tableView.layer.borderWidth = 3.0f;
    
    self.dialogs = [NSMutableArray array];
    
    isLoadingMoreDialogs = YES;
    __weak typeof(self) weakSelf = self;
    
    [[AMServerManager sharedManager] getDialogsWithOffset:0
                                                    count:dialogsInRequest
                                                onSuccess:^(NSArray *dialogs) {
                                                    
                                                    [weakSelf.dialogs addObjectsFromArray:dialogs];
                                                    [weakSelf.tableView reloadData];
                                                    isLoadingMoreDialogs = NO;
                                                    
                                                }
                                                onFailure:nil];
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - (CGRectGetHeight(self.tableView.frame)) - CGRectGetHeight(self.tableView.frame) / dialogsInRequest;
    
    if (actualPosition >= contentHeight && !isLoadingMoreDialogs) {
        
        isLoadingMoreDialogs = YES;
        NSInteger offset = [self.dialogs count];
        __weak typeof(self) weakSelf = self;
        
        [[AMServerManager sharedManager] getDialogsWithOffset:offset
                                                        count:dialogsInRequest
                                                    onSuccess:^(NSArray *dialogs) {
                                                        
                                                        [weakSelf.dialogs addObjectsFromArray:dialogs];
                                                        
                                                        [weakSelf.tableView beginUpdates];
                                                        NSMutableArray* arrayPaths = [NSMutableArray array];
                                                        for (NSInteger index = [weakSelf.dialogs count] - [dialogs count]; index < [weakSelf.dialogs count]; index++) {
                                                            [arrayPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                                                        }
                                                        [weakSelf.tableView insertRowsAtIndexPaths:arrayPaths withRowAnimation:UITableViewRowAnimationTop];
                                                        [weakSelf.tableView endUpdates];
                                                        
                                                        isLoadingMoreDialogs = NO;
                                                        
                                                    }
                                                    onFailure:nil];
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMMessage* message = [self.dialogs objectAtIndex:indexPath.row];
     
    [self performSegueWithIdentifier:@"AMMessagesViewController" sender:@(message.fromID)];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AMMessage* message = [self.dialogs objectAtIndex:indexPath.row];

    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor orangeCustomColor];
    cell.selectedBackgroundView = selectedBackgroundView;
        
    if ([cell isKindOfClass:[AMDialogTableViewCell class]]) {
        
        AMDialogTableViewCell* dialogCell = (AMDialogTableViewCell*)cell;
        
        __weak AMDialogTableViewCell* weakDialogCell = dialogCell;
        
        
        
        [[AMServerManager sharedManager] getDetailForOwnerID:message.fromID
                                                   onSuccess:^(AMUser *user, AMGroup *group) {
                                                       if (user) {
                                                           
                                                           weakDialogCell.dialogLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
                                                           
                                                           NSURLRequest* request = [NSURLRequest requestWithURL:user.photo50];
                                                           [weakDialogCell.dialogAvatarImageView setImageWithURLRequest:request
                                                                                                   placeholderImage:[UIImage imageNamed:@"nophoto.png"]
                                                                                                            success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                                                                                
                                                                                                                weakDialogCell.dialogAvatarImageView.layer.cornerRadius = 5.f;
                                                                                                                weakDialogCell.dialogAvatarImageView.image = image;
                                                                                                                
                                                                                                            }
                                                                                                            failure:nil];
                                                           
                                                           
                                                       }
                                                       if (group) {
                                                           
                                                           weakDialogCell.dialogLabel.text = group.name;
                                                           
                                                           NSURLRequest* request = [NSURLRequest requestWithURL:group.photo50];
                                                           [weakDialogCell.dialogAvatarImageView setImageWithURLRequest:request
                                                                                                       placeholderImage:[UIImage imageNamed:@"nophoto.png"]
                                                                                                                success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                                                                                    
                                                                                                                    weakDialogCell.dialogAvatarImageView.layer.cornerRadius = 5.f;
                                                                                                                    weakDialogCell.dialogAvatarImageView.image = image;
                                                                                                                    
                                                                                                                }
                                                                                                                failure:nil];
                                                       }
                                                   }
                                                   onFailure:nil];
        
        CGRect frameMessageLabel = dialogCell.messageLabel.frame;
        CGRect frameAvatar = dialogCell.userAvatarImageView.frame;
        
        if (message.outState == 1) {
            
            frameMessageLabel.origin.x = frameAvatar.origin.x + 40;
            [dialogCell.messageLabel setFrame:frameMessageLabel];
            
            AMUser* user = [[AMServerManager sharedManager] isLogin];
            
            if (user) {
                
                NSURLRequest* request = [NSURLRequest requestWithURL:user.photo50];
                [dialogCell.userAvatarImageView setImageWithURLRequest:request
                                                            placeholderImage:[UIImage imageNamed:@"nophoto.png"]
                                                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                                         
                                                                         weakDialogCell.userAvatarImageView.layer.cornerRadius = 5.f;
                                                                         weakDialogCell.userAvatarImageView.image = image;
                                                                         
                                                                     }
                                                                     failure:nil];
            }
            
        } else {
            
            frameMessageLabel.origin.x = frameAvatar.origin.x;
            [dialogCell.messageLabel setFrame:frameMessageLabel];
            
            [dialogCell.userAvatarImageView setImage:nil];
            
        }
        
        dialogCell.messageLabel.text = message.text;
        
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dialogs count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AMDialogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AMDialogTableViewCell" forIndexPath:indexPath];
    
    return cell;
    
}


#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    AMMessagesViewController* messagesController = segue.destinationViewController;
    messagesController.userID = [sender longValue];

}


@end
