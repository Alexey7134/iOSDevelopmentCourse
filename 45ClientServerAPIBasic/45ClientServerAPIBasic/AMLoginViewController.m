//
//  AMLoginViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 09.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMLoginViewController.h"
#import "AMAccessToken.h"

@interface AMLoginViewController () <UIWebViewDelegate>

@property (weak, nonatomic) UIWebView* webView;
@property (copy, nonatomic) AMLoginComplectionBlock complectionBlock;
@property (strong, nonatomic) UIActivityIndicatorView* activityIndicator;
@property (strong, nonatomic) NSURLRequest* request;
@property (strong, nonatomic) NSString* redirectURL;

@end

@implementation AMLoginViewController

- (instancetype)initWithRequest:(NSURLRequest*)request
                    redirectURL:(NSString*)redirectURL
               complectionBlock:(AMLoginComplectionBlock)complectionBlock {
    
    self = [super init];
    if (self) {
        
        self.request = request;
        self.complectionBlock = complectionBlock;
        self.redirectURL = redirectURL;
        
    }
    return self;

}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGRect frameWebView = self.view.bounds;
    frameWebView.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:frameWebView];
    webView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    self.webView = webView;
    
    [self.view addSubview:webView];
    self.webView.delegate = self;
    
    UIBarButtonItem* doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                        target:self
                                                                                        action:@selector(actionDoneBarButton:)];
    
    self.navigationItem.leftBarButtonItem = doneBarButtonItem;
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = self.webView.center;
    [indicator startAnimating];
    self.activityIndicator = indicator;
    
    [self.view addSubview:self.activityIndicator];
    
    [self.webView loadRequest:self.request];
}

- (void)dealloc {
    
    self.webView.delegate = nil;
    
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL* urlRequest = request.URL;
    
    NSArray* urlComponents = [urlRequest.relativeString componentsSeparatedByString:@"#"];

    if ([[urlComponents firstObject] isEqualToString:self.redirectURL]) {
        
        AMAccessToken* token = [[AMAccessToken alloc] init];
        
        NSArray* pairs = [[urlComponents lastObject] componentsSeparatedByString:@"&"];
        
        for (NSString* anyPair in pairs) {
            
            NSArray* values = [anyPair componentsSeparatedByString:@"="];
            
            if ([[values firstObject] isEqualToString:@"access_token"]) {
                
                token.token = [values lastObject];
                
            } else if ([[values firstObject] isEqualToString:@"expires_in"]) {
             
                token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:[[values lastObject] doubleValue]];
                
            } else if ([[values firstObject] isEqualToString:@"user_id"]) {
                
                NSString* userID = [values lastObject];
                token.userID = userID.doubleValue;
                
            }
            
        }
        
        self.webView.delegate = nil;
        
        if (self.complectionBlock) {
            
            self.complectionBlock(token);
            
        }
        
        if ([self.navigationController.viewControllers count] > 1) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
        return NO;
        
    }
    
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self.activityIndicator startAnimating];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.activityIndicator stopAnimating];
    
 }

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.activityIndicator stopAnimating];
    
}

#pragma mark - Actions

- (void) actionDoneBarButton:(UIBarButtonItem*)sender {
    
    self.webView.delegate = nil;
    
    if (self.complectionBlock) {
        
        self.complectionBlock(nil);
        
    }
    
    if ([self.navigationController.viewControllers count] > 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

@end
