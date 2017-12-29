//
//  AMHuman.h
//  5Arrays1
//
//  Created by Admin on 20.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMHuman : NSObject

@property (strong,nonatomic) NSString* name;
@property (assign, nonatomic) float weight;
@property (assign, nonatomic) float height;
@property (strong, nonatomic) NSString* gender;

- (instancetype)initWithParameters: (NSString*) name gender:(NSString*) gender height:(float) height weight:(float) weight;

- (void) Moves;

@end
