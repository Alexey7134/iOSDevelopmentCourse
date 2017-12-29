//
//  AMPostViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 24.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMPostViewController.h"
#import "AMServerManager.h"
#import "AMPost.h"
#import "AMUser.h"
#import "AMGroup.h"
#import "AMComment.h"
#import "UIColor+AMCustomColor.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AMPostTableViewCell.h"
#import "AMRepostTableViewCell.h"
#import "AMNewMessageTableViewCell.h"
#import "AMAttachmentCollectionViewCell.h"
#import "UIView+UITableViewCell.h"
#import "AMCommentTableViewCell.h"
#import "AMPhotoAttachment.h"
#import "AMVideoAttachment.h"
#import "AMLinkAttachment.h"
#import "AMDocAttachment.h"

const NSInteger commentsInRequest = 5;
BOOL isLoadingMoreComments = NO;

@interface AMPostViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate, AMNewMessageTableViewCellDelegate, AMPostTableViewCellDelegate, AMCommentTableViewCellDelegate>

@property (strong, nonatomic) AMPost* post;
@property (strong, nonatomic) NSMutableArray* comments;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (strong, nonatomic) NSMutableArray* attachments;

@end

@implementation AMPostViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"POST";
    
    self.tableView.layer.cornerRadius = 20.f;
    self.tableView.layer.borderColor = [UIColor orangeCustomColor].CGColor;
    self.tableView.layer.borderWidth = 3.0f;
    
    self.attachments = [NSMutableArray array];
    self.comments = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [[AMServerManager sharedManager] getDetailPostForID:self.postID
                                            withOwnerID:self.ownerID
                                              onSuccess:^(AMPost *post) {
                                                  
                                                  weakSelf.post = post;
                                                  [self.attachments addObject:[self attachmentsForPost:post]];
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [weakSelf.tableView reloadData];
                                                  });
                                                  
                                                  isLoadingMoreComments = YES;
                                                  
                                                  [[AMServerManager sharedManager] getCommentsForPostID:weakSelf.postID
                                                                                            withOwnerID:weakSelf.ownerID
                                                                                             withOffset:0
                                                                                                  count:commentsInRequest
                                                                                              onSuccess:^(NSArray *comments) {
                                                                                                  
                                                                                                  [weakSelf.comments addObjectsFromArray:comments];
                                                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                      [weakSelf.tableView reloadData];
                                                                                                  });
                                                                                                  isLoadingMoreComments = NO;
                                                                                                  
                                                                                              }
                                                                                              onFailure:nil];
                                                  
                                              }
                                              onFailure:nil];
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(actionRefreshComments) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:refreshControl];
    
}

#pragma mark - Actions

- (void)actionRefreshComments {
    
    __weak typeof(self) weakSelf = self;
    
    isLoadingMoreComments = YES;
    
    [[AMServerManager sharedManager] getCommentsForPostID:weakSelf.postID
                                              withOwnerID:weakSelf.ownerID
                                               withOffset:0
                                                    count:commentsInRequest
                                                onSuccess:^(NSArray *comments) {
                                                    
                                                    [weakSelf.comments removeAllObjects];
                                                    [weakSelf.comments addObjectsFromArray:comments];
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [weakSelf.tableView reloadData];
                                                    });
                                                    
                                                    [weakSelf.refreshControl endRefreshing];

                                                    isLoadingMoreComments = NO;
                                                    
                                                }
                                                onFailure:nil];
}

#pragma mark - Methods

- (AMComment*) commentForIndexPath:(NSIndexPath*)indexPath {
    
    return [self.comments objectAtIndex:indexPath.row - 2];
    
}

- (NSArray*) attachmentsForPost:(AMPost*)post {
    
    NSMutableArray* attachments = [NSMutableArray array];
    
    if (post.attachments) {
        
        if ([post.attachments count] > 0) {
            
            for (id anyAttachment in post.attachments) {
                if ([anyAttachment isKindOfClass:[AMPhotoAttachment class]] || [anyAttachment isKindOfClass:[AMVideoAttachment class]]) {
                    
                    [attachments addObject:anyAttachment];
                    
                }
            }
            
        } else if (post.repost) {
            
            [attachments addObjectsFromArray:[self attachmentsForPost:post.repost]];
            
        }
        
    }
    
    return attachments;
    
}

