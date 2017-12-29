//
//  AMComment.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 24.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMComment.h"

@implementation AMComment

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    
    if (self) {
        
        self.commentID = [[responseObject objectForKey:@"cid"] longValue];
        self.fromID = [[responseObject objectForKey:@"from_id"] longValue];
        self.text = [responseObject objectForKey:@"text"];
        
        NSDictionary* likes = [responseObject objectForKey:@"likes"];
        self.countLikes = [[likes objectForKey:@"count"] integerValue];
        self.userLikes = [[likes objectForKey:@"user_likes"] integerValue];
        self.canLike = [[likes objectForKey:@"can_like"] integerValue];
        
    }
    
    return self;
    
}

@end
