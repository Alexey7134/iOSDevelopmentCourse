//
//  ViewController.h
//  27UITextField
//
//  Created by Admin on 05.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allTextFields;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *allInfoLabels;




@end

