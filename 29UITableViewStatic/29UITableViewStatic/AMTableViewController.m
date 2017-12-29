//
//  AMTableViewController.m
//  29UITableViewStatic
//
//  Created by Admin on 06.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMTableViewController.h"

static const int phoneNumberMaxLenght = 12;
static const int emailAddressMaxLenght = 25;
static NSString* kLoginTextField = @"kLoginTextField";
static NSString* kPasswordTextField = @"kPasswordTextField";
static NSString* kNameTextField = @"kNameTextField";
static NSString* kPhoneNumberTextField = @"kPhoneNumberTextField";
static NSString* kEmailAddressTextField = @"kEmailAddressTextField";
static NSString* kGenderSegmentedControl = @"kGenderSegmentedControl";
static NSString* kDateOfBirthDatePicker = @"kDateOfBirthDatePicker";
static NSString* kEnableNotificationSwitch = @"kEnableNotificationSwitch";
static NSString* kSoundSwitch = @"kSoundSwitch";
static NSString* kVolumeSlider = @"kVolumeSlider";

@interface AMTableViewController ()

@end

@implementation AMTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[self.allTextFields firstObject] becomeFirstResponder];
    
    [self loadSetting];
    
    self.volumeSlider.enabled = self.soundSwitch.isOn;
    
}

#pragma mark Methods

- (BOOL) requiredLenghtTextField:(UITextField*)textField fromResultString:(NSString*)string {
    
    BOOL requiredLenght = YES;
    
    if ([textField isEqual:self.phoneNumberTextField]) {
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

    NSCharacterSet* validCharacterPhoneNumber = [NSCharacterSet decimalDigitCharacterSet];
    NSMutableCharacterSet* validCharacterEmailAddress = [NSMutableCharacterSet alphanumericCharacterSet];
    [validCharacterEmailAddress formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"@._"]];

    NSArray* componentsString;

    if ([textField isEqual:self.phoneNumberTextField]) {
        componentsString = [newString componentsSeparatedByCharactersInSet:[validCharacterPhoneNumber invertedSet]];
        [newString replaceCharactersInRange:NSMakeRange(0, [newString length]) withString:[componentsString componentsJoinedByString:@""]];
    }

    if ([textField isEqual:self.phoneNumberTextField]) {
     
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
     textField.text = resultString;
     return NO;
     
    } else {
     
     resultString = [NSMutableString stringWithString:newString];
     
    }

    [self saveSetting];

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

#pragma mark - Save/Load

- (void) saveSetting {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray* keys = [[NSArray alloc] initWithObjects:kLoginTextField, kPasswordTextField, kNameTextField, kPhoneNumberTextField, kEmailAddressTextField, nil];
    
    for (NSInteger i = 0; i < [self.allTextFields count]; i++) {
        
        UITextField* field = [self.allTextFields objectAtIndex:i];
        [userDefaults setObject:field.text forKey:[keys objectAtIndex:i]];
        
    }
    
    [userDefaults setInteger:self.genderSegmentedControl.selectedSegmentIndex forKey:kGenderSegmentedControl];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString* dateString = [dateFormatter stringFromDate:self.dateOfBirthDatePicker.date];
    [userDefaults setObject:dateString forKey:kDateOfBirthDatePicker];
    
    [userDefaults setBool:self.enableNotificationSwitch.isOn forKey:kEnableNotificationSwitch];
    [userDefaults setBool:self.soundSwitch.isOn forKey:kSoundSwitch];
    [userDefaults setDouble:self.volumeSlider.value forKey:kVolumeSlider];
    
    [userDefaults synchronize];
    
}

- (void) loadSetting {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray* keys = [[NSArray alloc] initWithObjects:kLoginTextField, kPasswordTextField, kNameTextField, kPhoneNumberTextField, kEmailAddressTextField, nil];
    
    for (NSInteger i = 0; i < [self.allTextFields count]; i++) {
        
        UITextField* field = [self.allTextFields objectAtIndex:i];
        field.text = [userDefaults objectForKey:[keys objectAtIndex:i]];
        
    }
    
    self.genderSegmentedControl.selectedSegmentIndex = [userDefaults integerForKey:kGenderSegmentedControl];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    if ([userDefaults objectForKey:kDateOfBirthDatePicker] != NULL) {
        [self.dateOfBirthDatePicker setDate:[dateFormatter dateFromString:[userDefaults objectForKey:kDateOfBirthDatePicker]] animated:YES];
    }
    
    
    self.enableNotificationSwitch.on = [userDefaults boolForKey:kEnableNotificationSwitch];
    
    self.soundSwitch.on = [userDefaults boolForKey:kSoundSwitch];
    self.volumeSlider.value = [userDefaults doubleForKey:kVolumeSlider];
    
}

#pragma mark - Actions

- (IBAction)actionValueChangedControls:(id)sender {
    
    if ([sender isEqual:self.soundSwitch]) {
        
        self.volumeSlider.enabled = self.soundSwitch.isOn;
        
    }
    
    [self saveSetting];
    
}

@end
