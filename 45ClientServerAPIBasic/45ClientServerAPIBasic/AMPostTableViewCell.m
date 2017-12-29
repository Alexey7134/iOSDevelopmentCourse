//
//  AMPostTableViewCell.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 12.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMPostTableViewCell.h"

@implementation AMPostTableViewCell

+ (CGFloat) heightCellForTextPost:(NSString*)text withImage:(BOOL)image {
    
    CGFloat offset = 5.f;
    
    CGFloat heightHeader = 45.f;
    CGFloat heightFooter = 25.f;
    
    
    UIFont* font = [UIFont systemFontOfSize:17.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5f;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentJustified];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                shadow, NSShadowAttributeName,
                                paragraph, NSParagraphStyleAttributeName,
                                nil];
    
    CGRect rectPost = [text boundingRectWithSize:CGSizeMake(320 - 4 * offset, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attributes
                                         context:nil];
    CGFloat heightPost = CGRectGetHeight(rectPost);
    
    CGFloat heightAttachmentsView = 0;
    
    if (image) {
        heightAttachmentsView = 200.f;
    }
    
    return (5 * offset + heightHeader + heightFooter + heightPost + heightAttachmentsView);
    
}

#pragma mark - Actions

- (IBAction)actionTouchUpInsideLikeButton:(UIButton *)sender {
    
    [self.delegate didTouchLikeButton:sender];
    
}

- (IBAction)actionTouchUpInsideAvatarButton:(UIButton *)sender {
    
    [self.delegate didTouchAvatarButton:sender];
    
}

@end
