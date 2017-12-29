//
//  AMPost.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 11.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMPost.h"
#import "AMPhotoAttachment.h"
#import "AMVideoAttachment.h"
#import "AMLinkAttachment.h"
#import "AMDocAttachment.h"

@implementation AMPost

- (instancetype)initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        self.postID = [[responseObject objectForKey:@"id"] longValue];
        self.ownerID = [[responseObject objectForKey:@"owner_id"] longValue];
        self.fromID = [[responseObject objectForKey:@"from_id"] longValue];
        self.text = [responseObject objectForKey:@"text"];

        self.date = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] doubleValue]];
        
        NSDictionary* likes = [responseObject objectForKey:@"likes"];
        self.countLikes = [[likes objectForKey:@"count"] integerValue];
        self.userLikes = [[likes objectForKey:@"user_likes"] integerValue];
        self.canLike = [[likes objectForKey:@"can_like"] integerValue];
        
        NSDictionary* comments = [responseObject objectForKey:@"comments"];
        self.countComments = [[comments objectForKey:@"count"] integerValue];
        
        NSMutableArray* attachments = [NSMutableArray array];
        
        NSArray* objects = [responseObject objectForKey:@"attachments"];

        for (NSDictionary* anyObject in objects) {
            
            NSString* type = [anyObject objectForKey:@"type"];
            
            if ([type isEqualToString:@"photo"]) {
                
                AMPhotoAttachment* attachment = [[AMPhotoAttachment alloc] initWithServerResponse:[anyObject objectForKey:@"photo"]];
                [attachments addObject:attachment];
                
            } else if ([type isEqualToString:@"link"]) {
                
                AMLinkAttachment* attachment = [[AMLinkAttachment alloc] initWithServerResponse:[anyObject objectForKey:@"link"]];
                [attachments addObject:attachment];
                
            } else if ([type isEqualToString:@"video"]) {
                
                AMVideoAttachment* attachment = [[AMVideoAttachment alloc] initWithServerResponse:[anyObject objectForKey:@"video"]];
                [attachments addObject:attachment];
                
            } else if ([type isEqualToString:@"doc"]) {
                
                AMDocAttachment* attachment = [[AMDocAttachment alloc] initWithServerResponse:[anyObject objectForKey:@"doc"]];
                [attachments addObject:attachment];
                
            } else {
                
                
            }
        }
        
        self.attachments = attachments;
        
        NSArray* copyHistory = [responseObject objectForKey:@"copy_history"];
        
        NSDictionary* repost = [copyHistory firstObject];
        
        if (repost) {
            
            self.repost = [[AMPost alloc] initWithServerResponse:repost];
            
        }
    
        
        
    }
    
    return self;
    
}

@end
