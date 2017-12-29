//
//  AMStudentOperation.m
//  13Multithreading
//
//  Created by Admin on 04.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStudentOperation.h"
#import "AMStudent.h"

@implementation AMStudentOperation

+ (NSOperationQueue*) getStudentQueue {
    static NSOperationQueue* studentQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        studentQueue = [[NSOperationQueue alloc] init];
    });
    return studentQueue;
}

- (void) guessNumberInRange:(AMStudent*) student number:(NSInteger)number endOfRange:(NSInteger)endOfRange showResult:(ShowResultBlock)showResult{
    __block NSInteger randomNumber = 0;
    double startTime = CACurrentMediaTime();
    __block double second = 0;
 
    [[AMStudentOperation getStudentQueue] addOperationWithBlock:^{
        NSLog(@"%@ started",student.name);
        while (randomNumber != number) {
            randomNumber = arc4random() % endOfRange + 1;
        };
        second = CACurrentMediaTime() - startTime;
        dispatch_async(dispatch_get_main_queue(), ^{
            showResult(second);
        });
    }];
}

@end
