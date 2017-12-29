//
//  ViewController.m
//  25UIControls
//
//  Created by Admin on 28.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    AMOperationTypeNone,
    AMOperationTypeAddition,
    AMOperationTypeSubstraction,
    AMOperationTypeMultiplication,
    AMOperationTypeDivision
} AMOperationType;

@interface ViewController ()

@property (assign, nonatomic) CGFloat firstNumber;
@property (assign, nonatomic) AMOperationType operation;
@property (strong, nonatomic) NSMutableString* workingString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIButton* button in self.allButtons) {
        if (button.tag == 112 || button.tag == 117) {
            button.layer.cornerRadius = 0.3f * CGRectGetWidth(button.bounds);
        } else {
            button.layer.cornerRadius = 0.3f * CGRectGetHeight(button.bounds);
        }
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor grayColor].CGColor;
    }
    
    self.workingString = [[NSMutableString alloc] init];
    self.firstNumber = 0;
    self.operation = AMOperationTypeNone;
    self.resultLabel.text = @"0";
    self.firstComponentLabel.text = @"";
    
}

#pragma mark - Functions

- (void) clearWorkingString {
    
    [self.workingString deleteCharactersInRange:NSMakeRange(0, [self.workingString length])];
    
}

- (void) removeZeroFromWorkingString {
    
     NSRange range = [self.workingString rangeOfString:@"."];
     if (range.location != NSNotFound) {
         
         NSInteger length = [self.workingString length];
         for (NSInteger i = 0; i < length; i++) {
             if ([self.workingString characterAtIndex:[self.workingString length] - 1] == '0') {
                 [self.workingString deleteCharactersInRange:NSMakeRange([self.workingString length] - 1, 1)];
             }
         }
         if ([self.workingString characterAtIndex:[self.workingString length]-1] == '.') {
             [self.workingString deleteCharactersInRange:NSMakeRange([self.workingString length] - 1, 1)];
         }
         
     }
    
}

- (void) reset {

    [self clearWorkingString];
    self.firstNumber = 0;
    self.operation = AMOperationTypeNone;
    self.resultLabel.text = @"0";
    self.firstComponentLabel.text = @"";
    
}

- (NSString*) getNumberString {
    
    NSMutableString* resultString = [[NSMutableString alloc] init];
    [resultString appendFormat:@"%@",self.workingString];
    if ([resultString characterAtIndex:[resultString length]-1] == '.') {
        [resultString deleteCharactersInRange:NSMakeRange([resultString length] - 1, 1)];
    }
    return resultString;
    
}

- (CGFloat) getNumber {
    
    return [[self getNumberString] doubleValue];
    
}

- (void) addDigit:(int)digit {
    
    
    [self.workingString appendFormat:@"%d",digit];
    
}

- (void) showResultString {
    
    if (![self.workingString length]) {
        self.resultLabel.text = @"0";
        return;
    }
    
    self.resultLabel.text = [self getNumberString];
    
}

- (NSString*) stringFromOperationType:(AMOperationType)operation {
    
    switch (operation) {
        case AMOperationTypeAddition:
            return @"+";
        case AMOperationTypeSubstraction:
            return @"-";
        case AMOperationTypeMultiplication:
            return @"*";
        case AMOperationTypeDivision:
            return @"/";
        case AMOperationTypeNone:
            return @"";
    }

}


- (void) saveFirstNumberWithOperationTag:(int)tag {
    
    self.firstNumber = [self getNumber];
    switch (tag) {
        case 113:
            self.operation = AMOperationTypeAddition;
            break;
        case 114:
            self.operation = AMOperationTypeSubstraction;
            break;
        case 115:
            self.operation = AMOperationTypeMultiplication;
            break;
        case 116:
            self.operation = AMOperationTypeDivision;
            break;
        default:
            break;
    }
    [self showFirstComponentWithOperation];
    [self clearWorkingString];
}

