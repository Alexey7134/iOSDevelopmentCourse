//
//  UIView+UITableViewCell.m
//  34UITableViewNavigationStoryboard
//
//  Created by Admin on 17.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "UIView+UITableViewCell.h"

@implementation UIView (UITableViewCell)

- (UITableViewCell*) superCell {
    
    if (!self.superview) {
        return  nil;
    }
    
    if ([self.superview isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell*)self.superview;
    }
    
    return [self.superview superCell];
    
}

@end
