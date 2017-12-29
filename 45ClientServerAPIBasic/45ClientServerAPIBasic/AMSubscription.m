//
//  AMSubscription.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 07.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMSubscription.h"

@implementation AMSubscription

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    if (self) {
        
        self.name = [responseObject objectForKey:@"name"];
        self.isClosed = [responseObject objectForKey:@"is_closed"];
        self.photo50 = [NSURL URLWithString:[responseObject objectForKey:@"photo_50"]];
        self.photo100 = [NSURL URLWithString:[responseObject objectForKey:@"photo_100"]];
        
    }
    return self;
}

@end
