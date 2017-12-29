//
//  AMParentClass.m
//  2FunctionTest
//
//  Created by Admin on 15.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMParentClass.h"

@implementation AMParentClass

+ (void) whoAreYou{
    NSLog(@"I am AMParentClass");
}

- (void) sayHello{
    
    NSLog(@"Parent say Hello!!!");
    
}

- (void) say: (NSString*) message{
    
    NSLog(@"%@", message);

}

- (void) say: (NSString*) firstMessage and: (NSString*) secondMessage{
    
    NSLog(@"%@, %@", firstMessage, secondMessage);
    
}

- (NSString*) saySomething{
    //return @"Parent only say";
    NSString* randomDateString = [self saySomeNumberString];
    return randomDateString;
}

- (NSString*) saySomeNumberString{
    return [NSString stringWithFormat:@"%@", [NSDate date]];
}

@end
