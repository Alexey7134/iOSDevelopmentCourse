//
//  AMPhotoAttachment.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 14.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMPhotoAttachment.h"

@implementation AMPhotoAttachment

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    
    if (self) {
        
        self.photo75 = [NSURL URLWithString:[responseObject objectForKey:@"photo_75"]];
        self.photo604 = [NSURL URLWithString:[responseObject objectForKey:@"photo_604"]];
        if (!self.photo604) {
            
            self.photo604 = [NSURL URLWithString:[responseObject objectForKey:@"src_big"]];
            
        }
        
    }
    return self;
}


@end
