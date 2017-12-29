//
//  AMUser.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 03.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMUser.h"

@implementation AMUser

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    if (self) {
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        
        self.userID = 0;
        self.userID = [[responseObject objectForKey:@"id"] longValue];
        if (self.userID == 0) {
            self.userID = [[responseObject objectForKey:@"user_id"] longValue];
        }
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.dateOfBirth =  [dateFormatter dateFromString:[responseObject objectForKey:@"bdate"]];
        self.country = [[responseObject objectForKey:@"country"] objectForKey:@"title"];
        self.city = [[responseObject objectForKey:@"city"] objectForKey:@"title"];
        self.photo50 = [NSURL URLWithString:[responseObject objectForKey:@"photo_50"]];
        self.photo200 = [NSURL URLWithString:[responseObject objectForKey:@"photo_200"]];
        
    }
    return self;
}

@end
