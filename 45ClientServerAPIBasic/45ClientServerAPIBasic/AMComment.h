//
//  AMComment.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 24.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMServerObject.h"

@interface AMComment : AMServerObject

@property (assign, nonatomic) long commentID;
@property (assign, nonatomic) long fromID;
@property (strong, nonatomic) NSString* text;
@property (assign, nonatomic) NSInteger countLikes;
@property (assign, nonatomic) NSInteger userLikes;
@property (assign, nonatomic) NSInteger canLike;

@end
