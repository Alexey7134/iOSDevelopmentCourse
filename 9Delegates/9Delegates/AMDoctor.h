//
//  AMDoctor.h
//  9Delegates
//
//  Created by Admin on 23.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMPatient.h"

@interface AMDoctor : NSObject <AMPatientDelegate>

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSMutableDictionary* reportPartBody;

- (void) printReportPartBody;

@end
