//
//  AMStudent.h
//  12Bloks
//
//  Created by Admin on 29.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMStudent : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* lastName;

- (instancetype)initWithName:(NSString*)name lastName:(NSString*)lastName;

@end
