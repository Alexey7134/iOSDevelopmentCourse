//
//  AMCommentTableViewCell.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 24.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMCommentTableViewCellDelegate;

@interface AMCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton* likeButton;
@property (weak, nonatomic) IBOutlet UILabel* commentLabel;

- (IBAction)actionTouchUpInsideLikeButton:(UIButton *)sender;

+ (CGFloat) heightCellForTextComment:(NSString*)text withImage:(BOOL)image;

@property (weak,nonatomic) id <AMCommentTableViewCellDelegate> delegate;

@end

@protocol AMCommentTableViewCellDelegate <NSObject>

@optional

- (void) didTouchLikeButton:(UIButton*)sender;

@end
