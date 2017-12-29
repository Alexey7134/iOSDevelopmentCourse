//
//  AMAlbum.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 26.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMAlbum.h"

@implementation AMAlbum

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    if (self) {
                
        self.albumID = [[responseObject objectForKey:@"aid"] longValue];
        if (self.albumID == 0) {
            self.albumID = [[responseObject objectForKey:@"album_id"] longValue];
        }
        self.ownerID = [[responseObject objectForKey:@"owner_id"] longValue];
        self.name = [responseObject objectForKey:@"title"];
        
    }
    return self;
    
}

@end
