//
//  AMParentClass.h
//  2FunctionTest
//
//  Created by Admin on 15.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMParentClass : NSObject

+ (void) whoAreYou;
- (void) sayHello;
- (void) say: (NSString*) message;
- (void) say: (NSString*) firstMessage and: (NSString*) secondMessage;
- (NSString*) saySomething;

@end
