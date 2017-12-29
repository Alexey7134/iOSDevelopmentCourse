//
//  AMNewMessageTableViewCell.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 22.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMNewMessageTableViewCellDelegate;

@interface AMNewMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView* messageTextView;
@property (weak, nonatomic) IBOutlet UIButton* sendButton;

@property (weak,nonatomic) id <AMNewMessageTableViewCellDelegate> delegate;

- (IBAction)actionSendMessage:(UIButton*)sender;

@end

@protocol AMNewMessageTableViewCellDelegate <NSObject>

@optional

- (void) didTouchSendButton:(UIButton*)sender;

@end
