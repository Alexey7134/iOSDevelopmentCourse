//
//  AMNewMessageTableViewCell.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 22.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMNewMessageTableViewCell.h"

@implementation AMNewMessageTableViewCell

- (IBAction)actionSendMessage:(UIButton *)sender {
    
    [self.delegate  didTouchSendButton:sender];
    
}

@end
