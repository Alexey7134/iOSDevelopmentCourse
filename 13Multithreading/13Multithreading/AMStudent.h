//
//  AMStudent.h
//  13Multithreading
//
//  Created by Admin on 02.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ShowResultBlock) (CGFloat);

@interface AMStudent : NSObject

@property (strong, nonatomic) NSString* name;

+ (dispatch_queue_t) getStudentQueue;
+ (NSOperationQueue*) getStudentOperationQueue;

- (void) guessNumberInRange: (NSInteger) number endOfRange:(NSInteger) endOfRange;
- (void) guessNumberInRange:(NSInteger) number endOfRange:(NSInteger) endOfRange showResult:(ShowResultBlock)showResult;

@end
