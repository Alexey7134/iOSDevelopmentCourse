//
//  AMServerManager.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 01.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMServerManager.h"
#import <AFNetworking/AFNetworking.h>
#import "AMUser.h"
#import "AMPost.h"
#import "AMGroup.h"
#import "AMMessage.h"
#import "AMComment.h"
#import "AMAlbum.h"
#import "AMPhotoAttachment.h"
#import "AMVideoAttachment.h"
#import "AMAccessToken.h"
#import "AMSubscription.h"
#import "AMLoginViewController.h"
#import "UIColor+AMCustomColor.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <UIKit/UIKit.h>

static NSString* kUserID = @"kUserID";
static NSString* kAccessToken = @"kAccessToken";
static NSString* kExpirationDate = @"kExpirationDate";


@interface AMServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;
@property (strong, nonatomic) AMAccessToken* token;
@property (strong, nonatomic) AMUser* authUser;
@property (strong, nonatomic) UIImageView* avatarImageView;
@property (strong, nonatomic) UIImage* avatarAuthUser;

@end

@implementation AMServerManager

- (void) setAuthUser:(AMUser *)authUser {
    
    _authUser = authUser;
    
    UIImageView* avatar = [[UIImageView alloc] init];
    self.avatarImageView = avatar;
    NSURLRequest* request = [NSURLRequest requestWithURL:authUser.photo50];
    
    __weak typeof(self) weakSelf = self;
    
    [avatar setImageWithURLRequest:request
                  placeholderImage:nil
                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                             
                               weakSelf.avatarAuthUser = image;
                               weakSelf.avatarImageView = nil;
                           }
                           failure:nil];
    
}

+ (AMServerManager*) sharedManager {
    
    static AMServerManager* sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AMServerManager alloc] init];
    });
    
    return sharedManager;
    
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        NSURL* baseURL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        
    }
    return self;
}

#pragma mark - ACCESS KEY

- (void) logInUser:(void(^)(AMUser* user)) complection {
    
    if ([self loadAccessToken]) {
        
        [[AMServerManager sharedManager] getDetailUserForID:self.token.userID
                                                  onSuccess:^(AMUser *user) {
                                                      
                                                      self.authUser = user;
                                                      
                                                      if (complection) {
                                                          
                                                          complection(user);
                                                      }
                                                      
                                                  } onFailure:nil];

    
    } else {

        NSString* urlString = @"https://oauth.vk.com/authorize?"
                                //"client_id=&"
                                "display=mobile&"
                                "redirect_uri=https://oauth.vk.com/blank.html&"
                                "scope=274462&"
                                "response_type=token&"
                                "revoke=1&"
                                "v=5.69";

        NSURL* url = [NSURL  URLWithString:urlString];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];

        AMLoginViewController* loginController = [[AMLoginViewController alloc] initWithRequest:request
                                                                                    redirectURL:@"https://oauth.vk.com/blank.html"
                                                                               complectionBlock:^(AMAccessToken *token) {
                                                                                   
                                                                                   self.token = token;
                                                                                   
                                                                                   [[AMServerManager sharedManager] getDetailUserForID:token.userID
                                                                                                                             onSuccess:^(AMUser *user) {
                                                                                                                                 
                                                                                                                                 self.authUser = user;
                                                                                                                                 
                                                                                                                                 [self saveAccessToken];
                                                                                                                                 
                                                                                                                                 if (complection) {
                                                                                                                                     
                                                                                                                                     complection(user);
                                                                                                                                 }
                                                                                                                                 
                                                                                                                             } onFailure:nil];

                                                                                }];
        
        
        UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
        
        UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:loginController];
        
        navigationController.navigationBar.backgroundColor = [UIColor marineCustomColor];
        
        [mainVC presentViewController:navigationController animated:YES completion:nil];
    
    }
}

- (BOOL) loadAccessToken {
    
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    long userID = [userDefaults doubleForKey:kUserID];
    NSString* token = [userDefaults objectForKey:kAccessToken];
    NSDate* expirationDate =[userDefaults objectForKey:kExpirationDate];
    
    if (userID && token && expirationDate) {
        
        NSDate* currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
        
        if ([expirationDate compare:currentDate] == NSOrderedDescending) {
        
            AMAccessToken* accessToken = [[AMAccessToken alloc] init];
            accessToken.userID = userID;
            accessToken.token = token;
            accessToken.expirationDate = expirationDate;
            
            self.token = accessToken;
            
            return YES;
            
        }
        
        return NO;
    }
    
    return NO;
    
}

