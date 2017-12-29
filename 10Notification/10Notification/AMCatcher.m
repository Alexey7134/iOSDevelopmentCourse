//
//  AMCatcher.m
//  10Notification
//
//  Created by Admin on 28.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMCatcher.h"

@implementation AMCatcher

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appFinishLaunchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void) appFinishLaunchingNotification: (UIApplication*) application {
    NSLog(@"Catcher intercepted the event - finishLaunching");
}

@end
