//
//  AMAccessToken.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 09.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMAccessToken : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDate* expirationDate;
@property (assign, nonatomic) long userID;

@end