- (void) saveAccessToken {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setDouble:self.token.userID forKey:kUserID];
    
    [userDefaults setObject:self.token.token forKey:kAccessToken];
    
    [userDefaults setObject:self.token.expirationDate forKey:kExpirationDate];
    
    [userDefaults synchronize];
    
}

- (void) logOutUser {
    
    self.authUser = nil;
    self.token = nil;
    
    [self saveAccessToken];
    
}

- (AMUser*) isLogin {
    
    if (self.token) {
        
        return self.authUser;
    }
    
    return nil;
    
}

- (UIImage*) avatarAuthUser {

    if (self.avatarAuthUser) {
        
        return self.avatarAuthUser;
        
    }
        
    
    return nil;
    
}

#pragma mark - GET

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray* friends))success
                    onFailure:(void(^)(NSError* error))failure {
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"25759694",    @"user_id",
                                @(offset),      @"offset",
                                @(count),       @"count",
                                @"photo_50",    @"fields",
                                @"ru",          @"lang", nil];
    
    [self.sessionManager GET:@"friends.get"
                parameters:parameters
                progress:^(NSProgress * _Nonnull downloadProgress) {
                                                    
                }
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     NSMutableArray* users = [NSMutableArray array];
                     
                     NSArray* objects = [responseObject objectForKey:@"response"];
                     
                     for (NSDictionary* anyObject in objects) {
                         
                         [users addObject:[[AMUser alloc] initWithServerResponse:anyObject]];
                     }
                     
                     if (success) {
                         success(users);
                     }
                     
                }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                     
                     if (failure) {
                         failure(error);
                     }
                     
                }];

    
    
}

- (void) getDetailUserForID:(long)userID
                  onSuccess:(void(^)(AMUser* user))success
                  onFailure:(void(^)(NSError* error))failure {
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%ld", userID],     @"user_ids",
                                @"bdate, city, country, photo_50, photo_200",   @"fields",
                                                                    @"5.69",    @"v",
                                                                    @"ru",      @"lang", nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSArray* objects = [responseObject objectForKey:@"response"];
                         AMUser* user = [[AMUser alloc] initWithServerResponse:[objects firstObject]];
                         
                         if (success) {
                             success(user);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
                         if (failure) {
                             failure(error);
                         }
                         
                     }];
    
}

- (void) getMessagesForUserID:(long)userID
                   withOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray* messages))success
                    onFailure:(void(^)(NSError* error))failure {
    
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(userID),      @"user_id",
                                    @(offset),      @"offset",
                                    @(count),       @"count",
                                    @"ru",          @"lang", nil];
        
        [self.sessionManager GET:@"messages.getHistory"
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSMutableArray* messages = [NSMutableArray array];
                             
                             NSArray* objects = [responseObject objectForKey:@"response"];
                             
                             for (NSInteger index = 1; index < [objects count]; index++) {
                                 
                                 [messages addObject:[[AMMessage alloc] initWithServerResponse:[objects objectAtIndex:index]]];
                             }
                             
                             if (success) {
                                 success(messages);
                             }
                             
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             if (failure) {
                                 failure(error);
                             }
                             
                         }];
        
        
    }
    
}

- (void) getDialogsWithOffset:(NSInteger)offset
                         count:(NSInteger)count
                     onSuccess:(void(^)(NSArray* dialogs))success
                     onFailure:(void(^)(NSError* error))failure {
    
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(offset),      @"offset",
                                    @(count),       @"count",
                                    @"5.69",        @"v",
                                    @"ru",          @"lang", nil];
        
        [self.sessionManager GET:@"messages.getDialogs"
                      parameters:parameters
                        progress:^(NSProgress * _Nonnull downloadProgress) {
                            
                        }
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSMutableArray* dialogs = [NSMutableArray array];
                             
                             NSDictionary* response = [responseObject objectForKey:@"response"];
                             
                             NSArray* objects = [response objectForKey:@"items"];
                             
                             for (NSDictionary* anyObject in objects) {
                                 
                                 [dialogs addObject:[[AMMessage alloc] initWithServerResponse:[anyObject objectForKey:@"message"]]];
                                 
                             }
                             
                             if (success) {
                                 success(dialogs);
                             }
                             
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             if (failure) {
                                 failure(error);
                             }
                             
                         }];
        
    }
    
    
}

