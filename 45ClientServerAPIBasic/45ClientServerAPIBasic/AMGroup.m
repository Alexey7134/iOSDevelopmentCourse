//
//  AMGroup.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 15.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMGroup.h"

@implementation AMGroup

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    if (self) {
        
        self.groupID = [[responseObject objectForKey:@"gid"] longValue];
        self.name = [responseObject objectForKey:@"name"];
        NSString* photoPath = [responseObject objectForKey:@"photo_50"];
        if (photoPath == nil) {
            photoPath = [responseObject objectForKey:@"photo"];
        }
        self.photo50 = [NSURL URLWithString:photoPath];
        
        
    }
    return self;
    
}

@end
