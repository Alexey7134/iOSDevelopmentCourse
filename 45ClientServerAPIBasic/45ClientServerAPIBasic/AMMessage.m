//
//  AMMessage.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 21.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMMessage.h"
#import "AMPhotoAttachment.h"
#import "AMVideoAttachment.h"
#import "AMLinkAttachment.h"
#import "AMDocAttachment.h"
#import "AMStickerAttachment.h"

@implementation AMMessage

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    
    if (self) {

        self.messageID = [[responseObject objectForKey:@"id"] longValue];
        self.fromID = [[responseObject objectForKey:@"user_id"] longValue];
        self.text = [responseObject objectForKey:@"body"];
        self.date = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] doubleValue]];
        self.readState = [[responseObject objectForKey:@"read_state"] integerValue];
        self.outState = [[responseObject objectForKey:@"out"] integerValue];
        
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
                
            } else if ([type isEqualToString:@"sticker"]) {
                
                AMStickerAttachment* attachment = [[AMStickerAttachment alloc] initWithServerResponse:[anyObject objectForKey:@"sticker"]];
                [attachments addObject:attachment];
                
            } else {
                
            }
        }
        
        self.attachments = attachments;

    }
    
    return self;
    
}

@end
