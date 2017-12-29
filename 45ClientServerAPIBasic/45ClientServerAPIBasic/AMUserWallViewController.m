//
//  AMUserWallViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 08.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMUserWallViewController.h"
#import "AMUser.h"
#import "AMServerManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIColor+AMCustomColor.h"
#import "AMPostTableViewCell.h"
#import "AMRepostTableViewCell.h"
#import "AMAttachmentCollectionViewCell.h"
#import "AMPost.h"
#import "AMGroup.h"
#import "AMPhotoAttachment.h"
#import "AMVideoAttachment.h"
#import "AMLinkAttachment.h"
#import "AMDocAttachment.h"
#import "UIView+UITableViewCell.h"
#import "AMMessagesViewController.h"
#import "AMNewMessageTableViewCell.h"
#import "AMPostViewController.h"
#import "AMAlbumsViewController.h"

const NSInteger recordInRequest = 5;
BOOL isLoadingMoreRecords = NO;

@interface AMUserWallViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, AMPostTableViewCellDelegate, AMRepostTableViewCellDelegate, AMNewMessageTableViewCellDelegate>

@property (strong, nonatomic) AMGroup* group;
@property (strong, nonatomic) NSMutableArray* requestPosts;
@property (strong, nonatomic) NSMutableArray* attachments;
@property (strong, nonatomic) UIRefreshControl* refreshControl;

@end

@implementation AMUserWallViewController


- (void) setUserID:(long)userID {
    
    _userID = userID;
    
    __weak typeof(self) weakSelf = self;
    
    isLoadingMoreRecords = YES;
    
    self.requestPosts = [NSMutableArray array];
    self.attachments = [NSMutableArray array];
    
    [[AMServerManager sharedManager] getWallRecordsForUserID:userID
                                                   withOffset:[weakSelf.requestPosts count]
                                                        count:recordInRequest
                                                    onSuccess:^(NSArray *posts) {
                                                        
                                                        [weakSelf.requestPosts addObjectsFromArray:posts];
                                                        
                                                        for (AMPost* post in posts) {
                                                            
                                                            [self.attachments addObject:[self attachmentsForPost:post]];
                                                            
                                                        }
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [weakSelf.tableView reloadData];
                                                        });
                                                        
                                                        isLoadingMoreRecords = NO;
                                                        
                                                    }
                                                    onFailure:^(NSError *error) {
                                                       
                                                    }];
    
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(actionRefreshMessages) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:refreshControl];
    
    if (self.userID < 0) {
        
        UIBarButtonItem* photoBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nophoto.png"] style:UIBarButtonItemStyleDone target:self action:@selector(actionPhotoAlbums:)];
        UIBarButtonItem* videoBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"video.png"] style:UIBarButtonItemStyleDone target:self action:@selector(actionVideoAlbums:)];
        
        self.navigationItem.rightBarButtonItems = @[photoBarButtonItem, videoBarButtonItem];
        
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.userID > 0) {
        
        self.navigationItem.title = @"User WALL";
        
    } else {
        
        self.navigationItem.title = @"Group WALL";
        
    }
    
    self.tableView.layer.cornerRadius = 20.f;
    self.tableView.layer.borderColor = [UIColor orangeCustomColor].CGColor;
    self.tableView.layer.borderWidth = 3.0f;
    
}

#pragma mark - Actions

- (void)actionRefreshMessages {
    
    __weak typeof(self) weakSelf = self;
    
    isLoadingMoreRecords = YES;
    
    [[AMServerManager sharedManager] getWallRecordsForUserID:self.userID
                                                  withOffset:0
                                                       count:MAX(recordInRequest, [self.requestPosts count])
                                                   onSuccess:^(NSArray *posts) {
                                                       
                                                       [weakSelf.requestPosts removeAllObjects];
                                                       [weakSelf.requestPosts addObjectsFromArray:posts];
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [weakSelf.tableView reloadData];
                                                       });
                                                       
                                                       [weakSelf.refreshControl endRefreshing];
                                                       
                                                       isLoadingMoreRecords = NO;
                                                       
                                                   }
                                                   onFailure:nil];
}

- (void)actionPhotoAlbums:(UIBarButtonItem*)sender {
    
    [self performSegueWithIdentifier:@"AMAlbumsViewController" sender:@(NO)];
    
}

- (void)actionVideoAlbums:(UIBarButtonItem*)sender {
    
    [self performSegueWithIdentifier:@"AMAlbumsViewController" sender:@(YES)];
    
}

