//
//  AMStudent.h
//  30UITableViewDynamic
//
//  Created by Admin on 09.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    AMLevelNone,
    AMLevelLow,
    AMLevelNormal,
    AMLevelGood,
    AMLevelExcellent
} AMLevel;


@interface AMStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) CGFloat averageScore;
@property (assign, nonatomic) AMLevel level;

- (instancetype)initWithName:(NSString*)firstName lastName:(NSString*)lastName averageScore:(CGFloat)averageScore;

@end
