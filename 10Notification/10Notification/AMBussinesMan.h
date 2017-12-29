//
//  AMBussinesMan.h
//  10Notification
//
//  Created by Admin on 27.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface AMBussinesMan : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) CGFloat profit;
@property (assign, nonatomic) CGFloat income;

@end
