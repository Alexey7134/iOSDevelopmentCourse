//
//  AMFriend.h
//  9Delegates
//
//  Created by Admin on 24.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPatient.h"

@interface AMFriend : NSObject <AMPatientDelegate>

@property (strong, nonatomic) NSString* name;

@end
