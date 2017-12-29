//
//  AMDialogTableViewCell.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 21.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDialogTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* dialogAvatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView* userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel* dialogLabel;
@property (weak, nonatomic) IBOutlet UILabel* messageLabel;

@end
