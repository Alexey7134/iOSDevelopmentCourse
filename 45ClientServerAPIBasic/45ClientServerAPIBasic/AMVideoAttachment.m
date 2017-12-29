//
//  AMVideoAttachment.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 14.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMVideoAttachment.h"

@implementation AMVideoAttachment

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    
    if (self) {
        
        self.photo130 = [NSURL URLWithString:[responseObject objectForKey:@"photo_130"]];
        self.photo320 = [NSURL URLWithString:[responseObject objectForKey:@"photo_320"]];
        if (!self.photo320) {
            self.photo320 = [NSURL URLWithString:[responseObject objectForKey:@"image"]];
            self.link = [NSURL URLWithString:[responseObject objectForKey:@"player"]];
        }
    }
    return self;
}


@end
