//
//  AMDocAttachment.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 14.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDocAttachment.h"

@implementation AMDocAttachment

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    
    if (self) {
        
        self.url = [responseObject objectForKey:@"url"];
        
    }
    return self;
}

@end
