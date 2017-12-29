//
//  ViewController.m
//  27UITextField
//
//  Created by Admin on 05.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"

const int ageMaxLenght = 2;
const int phoneNumberMaxLenght = 12;
const int emailAddressMaxLenght = 25;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [[self.allTextFields firstObject] becomeFirstResponder];

    for (UILabel* infoLabel in self.allInfoLabels) {
        infoLabel.text = @"";
    }
    
}

#pragma mark - Methods

- (void) setInfoForTextField:(UITextField*)textField withString:(NSString*)string {
    
    NSInteger indexTextField = [self.allTextFields indexOfObject:textField];
    
    UILabel* infoLabel = [self.allInfoLabels objectAtIndex:indexTextField];
    
    infoLabel.text = string;
    
}

- (BOOL) requiredLenghtTextField:(UITextField*)textField fromResultString:(NSString*)string {
    
    BOOL requiredLenght = YES;
    
    if ([textField isEqual:self.ageTextField]) {
        if ([string length] > ageMaxLenght) {
            requiredLenght = NO;
        }
    } else if ([textField isEqual:self.phoneNumberTextField]) {
        if ([string length] > phoneNumberMaxLenght) {
            requiredLenght = NO;
        }
    } else if ([textField isEqual:self.emailAddressTextField]) {
        if ([string length] > emailAddressMaxLenght) {
            requiredLenght = NO;
        }
    }
    
    return requiredLenght;
    
}

- (NSInteger) countInString:(NSString*)string substring:(NSString*)substring {
    
    NSInteger count = 0;
    
    NSRange findingRange = [string rangeOfString:substring];
    while (YES) {
        if (findingRange.location != NSNotFound) {
            
            NSRange searchRange = NSMakeRange(findingRange.location + 1, [string length] - findingRange.location - 1);
            findingRange = [string rangeOfString:substring options:0 range:searchRange];
            count++;
            
        } else {
            break;
        }
    }
    
    return count;
    
}

- (NSString*) formatPhoneNumberFromString:(NSString*)string {
    
    NSMutableString* resultString = [NSMutableString string];
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 2;
    
    NSInteger localNumberLenght = MIN([string length], localNumberMaxLength);
    if (localNumberLenght > 0) {
        [resultString appendString:[string substringFromIndex:[string length] - localNumberLenght]];
        if ([string length] > 3) {
            [resultString insertString:@"-" atIndex:3];
        }
    }
    
    if ([string length] > localNumberMaxLength) {
        NSInteger areaCodeLength = MIN([string length] - localNumberMaxLength, areaCodeMaxLength);
        NSRange areaRange = NSMakeRange([string length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        NSString* areaString = [string substringWithRange:areaRange];
        [resultString insertString:[NSString stringWithFormat:@"(%@) ",areaString] atIndex:0];
    }
    
    if ([string length] > areaCodeMaxLength + localNumberMaxLength) {
        NSInteger countryCodeLength = MIN([string length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        NSString* countryString = [string substringToIndex:countryCodeLength];
        [resultString insertString:[NSString stringWithFormat:@"+%@ ",countryString] atIndex:0];
    }
    
    return resultString;
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString* newString = [NSMutableString stringWithString:textField.text];
    [newString replaceCharactersInRange:range withString:string];
 
    if ([newString isEqualToString:@"0"] && [textField isEqual:self.ageTextField]) {
        return NO;
    }
    
    NSCharacterSet* validCharacterPhoneNumber = [NSCharacterSet decimalDigitCharacterSet];
    NSMutableCharacterSet* validCharacterEmailAddress = [NSMutableCharacterSet alphanumericCharacterSet];
    [validCharacterEmailAddress formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"@._"]];
    
    NSArray* componentsString;
    
    if ([textField isEqual:self.phoneNumberTextField]) {
        componentsString = [newString componentsSeparatedByCharactersInSet:[validCharacterPhoneNumber invertedSet]];
        [newString replaceCharactersInRange:NSMakeRange(0, [newString length]) withString:[componentsString componentsJoinedByString:@""]];
    }
    
    if ([textField isEqual:self.ageTextField] || [textField isEqual:self.phoneNumberTextField]) {

        componentsString = [newString componentsSeparatedByCharactersInSet:[validCharacterPhoneNumber invertedSet]];
        if ([componentsString count] > 1) {
            return NO;
        }
  
    } else if ([textField isEqual:self.emailAddressTextField]) {
        
        componentsString = [newString componentsSeparatedByCharactersInSet:[validCharacterEmailAddress invertedSet]];
        
        if ([componentsString count] > 1) {
            return NO;
        } else {
            
            NSInteger countSymbol = [self countInString:newString substring:@"@"];
            if (countSymbol > 1) {
                return NO;
            }
            
            countSymbol = [self countInString:newString substring:@"."];
            if (countSymbol > 1) {
                return NO;
            }
            
        }
    }
 
    if (![self requiredLenghtTextField:textField fromResultString:newString]) {
        
        return NO;
        
    }
    
    NSMutableString* resultString;
    
    if ([textField isEqual:self.phoneNumberTextField]) {
        resultString = [NSMutableString stringWithString:[self formatPhoneNumberFromString:newString]];
        [self setInfoForTextField:textField withString:resultString];
        textField.text = resultString;
        return NO;
        
    } else {
        
        resultString = [NSMutableString stringWithString:newString];

    }
    
    [self setInfoForTextField:textField withString:resultString];
    
    return YES;
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [self setInfoForTextField:textField withString:@""];
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:[self.allTextFields lastObject]]) {
        [textField resignFirstResponder];
    } else {
        for (NSInteger i = 0; i < [self.allTextFields count] - 1; i++) {
            if ([textField isEqual:[self.allTextFields objectAtIndex:i]]) {
                [[self.allTextFields objectAtIndex:i+1] becomeFirstResponder];
            }
        }
    }
    
    return YES;
    
}


@end