-(void) showFirstComponentWithOperation {

    NSString* textFirstNumberLabel = [NSString stringWithFormat:@"%@%@", [self getNumberString], [self stringFromOperationType:self.operation]];
    
    self.firstComponentLabel.text = [NSString stringWithFormat:@"%@%@", self.firstComponentLabel.text, textFirstNumberLabel];
    
}

- (CGFloat) calculateNumber:(CGFloat)firstNumber andSecondNumber:(CGFloat)secondNumber withOperation:(AMOperationType)operation {
    
    switch (operation) {
        case AMOperationTypeAddition:
            return firstNumber + secondNumber;
        case AMOperationTypeSubstraction:
            return firstNumber - secondNumber;
        case AMOperationTypeMultiplication:
            return firstNumber * secondNumber;
        case AMOperationTypeDivision:
            return firstNumber / secondNumber;
        case AMOperationTypeNone:
            return firstNumber;
    }
    
}

#pragma mark - Actions

- (IBAction)actionUpInsideDigitalButton:(UIButton *)sender {
    
    if ([self.workingString length] > 12) {
        return;
    }
    
    [self addDigit:(int)(sender.tag - 100)];
    
    [self showResultString];
    
    
}

- (IBAction)actionUpInsideSignButton:(UIButton *)sender {
    
    if ([self.workingString length]) {
        if ([self.workingString characterAtIndex:0]== '-') {
            [self.workingString deleteCharactersInRange:NSMakeRange(0, 1)];
        } else {
            [self.workingString insertString:@"-" atIndex:0];
        }
    }
    
    [self showResultString];
    
}

- (IBAction)actionUpInsideOperationButton:(UIButton *)sender {
    
    if (sender.tag == 112) {
        
        [self reset];
        
    } else if (sender.tag == 117) {
        
                if (self.firstNumber) {
                    
                    CGFloat secondNumber = [self getNumber];
                    if (self.operation == AMOperationTypeDivision && secondNumber == 0) {

                        [self reset];
                        
                    } else {
                        
                        CGFloat result = [self calculateNumber:self.firstNumber andSecondNumber:secondNumber withOperation:self.operation];
                        [self clearWorkingString];
                        [self.workingString appendFormat:@"%f", result];
                        [self removeZeroFromWorkingString];
                        NSString* textResultLabel = [NSString stringWithString:self.workingString];
                        [self reset];
                        self.resultLabel.text = textResultLabel;
                        
                    }
                }
        
            } else {
 
                if ([self.workingString length]) {
                    
                    if (self.firstNumber == 0) {
                        
                        [self saveFirstNumberWithOperationTag:(int)sender.tag];
                        
                    } else {
                        
                        CGFloat secondNumber = [self getNumber];
                        if (self.operation == AMOperationTypeDivision && secondNumber == 0) {
                            
                            [self reset];
                            
                        } else {
                            
                            CGFloat result = [self calculateNumber:self.firstNumber andSecondNumber:secondNumber withOperation:self.operation];
                            
                            [self clearWorkingString];
                            self.firstComponentLabel.text = @"";
                            [self.workingString appendFormat:@"%f", result];
                            [self removeZeroFromWorkingString];
                            self.resultLabel.text = self.workingString;
                            [self saveFirstNumberWithOperationTag:(int)sender.tag];
                            
                        }
                        
                    }
                    
                } else if ([self.resultLabel.text length] > 0 && ![self.resultLabel.text isEqualToString:@"0"]) {
                    
                    [self.workingString appendString:self.resultLabel.text];
                    [self removeZeroFromWorkingString];
                    [self saveFirstNumberWithOperationTag:(int)sender.tag];

                    
                }
                
            }
   
}

- (IBAction)actionUpInsideSeparatorButton:(UIButton *)sender {
    
    NSRange range = [self.workingString rangeOfString:@"."];
    if (range.location == NSNotFound) {
        [self.workingString length] ? [self.workingString appendString:@"."] : [self.workingString appendString:@"0."];
        [self showResultString];
    }

    
}


@end
