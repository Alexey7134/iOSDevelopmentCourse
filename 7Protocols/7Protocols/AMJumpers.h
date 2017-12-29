//
//  AMJumpers.h
//  7Protocols
//
//  Created by Admin on 22.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    highJump,
    middleJump,
    lowJump
} AMJump;

@protocol AMJumpers <NSObject>

@required

@property (assign, nonatomic) AMJump heightJump;

- (void) jumping;

@optional

- (void) accelerate;

@end
