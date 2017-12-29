//
//  AMServerObject.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 11.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMServerObject : NSObject

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject;

@end
