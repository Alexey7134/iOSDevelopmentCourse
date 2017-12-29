//
//  AMWebViewController.m
//  39UIWebView
//
//  Created by Admin on 31.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMWebViewController.h"

typedef NS_ENUM(NSInteger, AMTabBarItem) {
    AMTabBarItemBack = 0,
    AMTabBarItemReload = 1,
    AMTabBarItemForward = 2
};

@interface AMWebViewController ()

@property (strong, nonatomic) NSURLRequest* request;

@end

@implementation AMWebViewController

- (void) setFilePath:(NSString *)filePath {
    
    _filePath = filePath;
    
    NSURL* urlString = [NSURL URLWithString:filePath];
    self.request = [NSURLRequest requestWithURL:urlString];
    
}

- (void) updateTabBarItemsEnable {
    
    self.backTabBarItem.enabled = [self.webView canGoBack];
    self.forwardTabBarItem.enabled = [self.webView canGoForward];
    
}

#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.webView loadRequest:self.request];
    
}

- (void) dealloc {
    
    if (self.webView.isLoading) {
        
        [self.webView stopLoading];
        
    }
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self.activityIndicator startAnimating];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.activityIndicator stopAnimating];
    
    [self updateTabBarItemsEnable];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    
    [self.activityIndicator stopAnimating];
    
    [self updateTabBarItemsEnable];
    
    
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if ([item isEqual:self.backTabBarItem]) {
        
        [self.webView goBack];
        
    } else if ([item isEqual:self.reloadTabBarItem]) {
        
        if ([self.webView isLoading]) {
            
            [self.webView stopLoading];
            
        }
        
        [self.webView reload];
        
    } else if ([item isEqual:self.forwardTabBarItem]) {
        
        [self.webView goForward];
        
    }
    
}

@end
