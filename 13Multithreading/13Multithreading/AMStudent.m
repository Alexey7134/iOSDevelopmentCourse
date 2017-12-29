//
//  AMStudent.m
//  13Multithreading
//
//  Created by Admin on 02.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStudent.h"
#import "AMStudentOperation.h"



@implementation AMStudent

+ (dispatch_queue_t) getStudentQueue {
    static dispatch_queue_t studentQueue = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        studentQueue = dispatch_queue_create("com.annamiksiuk.amstudent.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return studentQueue;
}

- (void) guessNumberInRange:(NSInteger) number endOfRange:(NSInteger) endOfRange {
    
    __block NSInteger randomNumber = 0;
    __weak NSString* nameStudent = self.name;
    double startTime = CACurrentMediaTime();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (randomNumber != number) {
            randomNumber = arc4random() % endOfRange + 1;
        };
        NSLog(@"Student %@ guessed number in %f second", nameStudent, CACurrentMediaTime() - startTime);
    });
}

/*
- (void) guessNumberInRange:(NSInteger) number endOfRange:(NSInteger) endOfRange showResult:(ShowResultBlock)showResult {
    __block NSInteger randomNumber = 0;
    __weak NSString* nameStudent = self.name;
    double startTime = CACurrentMediaTime();
    dispatch_async([AMStudent getStudentQueue], ^{
        while (randomNumber != number) {
            randomNumber = arc4random() % endOfRange + 1;
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            showResult(nameStudent,CACurrentMediaTime() - startTime);
        });
        
    });
}
*/

+ (NSOperationQueue*) getStudentOperationQueue {
    static NSOperationQueue* studentQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        studentQueue = [[NSOperationQueue alloc] init];
    });
    return studentQueue;
}

- (void) guessNumberInRange:(NSInteger) number endOfRange:(NSInteger) endOfRange showResult:(ShowResultBlock)showResult {
    __block NSInteger randomNumber = 0;
    double startTime = CACurrentMediaTime();
    __weak AMStudent* weakSelf = self;
    [[AMStudent getStudentOperationQueue] addOperationWithBlock:^{
        NSLog(@"%@ started",weakSelf.name);
        while (randomNumber != number) {
            randomNumber = arc4random() % endOfRange + 1;
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            showResult(CACurrentMediaTime() - startTime);
        });
    }];
}

@end