#pragma mark - Methods

- (AMPost*) postForIndexPath:(NSIndexPath*)indexPath {
    
    return [self.requestPosts objectAtIndex:indexPath.row-1];
    
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
    
    AMPost* post = [self postForIndexPath:indexPath];
    
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

- (NSString*) textRepostForIndexPath:(NSIndexPath*)indexPath {
    
    AMPost* post = [self postForIndexPath:indexPath];
    
    post = post.repost;
    
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
    CGFloat contentHeight = scrollView.contentSize.height - (CGRectGetHeight(self.tableView.frame)) - CGRectGetHeight(self.tableView.frame) / recordInRequest;
    
    if (actualPosition >= contentHeight && !isLoadingMoreRecords) {
        
        isLoadingMoreRecords = YES;
        NSInteger offset = [self.requestPosts count];
        __weak typeof(self) weakSelf = self;
     
        [[AMServerManager sharedManager] getWallRecordsForUserID:self.userID
                                                      withOffset:offset
                                                           count:recordInRequest
                                                       onSuccess:^(NSArray *posts) {
                                                           
                                                           [weakSelf.requestPosts addObjectsFromArray:posts];
                                                           
                                                           for (AMPost* post in posts) {
                                                               
                                                               [self.attachments addObject:[self attachmentsForPost:post]];
                                                               
                                                           }
                                                           
                                                           [weakSelf.tableView reloadData];
                                                           isLoadingMoreRecords = NO;
                                                           
                                                       }
                                                       onFailure:^(NSError *error) {
                                                           
                                                       }];
        
    }
    
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    UITableViewCell* cell = [collectionView superCell];
    NSIndexPath* indexPathCell = [self.tableView indexPathForRowAtPoint:cell.center];
    
    if ([self.attachments count] > 0) {
        NSArray* attachments = [self.attachments objectAtIndex:indexPathCell.row - 1];
        return [attachments count];
    }
    
    
    return 0;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AMAttachmentCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AMAttachmentCollectionViewCell" forIndexPath:indexPath];
    
    UITableViewCell* cellTable = [collectionView superCell];
    NSIndexPath* indexPathCell = [self.tableView indexPathForRowAtPoint:cellTable.center];
    
    NSArray* attachments = [self.attachments objectAtIndex:indexPathCell.row - 1];
    
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

#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[AMMessagesViewController class]]) {
        
        AMMessagesViewController* messagesController = segue.destinationViewController;
        messagesController.userID = [sender longValue];
        
    } else if ([segue.destinationViewController isKindOfClass:[AMPostViewController class]]) {
        
        AMPostViewController* postController = segue.destinationViewController;
        NSDictionary* infoSegue = (NSDictionary*)sender;
        postController.ownerID = [[infoSegue objectForKey:@"ownerID"] longValue];
        postController.postID = [[infoSegue objectForKey:@"postID"] longValue];
        
    } else if ([segue.destinationViewController isKindOfClass:[AMAlbumsViewController class]]) {
        
        AMAlbumsViewController* albumController = segue.destinationViewController;
        albumController.isVideoAlbums = [sender boolValue];
        albumController.ownerID = self.userID;
        
    }
    
}

#pragma mark - AMPostTableViewCellDelegate, AMRepostTableViewCellDelegate

