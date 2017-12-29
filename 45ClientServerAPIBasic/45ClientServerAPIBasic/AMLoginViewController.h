//
//  AMLoginViewController.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 09.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMAccessToken;

typedef void (^AMLoginComplectionBlock) (AMAccessToken* token);

@interface AMLoginViewController : UIViewController

- (instancetype)initWithRequest:(NSURLRequest*)request
                    redirectURL:(NSString*)redirectURL
               complectionBlock:(AMLoginComplectionBlock)complectionBlock;

@end
