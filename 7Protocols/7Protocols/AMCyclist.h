//
//  AMCyclist.h
//  5Arrays1
//
//  Created by Admin on 20.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMHuman.h"
#import "AMJumpers.h"

@interface AMCyclist : AMHuman <AMJumpers>

@property (assign, nonatomic) AMJump heightJump;



@end
