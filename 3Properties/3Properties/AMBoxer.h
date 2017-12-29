//
//  AMBoxer.h
//  3Properties
//
//  Created by Admin on 18.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMBoxer : NSObject

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) NSInteger age;
@property (assign, nonatomic) float height;
@property (assign, nonatomic) float weight;

-(NSInteger) HowOldAreYou;

@end