- (void) getGroupsForUserID:(long)userID
                 withOffset:(NSInteger)offset
                      count:(NSInteger)count
                  onSuccess:(void(^)(NSArray* groups))success
                  onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(userID),          @"user_id",
                                    @(1),               @"extended",
                                    @(offset),          @"offset",
                                    @(count),           @"count",
                                    @"ru",              @"lang", nil];
        
        [self.sessionManager GET:@"groups.get"
                      parameters:parameters
                        progress:^(NSProgress * _Nonnull downloadProgress) {
                            
                        }
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSMutableArray* groups = [NSMutableArray array];
                             
                             NSArray* response = [responseObject objectForKey:@"response"];
                             
                             for (NSInteger index = 1; index < [response count]; index++) {
                                 
                                 [groups addObject:[[AMGroup alloc] initWithServerResponse:[response objectAtIndex:index]]];
                             }
                             
                             if (success) {
                                 success(groups);
                             }
                             
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             if (failure) {
                                 failure(error);
                             }
                             
                         }];
    }
    
}

- (void) getDetailGroupForID:(long)groupID
                   onSuccess:(void(^)(AMGroup* group))success
                   onFailure:(void(^)(NSError* error))failure{
    
    if (groupID < 0) {
        groupID *= -1;
    }
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%ld", groupID],    @"group_id",
                                                            @"description",     @"fields",
                                                            @"5.69",            @"v",
                                                            @"ru",              @"lang", nil];
    
    [self.sessionManager GET:@"groups.getById"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSArray* objects = [responseObject objectForKey:@"response"];
                         
                         AMGroup* group = [[AMGroup alloc] initWithServerResponse:[objects firstObject]];
                         
                         if (success) {
                             success(group);
                         }
                        
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             failure(error);
                         }
                         
                     }];
    
}

- (void) getDetailForOwnerID:(long)ownerID
                   onSuccess:(void(^)(AMUser* user, AMGroup* group))success
                   onFailure:(void(^)(NSError* error))failure {
    
    
    if (ownerID > 0) {
        
        [self getDetailUserForID:ownerID
                       onSuccess:^(AMUser *user) {
                           
                           if (success) {
                               success(user, nil);
                           }
                       }
                       onFailure:^(NSError *error) {
                           
                           if (failure) {
                               failure(error);
                           }
                       }];
        
    } else {
        
        [self getDetailGroupForID:ownerID
                        onSuccess:^(AMGroup *group) {
                            
                            if (success) {
                                success(nil, group);
                            }
                            
                        }
                        onFailure:^(NSError *error) {
                            
                            if (failure) {
                                failure(error);
                            }
                        }];
        
    }
    
}

- (void) getSubscriptionsForUserID:(long)userID
                        withOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray* subscriptions))success
                    onFailure:(void(^)(NSError* error))failure {
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                @(userID),  @"user_id",
                                                                @(offset),  @"offset",
                                                                @(count),   @"count",
                                                                @(1),       @"extended",
                                                                @"5.69",    @"v",
                                                                @"ru",      @"lang", nil];
    
    [self.sessionManager GET:@"users.getSubscriptions"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                         NSMutableArray* subscriptions = [NSMutableArray array];
                         
                         NSDictionary* response = [responseObject objectForKey:@"response"];
                         
                         NSArray* objects = [response objectForKey:@"items"];
                         
                         for (NSDictionary* anyObject in objects) {
                             
                             NSString* type = [anyObject objectForKey:@"type"];
                             
                             
                             if ([type isEqualToString:@"page"]) {
                                 
                                 [subscriptions addObject:[[AMSubscription alloc] initWithServerResponse:anyObject]];
                                 
                             } else if ([type isEqualToString:@"profile"]) {
                                 
                                 [subscriptions addObject:[[AMUser alloc] initWithServerResponse:anyObject]];
                                 
                             }

                         }
                         
                         if (success) {
                             success(subscriptions);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         
                         if (failure) {
                             failure(error);
                         }
                         
                     }];
    
}

