//
//  AMOutMessageTableViewCell.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 22.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMOutMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* userImageView;
@property (weak, nonatomic) IBOutlet UILabel* messageLabel;

+ (CGFloat) heightCellForTextPost:(NSString*)text withImage:(BOOL)image;

@end
