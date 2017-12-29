//
//  AMMediaViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 26.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMMediaViewController.h"
#import "AMAttachmentCollectionViewCell.h"
#import "AMServerManager.h"
#import "UIColor+AMCustomColor.h"
#import "AMPhotoAttachment.h"
#import "AMVideoAttachment.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

const NSInteger mediaInRequest = 5;
BOOL isLoadingMoreMedia = NO;

@interface AMMediaViewController () <UICollectionViewDataSource, UIScrollViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSMutableArray* media;
@property (strong, nonatomic) UIRefreshControl* refreshControl;

@end

@implementation AMMediaViewController

- (void) setAlbumID:(long)albumID {
    
    _albumID = albumID;
    
    __weak typeof(self) weakSelf = self;
    
    isLoadingMoreMedia = YES;
    
    self.media = [NSMutableArray array];
    
    if (!self.isVideo) {
        
        [[AMServerManager sharedManager] getPhotosForAlbumID:albumID
                                                     ownerID:self.ownerID
                                                  withOffset:0
                                                       count:mediaInRequest
                                                   onSuccess:^(NSArray *photos) {
                                                       
                                                       [weakSelf.media addObjectsFromArray:photos];
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [weakSelf.collectionView reloadData];
                                                       });
                                                       
                                                       isLoadingMoreMedia = NO;
                                                       
                                                   }
                                                   onFailure:nil];
        
    } else {
        
        
        [[AMServerManager sharedManager] getVideosForAlbumID:albumID
                                                     ownerID:self.ownerID
                                                  withOffset:0
                                                       count:mediaInRequest
                                                   onSuccess:^(NSArray *videos) {
                                                       
                                                       [weakSelf.media addObjectsFromArray:videos];
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [weakSelf.collectionView reloadData];
                                                       });
                                                       
                                                       isLoadingMoreMedia = NO;
                                                       
                                                   }
                                                   onFailure:nil];
        
    }

}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!self.isVideo) {
        
        UIBarButtonItem* addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddPhoto:)];
        
        self.navigationItem.rightBarButtonItems = @[addBarButtonItem];
        self.navigationItem.title = @"Photos";
        
    } else {
        
        self.navigationItem.title = @"Videos";
        
    }
 
    self.collectionView.layer.cornerRadius = 20.f;
    self.collectionView.layer.borderColor = [UIColor orangeCustomColor].CGColor;
    self.collectionView.layer.borderWidth = 3.0f;
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(actionRefreshMedia) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.collectionView addSubview:refreshControl];
    
}

#pragma mark - Actions

- (void)actionRefreshMedia {
    
    __weak typeof(self) weakSelf = self;
    
    isLoadingMoreMedia = YES;
    
    if (!self.isVideo) {
        
        [[AMServerManager sharedManager] getPhotosForAlbumID:self.albumID
                                                     ownerID:self.ownerID
                                                  withOffset:0
                                                       count:MAX(mediaInRequest, [self.media count])
                                                   onSuccess:^(NSArray *photos) {
                                                       
                                                       [weakSelf.media removeAllObjects];
                                                       [weakSelf.media addObjectsFromArray:photos];
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [weakSelf.collectionView reloadData];
                                                       });
                                                       
                                                       isLoadingMoreMedia = NO;
                                                       
                                                   }
                                                   onFailure:nil];
        
    } else {
        
        [[AMServerManager sharedManager] getVideosForAlbumID:self.albumID
                                                     ownerID:self.ownerID
                                                  withOffset:0
                                                       count:MAX(mediaInRequest, [self.media count])
                                                   onSuccess:^(NSArray *videos) {
                                                       
                                                       [weakSelf.media removeAllObjects];
                                                       [weakSelf.media addObjectsFromArray:videos];
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [weakSelf.collectionView reloadData];
                                                       });
                                                       
                                                       isLoadingMoreMedia = NO;
                                                       
                                                   }
                                                   onFailure:nil];
        
        
    }
    
}

