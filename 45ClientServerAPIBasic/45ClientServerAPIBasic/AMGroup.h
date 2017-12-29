//
//  AMGroup.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 15.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMServerObject.h"

@interface AMGroup : AMServerObject

@property (assign, nonatomic) long groupID;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* photo50;

@end
