//
//  AMStickerAttachment.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 21.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStickerAttachment.h"

@implementation AMStickerAttachment


- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    
    if (self) {
        
        self.photo64 = [NSURL URLWithString:[responseObject objectForKey:@"photo_64"]];
        self.photo128 = [NSURL URLWithString:[responseObject objectForKey:@"photo_128"]];
        
    }
    return self;
}

@end
