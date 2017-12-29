//
//  AMCalculateSizeFileOperation.h
//  34UITableViewNavigationStoryboard
//
//  Created by Admin on 19.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* AMCalculateSizeFileOperationUserInfoKeyFileName;
extern NSString* AMCalculateSizeFileOperationUserInfoKeyFilePath;
extern NSString* AMCalculateSizeFileOperationUserInfoKeyFileSize;
extern NSString* AMCalculateSizeFileOperationDidFinishNotification;

@interface AMCalculateSizeFileOperation : NSOperation

@property (strong, nonatomic) NSArray* contents;
@property (strong, nonatomic) NSString* path;

- (instancetype)initWithFileContents:(NSArray*)contents atPath:(NSString*)path;

@end
