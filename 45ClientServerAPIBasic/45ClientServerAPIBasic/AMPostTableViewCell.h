//
//  AMPostTableViewCell.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 12.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMPostTableViewCellDelegate;

@interface AMPostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton* avatarButton;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (weak, nonatomic) IBOutlet UILabel* textPostLabel;
@property (weak, nonatomic) IBOutlet UIButton* likeButton;
@property (weak, nonatomic) IBOutlet UILabel* likeLabel;
@property (weak, nonatomic) IBOutlet UILabel* commentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView* attachmentsView;

- (IBAction)actionTouchUpInsideLikeButton:(UIButton *)sender;
- (IBAction)actionTouchUpInsideAvatarButton:(UIButton *)sender;

+ (CGFloat) heightCellForTextPost:(NSString*)text withImage:(BOOL)image;

@property (weak,nonatomic) id <AMPostTableViewCellDelegate> delegate;

@end

@protocol AMPostTableViewCellDelegate <NSObject>

@optional

- (void) didTouchLikeButton:(UIButton*)sender;
- (void) didTouchAvatarButton:(UIButton*)sender;

@end