- (NSString*) textPostForIndexPath:(NSIndexPath*)indexPath {
    
    AMPost* post = self.post;
    
    NSString* textPost = post.text;
    
    if ([post.attachments count] > 0) {
        
        for (id attachment in post.attachments) {
            
            if ([attachment isKindOfClass:[AMLinkAttachment class]]) {
                
                AMLinkAttachment* linkAttachment = attachment;
                
                textPost = [textPost stringByAppendingFormat:@"\n%@\n", linkAttachment.link];
                
                
            } else if ([attachment isKindOfClass:[AMDocAttachment class]]) {
                
                AMDocAttachment* docAttachment = attachment;
                
                textPost = [textPost stringByAppendingFormat:@"\n%@\n", docAttachment.url];
                
            }
        }
    }
    
    
    return textPost;
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - (CGRectGetHeight(self.tableView.frame)) - CGRectGetHeight(self.tableView.frame) / commentsInRequest;
    
    if (actualPosition >= contentHeight && !isLoadingMoreComments) {
        
        isLoadingMoreComments = YES;
        
        NSInteger offset = [self.comments count];
     
     
        __weak typeof(self) weakSelf = self;
        
        isLoadingMoreComments = YES;
        
        [[AMServerManager sharedManager] getCommentsForPostID:weakSelf.postID
                                                  withOwnerID:weakSelf.ownerID
                                                   withOffset:offset
                                                        count:commentsInRequest
                                                    onSuccess:^(NSArray *comments) {
                                                        
                                                        [weakSelf.comments addObjectsFromArray:comments];
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            [weakSelf.tableView beginUpdates];
                                                            
                                                            NSMutableArray* arrayPaths = [NSMutableArray array];
                                                            for (NSInteger index = [weakSelf.comments count] - [comments count]; index < [weakSelf.comments count]; index++) {
                                                                [arrayPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                                                            }
                                                            [weakSelf.tableView insertRowsAtIndexPaths:arrayPaths withRowAnimation:UITableViewRowAnimationTop];
                                                            [weakSelf.tableView endUpdates];
                                                            
                                                        });
                                                        
                                                        [weakSelf.refreshControl endRefreshing];
                                                        
                                                        isLoadingMoreComments = NO;
                                                        
                                                    }
                                                    onFailure:nil];
        
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    UITableViewCell* cell = [collectionView superCell];
    NSIndexPath* indexPathCell = [self.tableView indexPathForRowAtPoint:cell.center];
    
    if ([self.attachments count] > 0) {
        NSArray* attachments = [self.attachments objectAtIndex:indexPathCell.row];
        return [attachments count];
    }
    
    return 0;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AMAttachmentCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AMAttachmentCollectionViewCell" forIndexPath:indexPath];
    
    UITableViewCell* cellTable = [collectionView superCell];
    NSIndexPath* indexPathCell = [self.tableView indexPathForRowAtPoint:cellTable.center];
    
    NSArray* attachments = [self.attachments objectAtIndex:indexPathCell.row];
    
    id attachment = [attachments objectAtIndex:indexPath.row];
    
    UIImage* withoutPhoto = [UIImage imageNamed:@"nophoto.png"];
    NSURLRequest* request = nil;
    
    if ([attachment isKindOfClass:[AMPhotoAttachment class]]) {
        
        AMPhotoAttachment* photoAttachment = attachment;
        
        request = [NSURLRequest requestWithURL:photoAttachment.photo604];
        
    } else if ([attachment isKindOfClass:[AMVideoAttachment class]]){
        
        AMVideoAttachment* videoAttachment = attachment;
        
        request = [NSURLRequest requestWithURL:videoAttachment.photo320];
        
    }
    
    __weak AMAttachmentCollectionViewCell* weakCell = cell;
    
    [cell.attachmentImageView setImageWithURLRequest:request
                                    placeholderImage:withoutPhoto
                                             success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                 
                                                 [weakCell.attachmentImageView setImage:image];
                                                 [weakCell.contentView setNeedsDisplay];
                                                 
                                             }
                                             failure:nil];
    
    return cell;
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor orangeCustomColor];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    if (indexPath.row == 0) {
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.YYYY hh:mm"];
  
        AMPost* post = self.post;
        AMPostTableViewCell* postCell = (AMPostTableViewCell*)cell;
        
        postCell.avatarButton.imageView.layer.cornerRadius = 5.f;
        
        __block __weak AMPostTableViewCell* weakPostCell = postCell;
        
        [[AMServerManager sharedManager] getDetailForOwnerID:post.fromID
                                                   onSuccess:^(AMUser *user, AMGroup *group) {
                                                       
                                                       UIImage* withoutPhoto = [UIImage imageNamed:@"nophoto.png"];
                                                       NSString* nameString = nil;
                                                       NSURLRequest* request = nil;
                                                       
                                                       if (user) {
                                                           nameString = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
                                                           request = [NSURLRequest requestWithURL:user.photo50];
                                                       }
                                                       
                                                       if (group) {
                                                           
                                                           nameString = group.name;
                                                           request = [NSURLRequest requestWithURL:group.photo50];
                                                       }
                                                       
                                                       weakPostCell.nameLabel.text = nameString;
                                                       
                                                       [postCell.avatarButton.imageView setImageWithURLRequest:request
                                                                                              placeholderImage:withoutPhoto
                                                                                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                                                                           
                                                                                                           [postCell.avatarButton setImage:image forState:UIControlStateNormal];
                                                                                                       }
                                                                                                       failure:nil];
                                                       
                                                   }
                                                   onFailure:nil];
        
        postCell.dateLabel.text = [dateFormatter stringFromDate:post.date];
        
        CGRect frameTextPost = postCell.textPostLabel.frame;
        frameTextPost.size.width = CGRectGetWidth(postCell.bounds) - 20;
        [postCell.textPostLabel setFrame:frameTextPost];
        postCell.textPostLabel.text = [self textPostForIndexPath:indexPath];
        [postCell.textPostLabel sizeToFit];
        
        if (post.userLikes) {
            
            postCell.likeButton.imageView.image = [UIImage imageNamed:@"MyLike.png"];
            
        } else {
            
            postCell.likeButton.imageView.image = [UIImage imageNamed:@"Like.png"];
            
        }
        postCell.likeLabel.text = [NSString stringWithFormat:@"%ld", post.countLikes];
        postCell.commentLabel.text = [NSString stringWithFormat:@"%ld", post.countComments];
        
        CGRect frameAttachments = postCell.attachmentsView.frame;
        if ([[self attachmentsForPost:post] count] == 0) {
            
            frameAttachments.size.height = 0.f;
            
        } else {
            
            frameAttachments.size.height = 190.f;
            
        }
        [postCell.attachmentsView setFrame:frameAttachments];
            
        
        
    } else if (indexPath.row > 1) {

        AMComment* comment = [self commentForIndexPath:indexPath];
        
        UIImage* withoutPhoto = [UIImage imageNamed:@"nophoto.png"];
        

        AMCommentTableViewCell* inCell = (AMCommentTableViewCell*)cell;
        
        inCell.commentLabel.text = comment.text;
         
        [inCell.commentLabel sizeToFit];
        
        __weak typeof(inCell) weakCell = inCell;
        
        [[AMServerManager sharedManager] getDetailForOwnerID:comment.fromID
                                                   onSuccess:^(AMUser *user, AMGroup *group) {
                                                       
                                                       NSURLRequest* request = nil;
                                                       
                                                       if (user) {
                                                           
                                                           request = [NSURLRequest requestWithURL:user.photo50];
                                                       } else if (group) {
                                                           
                                                           request = [NSURLRequest requestWithURL:group.photo50];
                                                       }
                                                       
                                                       weakCell.avatarImageView.layer.cornerRadius = 5.f;
                                                       weakCell.avatarImageView.layer.masksToBounds = YES;
                                                       
                                                       [weakCell.avatarImageView setImageWithURLRequest:request
                                                                                     placeholderImage:withoutPhoto
                                                                                              success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                                                                  
                                                                                                  weakCell.avatarImageView.image = image;
                                                                                                  
                                                                                              }
                                                                                              failure:nil];
                                                       
                                                   }
                                                   onFailure:nil];
        
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        
        BOOL image = [[self attachmentsForPost:self.post] count] > 0 ? YES : NO;
        return [AMPostTableViewCell heightCellForTextPost:[self textPostForIndexPath:indexPath] withImage:image];
        
    } else if (indexPath.row == 1) {
        
        return 200;
        
    } else {
        
        return [AMCommentTableViewCell heightCellForTextComment:[self commentForIndexPath:indexPath].text withImage:NO];
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.comments count] + 2;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {

        AMPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AMPostTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell.attachmentsView reloadData];
        return cell;
        
    } else if (indexPath.row == 1) {
        
        AMNewMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AMNewMessageTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    } else {

        AMCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AMCommentTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;

    }
    
    return nil;
}