- (void) getFollowersForUserID:(long)userID
                        withOffset:(NSInteger)offset
                             count:(NSInteger)count
                         onSuccess:(void(^)(NSArray* followers))success
                         onFailure:(void(^)(NSError* error))failure {
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        @(userID),  @"user_id",
                                                                        @(offset),  @"offset",
                                                                        @(count),   @"count",
                                @"bdate, city, country, photo_50, photo_200_orig",  @"fields",
                                                                        @"5.69",    @"v",
                                                                        @"ru",      @"lang", nil];
    
    [self.sessionManager GET:@"users.getFollowers"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
                         NSMutableArray* followers = [NSMutableArray array];
                         
                         NSDictionary* response = [responseObject objectForKey:@"response"];
                         
                         NSArray* objects = [response objectForKey:@"items"];
                         
                         for (NSDictionary* anyObject in objects) {

                            [followers addObject:[[AMUser alloc] initWithServerResponse:anyObject]];
                             
                         }
                         
                         if (success) {
                             success(followers);
                         }
                        
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             failure(error);
                         }
                         
                     }];
    
}

- (void) getWallRecordsForUserID:(long)userID
                    withOffset:(NSInteger)offset
                         count:(NSInteger)count
                     onSuccess:(void(^)(NSArray* posts))success
                     onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,  @"access_token",
                                            @(userID),  @"owner_id",
                                            @(offset),  @"offset",
                                            @(count),   @"count",
                      @(1), @"extended",
                                            @"5.69",    @"v", nil];
        
        [self.sessionManager GET:@"wall.get"
                      parameters:parameters
                        progress:^(NSProgress * _Nonnull downloadProgress) {
                            
                        }
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSMutableArray* posts = [NSMutableArray array];
                             
                             NSDictionary* response = [responseObject objectForKey:@"response"];
                             
                             NSArray* objects = [response objectForKey:@"items"];
                             
                             for (NSDictionary* anyObject in objects) {
                                 
                                 AMPost* post = [[AMPost alloc] initWithServerResponse:anyObject];
                                 [posts addObject:post];
                                 
                             }
                             
                             if (success) {
                                 success(posts);
                             }
                             
                             
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             if (failure) {
                                 failure(error);
                             }
                             
                         }];
    }
    
}

- (void) getDetailPostForID:(long)postID
                withOwnerID:(long)ownerID
                  onSuccess:(void(^)(AMPost* post))success
                  onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSString* posts = [NSString stringWithFormat:@"%ld_%ld", ownerID, postID];
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            self.token.token,   @"access_token",
                                                            posts,              @"posts", nil];

        [self.sessionManager GET:@"wall.getById"
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                             NSArray* response = [responseObject objectForKey:@"response"];
                             AMPost* post = [[AMPost alloc] initWithServerResponse:[response firstObject]];
                             
                             if (success) {
                                 success(post);
                             }
                             
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             if (failure) {
                                 failure(error);
                             }
                             
                         }];
        
        
    }
    
}

- (void) getCommentsForPostID:(long)postID
                  withOwnerID:(long)ownerID
                   withOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray* comments))success
                    onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(ownerID),         @"owner_id",
                                    @(postID),          @"post_id",
                                    @(offset),          @"offset",
                                    @(count),           @"count",
                                    @(1),               @"need_likes",
                                    @(0),               @"preview_length",
                                    @"ru",              @"lang", nil];
        
        [self.sessionManager GET:@"wall.getComments"
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSMutableArray* comments = [NSMutableArray array];
                             
                             NSArray* response = [responseObject objectForKey:@"response"];
                                                          
                             for (NSInteger index = 1; index < [response count]; index++) {
                                 
                                 AMComment* comment = [[AMComment alloc] initWithServerResponse:[response objectAtIndex:index]];
                                 [comments addObject:comment];
                             }

                             if (success) {
                                 success(comments);
                             }

                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             if (failure) {
                                 failure(error);
                             }
                             
                         }];
        
    }
}

- (void) getAlbumsForOwnerID:(long)ownerID
                       video:(BOOL)isVideo
                  withOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray* albums))success
                   onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(ownerID),         @"owner_id",
                                    @(offset),          @"offset",
                                    @(count),           @"count",
                                    @"ru",              @"lang", nil];
        
        NSString* getString = @"photos.getAlbums";
        
        if (isVideo) {
            getString = @"video.getAlbums";
        }
        
        [self.sessionManager GET:getString
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSMutableArray* albums = [NSMutableArray array];
                             
                             NSArray* response = [responseObject objectForKey:@"response"];
                             
                             id firstObject = [response firstObject];
                             
                             if ([firstObject isKindOfClass:[NSDictionary class]]) {
                                 
                                 for (NSDictionary* anyObject in response) {
                                     
                                     AMAlbum* album = [[AMAlbum alloc] initWithServerResponse:anyObject];
                                     [albums addObject:album];
                                     
                                 }
                             } else {
                                 
                                 for (NSInteger index = 1; index < [response count]; index++) {
                                     
                                     AMAlbum* album = [[AMAlbum alloc] initWithServerResponse:[response objectAtIndex:index]];
                                     [albums addObject:album];
                                     
                                 }
                             }
                             
                             if (success) {
                                 success(albums);
                             }
                             
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             if (failure) {
                                 failure(error);
                             }
                             
                         }];
        
    }
    
}