- (void)actionAddPhoto:(UIBarButtonItem*)sender {
    
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerLibrary.delegate = self;
    [self presentViewController:pickerLibrary animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [[AMServerManager sharedManager] loadPhoto:image
                                     toAlbumID:self.albumID
                                   withOwnerID:self.ownerID
                                     onSuccess:^(long photoID) {
                                         
                                         if (photoID > 0) {
                                             
                                             [self actionRefreshMedia];
                                             
                                         }
                                     }
                                     onFailure:nil];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - (CGRectGetHeight(self.collectionView.frame)) - CGRectGetHeight(self.collectionView.frame) / mediaInRequest;
    
    if (actualPosition >= contentHeight && !isLoadingMoreMedia) {
        
        isLoadingMoreMedia = YES;
        NSInteger offset = [self.media count];
        __weak typeof(self) weakSelf = self;
        
        if (!self.isVideo) {
            
            [[AMServerManager sharedManager] getPhotosForAlbumID:self.albumID
                                                         ownerID:self.ownerID
                                                      withOffset:offset
                                                           count:mediaInRequest
                                                       onSuccess:^(NSArray *photos) {
                                                           
                                                           [weakSelf.media addObjectsFromArray:photos];
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               
                                                               [weakSelf.collectionView reloadData];
                                                               
                                                           });
                                                           
                                                           isLoadingMoreMedia = NO;
                                                           
                                                       }
                                                       onFailure:nil];
            
        } else {
            
            
            [[AMServerManager sharedManager] getVideosForAlbumID:self.albumID
                                                         ownerID:self.ownerID
                                                      withOffset:offset
                                                           count:mediaInRequest
                                                       onSuccess:^(NSArray *videos) {
                                                           
                                                           [weakSelf.media addObjectsFromArray:videos];
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [weakSelf.collectionView reloadData];
                                                           });
                                                           
                                                           isLoadingMoreMedia = NO;
                                                           
                                                       }
                                                       onFailure:nil];
            
        }
        
    }
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id media = [self.media objectAtIndex:indexPath.row];
    
    if ([media isKindOfClass:[AMVideoAttachment class]]) {
        
        AMVideoAttachment* video = (AMVideoAttachment*)media;
        
        NSString* pathVideo = video.link.absoluteString;
        
        if ([pathVideo rangeOfString:@"youtube.com"].location != NSNotFound) {
            
            
            UIViewController* playerViewController = [[UIViewController alloc] init];
            
            CGRect frame = self.view.frame;
            frame.origin = CGPointZero;
            frame.origin.y += 64;
            frame.size.height -= 64;
            
            UIWebView* webView = [[UIWebView alloc] initWithFrame:frame];
            webView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [webView loadRequest:[NSURLRequest requestWithURL:video.link]];
            
            [playerViewController.view addSubview:webView];
            
            [self.navigationController pushViewController:playerViewController animated:YES];
            
        } else {
        
            AVPlayer *player = [AVPlayer playerWithURL:video.link];
            AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
            playerViewController.player = player;
            [self presentViewController:playerViewController animated:YES completion:nil];
        }
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage* withoutPhoto = [UIImage imageNamed:@"nophoto.png"];
    NSURLRequest* request;
    
    id media = [self.media objectAtIndex:indexPath.row];
    
    if ([media isKindOfClass:[AMPhotoAttachment class]]) {
        
        AMPhotoAttachment* photo = (AMPhotoAttachment*)media;
        
        request = [NSURLRequest requestWithURL:photo.photo604];
        
    } else if ([media isKindOfClass:[AMVideoAttachment class]]) {
        
        AMVideoAttachment* video = (AMVideoAttachment*)media;
        
        request = [NSURLRequest requestWithURL:video.photo320];
        
    }
     
     __weak AMAttachmentCollectionViewCell* weakCell = (AMAttachmentCollectionViewCell*)cell;
    
    [weakCell.attachmentImageView setImageWithURLRequest:request
                                        placeholderImage:withoutPhoto
                                                 success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                     weakCell.attachmentImageView.image = image;
                                                 }
                                                 failure:nil];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.media count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AMAttachmentCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AMAttachmentCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
    
}


@end