#pragma mark - AMNewMessageTableViewCellDelegate

- (void) didTouchSendButton:(UIButton*)sender {

    AMNewMessageTableViewCell* cell = (AMNewMessageTableViewCell*)[sender superCell];
    
    if ([cell.messageTextView.text isEqualToString:@""]) {
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    
    [[AMServerManager sharedManager] newCommentForPostID:self.postID
                                             withOwnerID:self.ownerID
                                                withText:cell.messageTextView.text
                                               onSuccess:^(long commentID) {
                                                   weakCell.messageTextView.text = @"";
                                                   [weakSelf actionRefreshComments];
                                               }
                                               onFailure:nil];
    
}

#pragma mark - AMPostTableViewCellDelegate, AMCommentTableViewCellDelegate

- (void) didTouchLikeButton:(UIButton*)sender {
    
    UITableViewCell* cell = [sender superCell];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        
    __weak AMPost* weakPost = self.post;
    __weak UIButton* weakButton = sender;
    __weak typeof(self) weakSelf = self;
    
    if (self.post.userLikes == 1) {
        
        [[AMServerManager sharedManager] deleteLikeForPostID:self.postID
                                                  forOwnerID:self.ownerID
                                                   onSuccess:^(NSInteger countLikes) {
                                                       weakPost.countLikes = countLikes;
                                                       weakPost.userLikes = 0;
                                                       weakButton.imageView.image = [UIImage imageNamed:@"Like.png"];
                                                       [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                   }
                                                   onFailure:nil];
        
    } else {
        
        [[AMServerManager sharedManager] addLikeForPostID:self.postID
                                               forOwnerID:self.ownerID
                                                onSuccess:^(NSInteger countLikes) {
                                                    weakPost.countLikes = countLikes;
                                                    weakPost.userLikes = 1;
                                                    weakButton.imageView.image = [UIImage imageNamed:@"MyLike.png"];
                                                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                }
                                                onFailure:nil];
    }

}

@end
