//
//  AMAttachment.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 14.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMAttachment.h"

@implementation AMAttachment

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    
    if (self) {
        
        self.ownerID = [[responseObject objectForKey:@"owner_id"] longValue];
        self.title = [responseObject objectForKey:@"title"];
        self.text = [responseObject objectForKey:@"text"];
        
    }
    return self;
}

@end
