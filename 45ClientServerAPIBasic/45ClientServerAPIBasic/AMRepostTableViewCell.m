//
//  AMRepostTableViewCell.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 15.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMRepostTableViewCell.h"

@implementation AMRepostTableViewCell

#pragma mark - Actions

- (IBAction)actionTouchUpInsideLikeButton:(UIButton *)sender {
    
    [self.delegate didTouchLikeButton:sender];
    
}

- (IBAction)actionTouchUpInsideAvatarButton:(UIButton *)sender {
    
    [self.delegate didTouchAvatarButton:sender];
    
}
@end
