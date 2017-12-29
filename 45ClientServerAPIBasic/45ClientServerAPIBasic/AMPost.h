//
//  AMPost.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 11.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMServerObject.h"

@class AMUser;

@interface AMPost : AMServerObject

@property (assign, nonatomic) long postID;
@property (assign, nonatomic) long ownerID;
@property (assign, nonatomic) long fromID;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSDate* date;
@property (assign, nonatomic) NSInteger countComments;
@property (assign, nonatomic) NSInteger countLikes;
@property (assign, nonatomic) NSInteger userLikes;
@property (assign, nonatomic) NSInteger canLike;
@property (strong, nonatomic) NSArray* attachments;
@property (strong, nonatomic) AMPost* repost;

@end