- (void) getPhotosForAlbumID:(long)albumID
                     ownerID:(long)ownerID
                  withOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray* photos))success
                   onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(ownerID),         @"owner_id",
                                    @(albumID),         @"album_id",
                                    @(offset),          @"offset",
                                    @(count),           @"count", nil];
        
        [self.sessionManager GET:@"photos.get"
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSMutableArray* photos = [NSMutableArray array];
                             
                             NSArray* response = [responseObject objectForKey:@"response"];
                             
                             for (NSDictionary* anyObject in response) {
                                 
                                 AMPhotoAttachment* photo = [[AMPhotoAttachment alloc] initWithServerResponse:anyObject];
                                 [photos addObject:photo];
                                 
                             }
                             
                             if (success) {
                                 success(photos);
                             }
                             
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             if (failure) {
                                 failure(error);
                             }
                             
                         }];
        
    }

}

- (void) getVideosForAlbumID:(long)albumID
                     ownerID:(long)ownerID
                  withOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray* videos))success
                   onFailure:(void(^)(NSError* error))failure {
 
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(ownerID),         @"owner_id",
                                    @(albumID),         @"album_id",
                                    @(offset),          @"offset",
                                    @(count),           @"count", nil];
        
        [self.sessionManager GET:@"video.get"
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSMutableArray* videos = [NSMutableArray array];
                             
                             NSArray* response = [responseObject objectForKey:@"response"];
                             
                             for (NSInteger index = 1; index < [response count]; index++) {
                                 
                                 AMVideoAttachment* video = [[AMVideoAttachment alloc] initWithServerResponse:[response objectAtIndex:index]];
                                 [videos addObject:video];
                                 
                             }
                             
                             if (success) {
                                 success(videos);
                             }
                             
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             if (failure) {
                                 failure(error);
                             }
                             
                         }];
        
    }
    
}

- (void) getUploadPhotoToAlbumID:(long)albumID
                     withOwnerID:(long)ownerID
                       onSuccess:(void(^)(NSURL* uploadURL))success
                       onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        if (ownerID < 0) {
            ownerID *= -1;
        }
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(ownerID),         @"group_id",
                                    @(albumID),         @"album_id", nil];
        
        [self.sessionManager GET:@"photos.getUploadServer"
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSDictionary* response = [responseObject objectForKey:@"response"];
                             NSString* uploadString = [response objectForKey:@"upload_url"];
                             if (success) {
                                 success([NSURL URLWithString:uploadString]);
                             }
                             
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             if (failure) {
                                 failure(error);
                             }
                             
                         }];
        
    }
    
}

#pragma mark - POST

- (void) addLikeForPostID:(long)postID
               forOwnerID:(long)ownerID
                onSuccess:(void(^)(NSInteger countLikes))success
                onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          self.token.token,     @"access_token",
                                                          @(ownerID),           @"owner_id",
                                                          @(postID),            @"item_id",
                                                          @"post",              @"type", nil];
        
        [self.sessionManager POST:@"likes.add"
                       parameters:parameters
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              
                              NSDictionary* response = [responseObject objectForKey:@"response"];
                              NSInteger count = [[response objectForKey:@"likes"] integerValue];
                              
                              if (success) {
                                  success(count);
                              }
                          }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
    }
    
}

- (void) deleteLikeForPostID:(long)postID
                  forOwnerID:(long)ownerID
                   onSuccess:(void(^)(NSInteger countLikes))success
                   onFailure:(void(^)(NSError* error))failure {

    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          self.token.token,     @"access_token",
                                                          @(ownerID),           @"owner_id",
                                                          @(postID),            @"item_id",
                                                          @"post",              @"type", nil];
        
        [self.sessionManager POST:@"likes.delete"
                       parameters:parameters
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              
                              NSDictionary* response = [responseObject objectForKey:@"response"];
                              NSInteger count = [[response objectForKey:@"likes"] integerValue];
                              
                              if (success) {
                                  success(count);
                              }
                          }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
    }
   
}

