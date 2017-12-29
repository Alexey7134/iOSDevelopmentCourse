//
//  AMSubscription.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 07.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMServerObject.h"

@interface AMSubscription : AMServerObject

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) BOOL isClosed;
@property (strong, nonatomic) NSURL* photo50;
@property (strong, nonatomic) NSURL* photo100;

@end
