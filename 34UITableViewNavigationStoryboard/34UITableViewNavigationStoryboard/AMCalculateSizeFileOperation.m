//
//  AMCalculateSizeFileOperation.m
//  34UITableViewNavigationStoryboard
//
//  Created by Admin on 19.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMCalculateSizeFileOperation.h"

NSString* AMCalculateSizeFileOperationUserInfoKeyFileName = @"AMCalculateSizeFileOperationUserInfoKeyFileName";
NSString* AMCalculateSizeFileOperationUserInfoKeyFilePath = @"AMCalculateSizeFileOperationUserInfoKeyFilePath";
NSString* AMCalculateSizeFileOperationUserInfoKeyFileSize = @"AMCalculateSizeFileOperationUserInfoKeyFileSize";
NSString* AMCalculateSizeFileOperationDidFinishNotification = @"AMCalculateSizeFileOperationDidFinishNotification";

@interface AMCalculateSizeFileOperation ()

@property (assign, nonatomic) long long size;

@end

@implementation AMCalculateSizeFileOperation

- (instancetype)initWithFileContents:(NSArray*)contents atPath:(NSString*)path {
    
    self = [super init];
    if (self) {
        self.contents = contents;
        self.path = path;
    }
    return self;
}

- (void) main {
    
    if (!self.isCancelled) {
        
        for (NSString* anyContent in self.contents) {
            
            if (!self.isCancelled) {
        
                self.size = [self sizeForFile:[self.path stringByAppendingPathComponent:anyContent]];
            
                if (!self.isCancelled) {
                    
                    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                                          self.path, AMCalculateSizeFileOperationUserInfoKeyFilePath,
                                          anyContent, AMCalculateSizeFileOperationUserInfoKeyFileName,
                                          [NSNumber numberWithLongLong:self.size], AMCalculateSizeFileOperationUserInfoKeyFileSize, nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:AMCalculateSizeFileOperationDidFinishNotification object:self userInfo:info];
                    
                    
                } else {
                    break;
                }
            }
            
        }
        
    }
    
}

#pragma mark - Methods

- (long long) sizeForFile:(NSString*)fileName {
    
    long long size = 0;
    
    if (!self.isCancelled) {
        
        if ([self isDirectoryFileAtPath:fileName]) {
            NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fileName error:nil];
            for (NSString* anyFileName in contents) {
                size += [self sizeForFile:[fileName stringByAppendingPathComponent:anyFileName]];
            }
        } else {
            
            NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:nil];
            size =  attributes.fileSize;
            
        }
        
    }

    return size;
    
}

- (BOOL) isDirectoryFileAtPath:(NSString*)path {
    
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    return isDirectory;
    
}

@end
