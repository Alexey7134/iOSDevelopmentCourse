//
//  AMTopic.h
//  31UITableViewEditing
//
//  Created by Admin on 10.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMTopic : NSObject

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) CGFloat price;

+ (AMTopic*) randomTopic;


@end
