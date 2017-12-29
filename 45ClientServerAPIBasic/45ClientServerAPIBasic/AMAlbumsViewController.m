//
//  AMAlbumsViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 25.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMAlbumsViewController.h"
#import "AMServerManager.h"
#import "AMAlbum.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIColor+AMCustomColor.h"
#import "AMMediaViewController.h"


const NSInteger albumInRequest = 10;
BOOL isLoadingMoreAlbums = NO;

@interface AMAlbumsViewController ()

@property (strong, nonatomic) NSMutableArray* albums;

@end

@implementation AMAlbumsViewController

- (void) setOwnerID:(long)ownerID {
    
    _ownerID = ownerID;
    
    self.albums = [NSMutableArray array];
    
    isLoadingMoreAlbums = YES;
    __weak typeof(self) weakSelf = self;
    
    [[AMServerManager sharedManager] getAlbumsForOwnerID:ownerID
                                                   video:self.isVideoAlbums
                                              withOffset:0
                                                   count:albumInRequest
                                               onSuccess:^(NSArray *albums) {
                                                   
                                                   [weakSelf.albums addObjectsFromArray:albums];
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [weakSelf.tableView reloadData];
                                                   });
                                                   isLoadingMoreAlbums = NO;
                                                   
                                               }
                                               onFailure:nil];
}

#pragma mark - UIView Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.layer.cornerRadius = 20.f;
    self.tableView.layer.borderColor = [UIColor orangeCustomColor].CGColor;
    self.tableView.layer.borderWidth = 3.0f;
    
    if (!self.isVideoAlbums) {
        
        self.navigationItem.title = @"Photos album";
        
    } else {
        
        self.navigationItem.title = @"Videos album";
        
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - (CGRectGetHeight(self.tableView.frame)) - CGRectGetHeight(self.tableView.frame) / albumInRequest;
    
    if (actualPosition >= contentHeight && !isLoadingMoreAlbums) {
        
        isLoadingMoreAlbums = YES;
        NSInteger offset = [self.albums count];
        __weak typeof(self) weakSelf = self;
        
        [[AMServerManager sharedManager] getAlbumsForOwnerID:self.ownerID
                                                       video:self.isVideoAlbums
                                                  withOffset:offset
                                                       count:albumInRequest
                                                   onSuccess:^(NSArray *albums) {
                                                       
                                                       [weakSelf.albums addObjectsFromArray:albums];
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           
                                                           [weakSelf.tableView beginUpdates];
                                                           NSMutableArray* arrayPaths = [NSMutableArray array];
                                                           for (NSInteger index = [weakSelf.albums count] - [albums count]; index < [weakSelf.albums count]; index++) {
                                                               [arrayPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                                                           }
                                                           [weakSelf.tableView insertRowsAtIndexPaths:arrayPaths withRowAnimation:UITableViewRowAnimationTop];
                                                           [weakSelf.tableView endUpdates];
                                                           
                                                       });
                                                       
                                                       isLoadingMoreAlbums = NO;
                                                       
                                                   }
                                                   onFailure:nil];
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMAlbum* album = [self.albums objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"AMMediaViewController" sender:@(album.albumID)];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor orangeCustomColor];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    AMAlbum* album = [self.albums objectAtIndex:indexPath.row];
    cell.textLabel.text = album.name;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {//
    
    return CGRectGetHeight(self.tableView.bounds) / albumInRequest;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.albums count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
    
}


#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[AMMediaViewController class]]) {
        
        AMMediaViewController* mediaController = segue.destinationViewController;
        mediaController.isVideo = self.isVideoAlbums;
        mediaController.ownerID = self.ownerID;
        mediaController.albumID = [sender longValue];
        
    }

}

#pragma mark - Actions

@end
