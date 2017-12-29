//
//  AMMessage.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 21.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMServerObject.h"

@interface AMMessage : AMServerObject

@property (assign, nonatomic) long messageID;
@property (assign, nonatomic) long fromID;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSDate* date;
@property (assign, nonatomic) NSInteger readState;
@property (assign, nonatomic) NSInteger outState;
@property (strong, nonatomic) NSArray* attachments;

@end
