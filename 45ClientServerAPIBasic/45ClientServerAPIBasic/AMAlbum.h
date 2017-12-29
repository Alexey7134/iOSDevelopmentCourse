//
//  AMAlbum.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 26.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMServerObject.h"

@interface AMAlbum : AMServerObject

@property (assign, nonatomic) long albumID;
@property (assign, nonatomic) long ownerID;
@property (strong, nonatomic) NSString* name;

@end
