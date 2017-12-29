//
//  AMStickerAttachment.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 21.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMAttachment.h"

@interface AMStickerAttachment : AMAttachment

@property (strong, nonatomic) NSURL* photo64;
@property (strong, nonatomic) NSURL* photo128;

@end