- (void) didTouchAvatarButton:(UIButton *)sender {
    
    UITableViewCell* cell = [sender superCell];
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    AMPost* post = [self postForIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    
    [[AMServerManager sharedManager] getDetailForOwnerID:post.fromID
                                               onSuccess:^(AMUser *user, AMGroup *group) {
                                                   
                                                   if (user) {
                                                       
                                                       [weakSelf performSegueWithIdentifier:@"AMMessagesViewController" sender:@(user.userID)];
                                                       
                                                   }
                                                   
                                               }
                                               onFailure:nil];
   
}

- (void) didTouchLikeButton:(UIButton *)sender {
    
    UITableViewCell* cell = [sender superCell];
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    AMPost* post = [self postForIndexPath:indexPath];
    
    __weak AMPost* weakPost = post;
    __weak UIButton* weakButton = sender;
    __weak typeof(self) weakSelf = self;
    
    if (post.userLikes == 1) {

        [[AMServerManager sharedManager] deleteLikeForPostID:post.postID
                                                  forOwnerID:post.ownerID
                                                   onSuccess:^(NSInteger countLikes) {
                                                       weakPost.countLikes = countLikes;
                                                       weakPost.userLikes = 0;
                                                       weakButton.imageView.image = [UIImage imageNamed:@"Like.png"];
                                                       [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                   }
                                                   onFailure:nil];
        
    } else {
        
        [[AMServerManager sharedManager] addLikeForPostID:post.postID
                                               forOwnerID:post.ownerID
                                                onSuccess:^(NSInteger countLikes) {
                                                    weakPost.countLikes = countLikes;
                                                    weakPost.userLikes = 1;
                                                    weakButton.imageView.image = [UIImage imageNamed:@"MyLike.png"];
                                                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                }
                                                onFailure:nil];
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > 0) {
        
        AMPost* post = [self postForIndexPath:indexPath];
        
        NSDictionary* infoSegue = [NSDictionary dictionaryWithObjectsAndKeys:@(self.userID), @"ownerID", @(post.postID), @"postID", nil];
        
        [self performSegueWithIdentifier:@"AMPostViewController" sender:infoSegue];
        
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY hh:mm"];
    
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor orangeCustomColor];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    if ([cell isKindOfClass:[AMPostTableViewCell class]]) {
        
        AMPost* post = [self postForIndexPath:indexPath];
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
        
    }
    
    if ([cell isKindOfClass:[AMRepostTableViewCell class]]) {
        
        AMPost* post = [self postForIndexPath:indexPath];
        AMRepostTableViewCell* postCell = (AMRepostTableViewCell*)cell;
        
        postCell.avatarButton.imageView.layer.cornerRadius = 5.f;

        postCell.dateLabel.text = [dateFormatter stringFromDate:post.date];
        
        if (post.userLikes) {
            
            postCell.likeButton.imageView.image = [UIImage imageNamed:@"MyLike.png"];
            
        } else {
            
            postCell.likeButton.imageView.image = [UIImage imageNamed:@"Like.png"];
            
        }
        postCell.likeLabel.text = [NSString stringWithFormat:@"%ld", post.countLikes];
        postCell.commentLabel.text = [NSString stringWithFormat:@"%ld", post.countComments];
        
        __block __weak AMRepostTableViewCell* weakPostCell = postCell;
        
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
                                                                                                    
                                                                                                    [weakPostCell.avatarButton setImage:image forState:UIControlStateNormal];
                                                                                                }
                                                                                                failure:nil];
                                                       
                                                   }
                                                   onFailure:nil];
        //----------------
        
        post = post.repost;
        
        postCell.reAvatarButton.imageView.layer.cornerRadius = 5.f;
        
        postCell.reDateLabel.text = [dateFormatter stringFromDate:post.date];
        
        
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
                                                       
                                                       weakPostCell.reNameLabel.text = nameString;
                                                       
                                                       [postCell.reAvatarButton.imageView setImageWithURLRequest:request
                                                                                       placeholderImage:withoutPhoto
                                                                                                success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                                                                    
                                                                                                    [weakPostCell.reAvatarButton setImage:image forState:UIControlStateNormal];
                                                                                                }
                                                                                                failure:nil];
                                                       
                                                   }
                                                   onFailure:nil];
        
        CGRect frameTextPost = postCell.textPostLabel.frame;
        frameTextPost.size.width = CGRectGetWidth(postCell.bounds) - 40;
        [postCell.textPostLabel setFrame:frameTextPost];
        postCell.textPostLabel.text = post.text;
        [postCell.textPostLabel sizeToFit];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 200;
    }
    
    AMPost* post = [self postForIndexPath:indexPath];
 
    if (post.repost) {

        return 420;
        
    } else {
        
        BOOL image = [[self attachmentsForPost:post] count] > 0 ? YES : NO;
        return [AMPostTableViewCell heightCellForTextPost:[self textPostForIndexPath:indexPath] withImage:image];
    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.requestPosts count] + 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        AMNewMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AMNewMessageTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    }
    
    AMPost* post = [self postForIndexPath:indexPath];
    
    if (post.repost) {
        
        AMRepostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AMRepostTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell.attachmentsView reloadData];
        return cell;
        
    } else {
        
        AMPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AMPostTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell.attachmentsView reloadData];
        return cell;
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
    
    [[AMServerManager sharedManager] newPostForOwnerID:self.userID
                                              withText:cell.messageTextView.text
                                             onSuccess:^(long postID) {
                                                 
                                                 weakCell.messageTextView.text = @"";
                                                 [weakSelf actionRefreshMessages];
                                                 
                                             }
                                             onFailure:nil];
    
}

@end
