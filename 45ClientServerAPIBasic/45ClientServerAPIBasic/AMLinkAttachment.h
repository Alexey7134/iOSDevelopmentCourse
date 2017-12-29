//
//  AMLinkAttachment.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 14.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMAttachment.h"

@class AMPhotoAttachment;

@interface AMLinkAttachment : AMAttachment

@property (strong, nonatomic) NSString* link;
@property (strong, nonatomic) AMPhotoAttachment* photo;

@end
