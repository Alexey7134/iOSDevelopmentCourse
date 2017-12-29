//
//  AMCommentTableViewCell.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 24.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMCommentTableViewCell.h"

@implementation AMCommentTableViewCell

+ (CGFloat) heightCellForTextComment:(NSString*)text withImage:(BOOL)image {
    
    CGFloat offset = 10.f;
    
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
    
    CGRect rectPost = [text boundingRectWithSize:CGSizeMake(320 - 9 * offset, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attributes
                                         context:nil];
    CGFloat heightPost = CGRectGetHeight(rectPost);
    
    return (2 * offset + heightPost);
    
}

#pragma mark - Actions

- (IBAction)actionTouchUpInsideLikeButton:(UIButton *)sender {
    
    [self.delegate didTouchLikeButton:sender];
    
}

@end
