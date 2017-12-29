//
//  AMRepostTableViewCell.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 15.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMRepostTableViewCellDelegate;

@interface AMRepostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton* avatarButton;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (weak, nonatomic) IBOutlet UIButton* reAvatarButton;
@property (weak, nonatomic) IBOutlet UILabel* reNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* reDateLabel;
@property (weak, nonatomic) IBOutlet UILabel* textPostLabel;
@property (weak, nonatomic) IBOutlet UIButton* likeButton;
@property (weak, nonatomic) IBOutlet UILabel* likeLabel;
@property (weak, nonatomic) IBOutlet UILabel* commentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView* attachmentsView;

- (IBAction)actionTouchUpInsideLikeButton:(UIButton *)sender;
- (IBAction)actionTouchUpInsideAvatarButton:(UIButton *)sender;

@property (weak,nonatomic) id <AMRepostTableViewCellDelegate> delegate;

@end


@protocol AMRepostTableViewCellDelegate <NSObject>

@optional

- (void) didTouchLikeButton:(UIButton*)sender;
- (void) didTouchAvatarButton:(UIButton*)sender;

@end
