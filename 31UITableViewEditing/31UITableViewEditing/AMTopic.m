//
//  AMTopic.m
//  31UITableViewEditing
//
//  Created by Admin on 10.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMTopic.h"

static NSString* topicsName[] = {@"New dress", @"Old shoes", @"Big appartment", @"Small aquarium", @"Leather jacket", @"New costume",
                                @"Black dress", @"Macbook Pro", @"House", @"Fur coat", @"Baby hats", @"Baby buggy", @"Brown pants",
                                @"Violin 1/8", @"Spare pants", @"Digital camera", @"Almost new sofa", @"Very beautiful kittens",
                                @"Excellent car"};

@implementation AMTopic

+ (AMTopic*) randomTopic {
    
    AMTopic* topic = [[AMTopic alloc] init];
    topic.name = topicsName[(arc4random() % 1900) / 100];
    topic.price = (float) (arc4random() % 10000) / 100.f;
    return topic;
    
}


@end
