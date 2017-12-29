//
//  AMAttachment.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 14.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMServerObject.h"

@interface AMAttachment : AMServerObject

@property (assign, nonatomic) long ownerID;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* title;

@end
