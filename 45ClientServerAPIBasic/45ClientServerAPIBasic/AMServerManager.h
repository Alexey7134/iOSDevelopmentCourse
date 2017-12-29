//
//  AMServerManager.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 01.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMUser, AMGroup, UIImage, AMPost;

@interface AMServerManager : NSObject

+ (AMServerManager*) sharedManager;

- (void) logInUser:(void(^)(AMUser* user))complection;
- (void) logOutUser;
- (AMUser*) isLogin;
- (UIImage*) avatarAuthUser;

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray* friends))success
                    onFailure:(void(^)(NSError* error))failure;

- (void) getDetailUserForID:(long)userID
                  onSuccess:(void(^)(AMUser* user))success
                  onFailure:(void(^)(NSError* error))failure;

- (void) getMessagesForUserID:(long)userID
                   withOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray* messages))success
                    onFailure:(void(^)(NSError* error))failure;

- (void) getDialogsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray* dialogs))success
                    onFailure:(void(^)(NSError* error))failure;

- (void) getGroupsForUserID:(long)userID
                 withOffset:(NSInteger)offset
                      count:(NSInteger)count
                  onSuccess:(void(^)(NSArray* groups))success
                  onFailure:(void(^)(NSError* error))failure;

- (void) getDetailGroupForID:(long)groupID
                   onSuccess:(void(^)(AMGroup* group))success
                   onFailure:(void(^)(NSError* error))failure;

- (void) getDetailForOwnerID:(long)ownerID
                   onSuccess:(void(^)(AMUser* user, AMGroup* group))success
                   onFailure:(void(^)(NSError* error))failure;

- (void) getSubscriptionsForUserID:(long)userID
                        withOffset:(NSInteger)offset
                             count:(NSInteger)count
                         onSuccess:(void(^)(NSArray* subscriptions))success
                         onFailure:(void(^)(NSError* error))failure;

- (void) getFollowersForUserID:(long)userID
                    withOffset:(NSInteger)offset
                         count:(NSInteger)count
                     onSuccess:(void(^)(NSArray* followers))success
                     onFailure:(void(^)(NSError* error))failure;

- (void) getWallRecordsForUserID:(long)userID
                      withOffset:(NSInteger)offset
                           count:(NSInteger)count
                       onSuccess:(void(^)(NSArray* posts))success
                       onFailure:(void(^)(NSError* error))failure;

- (void) getDetailPostForID:(long)postID
                withOwnerID:(long)ownerID
                  onSuccess:(void(^)(AMPost* post))success
                  onFailure:(void(^)(NSError* error))failure;

- (void) getCommentsForPostID:(long)postID
                  withOwnerID:(long)ownerID
                   withOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray* comments))success
                    onFailure:(void(^)(NSError* error))failure;

- (void) getAlbumsForOwnerID:(long)ownerID
                       video:(BOOL)isVideo
                  withOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray* albums))success
                   onFailure:(void(^)(NSError* error))failure;

- (void) getPhotosForAlbumID:(long)albumID
                     ownerID:(long)ownerID
                  withOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray* photos))success
                   onFailure:(void(^)(NSError* error))failure;

- (void) getVideosForAlbumID:(long)albumID
                     ownerID:(long)ownerID
                  withOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray* videos))success
                   onFailure:(void(^)(NSError* error))failure;

- (void) addLikeForPostID:(long)postID
               forOwnerID:(long)ownerID
                onSuccess:(void(^)(NSInteger countLikes))success
                onFailure:(void(^)(NSError* error))failure;

- (void) deleteLikeForPostID:(long)postID
                  forOwnerID:(long)ownerID
                   onSuccess:(void(^)(NSInteger countLikes))success
                   onFailure:(void(^)(NSError* error))failure;

- (void) sendMessage:(NSString*)message
            toUserID:(long)userID
           onSuccess:(void(^)(long messageID))success
           onFailure:(void(^)(NSError* error))failure;

- (void) newPostForOwnerID:(long)ownerID
                  withText:(NSString*)text
                 onSuccess:(void(^)(long postID))success
                 onFailure:(void(^)(NSError* error))failure;

- (void) newCommentForPostID:(long)postID
                 withOwnerID:(long)ownerID
                    withText:(NSString*)text
                   onSuccess:(void(^)(long commentID))success
                   onFailure:(void(^)(NSError* error))failure;

- (void) loadPhoto:(UIImage*)photo
         toAlbumID:(long)albumID
       withOwnerID:(long)ownerID
         onSuccess:(void(^)(long photoID))success
         onFailure:(void(^)(NSError* error))failure;


@end
