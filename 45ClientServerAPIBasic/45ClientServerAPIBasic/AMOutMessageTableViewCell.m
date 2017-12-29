//
//  AMOutMessageTableViewCell.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 22.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMOutMessageTableViewCell.h"

@implementation AMOutMessageTableViewCell

+ (CGFloat) heightCellForTextPost:(NSString*)text withImage:(BOOL)image {
    
    CGFloat offset = 10.f;
    
    CGFloat heightHeader = 10.f;
    CGFloat heightFooter = 10.f;
    
    
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
    
    CGRect rectMessage = [text boundingRectWithSize:CGSizeMake(320 - 3 * offset - 30, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attributes
                                         context:nil];
    
    CGFloat heightMessage = CGRectGetHeight(rectMessage);
    
    CGFloat heightAttachmentsView = 0;
    
    if (image) {
        
        heightAttachmentsView = offset + 200.f;
    }
    
    if (heightHeader + heightFooter + heightMessage + heightAttachmentsView < 50) {
        
        return 50;
    }
    
    return (heightHeader + heightFooter + heightMessage + heightAttachmentsView);
    
}


@end
