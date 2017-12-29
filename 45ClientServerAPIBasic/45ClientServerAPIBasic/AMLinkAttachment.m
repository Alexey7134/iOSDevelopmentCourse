//
//  AMLinkAttachment.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 14.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMLinkAttachment.h"
#import "AMPhotoAttachment.h"

@implementation AMLinkAttachment

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    
    if (self) {
        
        self.link = [responseObject objectForKey:@"url"];
        
        NSDictionary* photo = [responseObject objectForKey:@"photo"];
        
        if (photo) {
            
            self.photo = [[AMPhotoAttachment alloc] initWithServerResponse:photo];
            
        }
    
    }
    
    return self;
}


@end
