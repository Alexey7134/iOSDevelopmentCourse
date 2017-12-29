//
//  AppDelegate.h
//  10Notification
//
//  Created by Admin on 26.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMDoctor, AMBussinesMan, AMRetired, AMCatcher;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AMDoctor* doctor;
@property (strong, nonatomic) AMBussinesMan* bussinesMan;
@property (strong, nonatomic) AMRetired* retired;
@property (strong, nonatomic) AMCatcher* catcher;

@end

