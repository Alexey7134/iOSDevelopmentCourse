//
//  AMStudentOperation.h
//  13Multithreading
//
//  Created by Admin on 04.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AMStudent;
typedef void (^ShowResultBlock) (CGFloat);

@interface AMStudentOperation : NSOperation

+ (NSOperationQueue*) getStudentQueue;
- (void) guessNumberInRange:(AMStudent*) student number:(NSInteger)number endOfRange:(NSInteger)endOfRange showResult:(ShowResultBlock)showResult;

@end
