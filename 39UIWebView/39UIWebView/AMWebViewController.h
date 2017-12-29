//
//  AMWebViewController.h
//  39UIWebView
//
//  Created by Admin on 31.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AMTypeFilePath) {
    AMTypeFilePathPDF = 0,
    AMTypeFilePathHTML = 1
};

@interface AMWebViewController : UIViewController <UIWebViewDelegate, UITabBarDelegate>

@property (strong, nonatomic) NSString* filePath;
@property (assign, nonatomic) AMTypeFilePath typeFilePath;

@property (weak, nonatomic) IBOutlet UIWebView* webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITabBar* tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *backTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *reloadTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *forwardTabBarItem;

@end