- (void) sendMessage:(NSString*)message
            toUserID:(long)userID
           onSuccess:(void(^)(long messageID))success
           onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(userID),          @"user_id",
                                    message,            @"message", nil];
        
        [self.sessionManager POST:@"messages.send"
                       parameters:parameters
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              
                              NSInteger newID = [[responseObject objectForKey:@"response"] longValue];
                              
                              if (success) {
                                  success(newID);
                              }
                          }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
    }
    
    
}

- (void) newPostForOwnerID:(long)ownerID
                  withText:(NSString*)text
                 onSuccess:(void(^)(long postID))success
                 onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(ownerID),         @"owner_id",
                                    text,               @"message", nil];
        
        [self.sessionManager POST:@"wall.post"
                       parameters:parameters
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              
                              NSDictionary* response = [responseObject objectForKey:@"response"];
                              long newID = [[response objectForKey:@"post_id"] longValue];
                              
                              if (success) {
                                  success(newID);
                              }
                          }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
    }
    
}

- (void) newCommentForPostID:(long)postID
                 withOwnerID:(long)ownerID
                    withText:(NSString*)text
                   onSuccess:(void(^)(long commentID))success
                   onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(ownerID),         @"owner_id",
                                    @(postID),          @"post_id",
                                    text,               @"message", nil];
        
        [self.sessionManager POST:@"wall.createComment"
                       parameters:parameters
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              
                              NSDictionary* response = [responseObject objectForKey:@"response"];
                              long newID = [[response objectForKey:@"cid"] longValue];
                              
                              if (success) {
                                  success(newID);
                              }
                          }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
    }
    
}

- (void) loadPhoto:(UIImage*)photo
         toAlbumID:(long)albumID
       withOwnerID:(long)ownerID
         onSuccess:(void(^)(long photoID))success
         onFailure:(void(^)(NSError* error))failure {
    
    if (ownerID < 0) {
        ownerID *= -1;
    }
    
    if (self.token) {
        
        [self getUploadPhotoToAlbumID:albumID
                          withOwnerID:ownerID
                            onSuccess:^(NSURL *uploadURL) {
                                
                                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                                
                                NSData *imageData = UIImageJPEGRepresentation(photo, 0.5);
                                
                                [manager POST:uploadURL.absoluteString
                                   parameters:nil
                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        
                                    [formData appendPartWithFileData:imageData
                                                                name:@"file1"
                                                            fileName:@"image.jpg" mimeType:@"image/jpeg"];

                    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                                    
                                    NSError *jsonError;
                                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                         options:NSJSONReadingMutableContainers
                                                                                           error:&jsonError];
                                    
                                    [self savePhotoToAlbumID:albumID
                                                     groupID:ownerID
                                                      server:[[response objectForKey:@"server"] longValue]
                                               withPhotoList:[response objectForKey:@"photos_list"]
                                                        hash:[response objectForKey:@"hash"]
                                                   onSuccess:^(long photoID) {
                                                       
                                                       if (success) {
                                                           success(photoID);
                                                       }
                                                       
                                                   }
                                                   onFailure:^(NSError *error) {
                                                       if (failure) {
                                                           failure(error);
                                                       }
                                                   }];
                                    
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    
                                    if (failure) {
                                        failure(error);
                                    }
                                    
                                }];
                                
                                
                            }
                            onFailure:^(NSError *error) {
                                if (failure) {
                                    failure(error);
                                }
                            }];
        
    }

}

- (void) savePhotoToAlbumID:(long)albumID
                    groupID:(long)groupID
                     server:(long)serverID
              withPhotoList:(NSString*)list
                       hash:(NSString*)hash
                  onSuccess:(void(^)(long photoID))success
                  onFailure:(void(^)(NSError* error))failure {
    
    if (self.token) {
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.token.token,   @"access_token",
                                    @(albumID),         @"album_id",
                                    @(groupID),         @"group_id",
                                    @(serverID),        @"server",
                                    list,               @"photos_list",
                                    hash,               @"hash", nil];
        
        [self.sessionManager POST:@"photos.save"
                       parameters:parameters
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              
                              NSArray* response = [responseObject objectForKey:@"response"];
                              NSDictionary* object = [response firstObject];
                              long newID = [[object objectForKey:@"pid"] longValue];
                              
                              if (success) {
                                  success(newID);
                              }
                          }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
    }
    
}

@end
