//
//  AMDetailStudentTableViewCell.h
//  41CoreData
//
//  Created by Admin on 12.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AMFormatTextField) {
    AMFormatTextFieldInteger,
    AMFormatTextFieldName,
    AMFormatTextFieldEmail,
    AMFormatTextFieldFloat
};

@interface AMDetailStudentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* title;
@property (weak, nonatomic) IBOutlet UITextField* textField;
@property (assign, nonatomic) AMFormatTextField formatTextField;

@end
