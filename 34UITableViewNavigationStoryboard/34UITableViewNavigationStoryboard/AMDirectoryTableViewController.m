//
//  AMDirectoryTableViewController.m
//  34UITableViewNavigationStoryboard
//
//  Created by Admin on 16.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDirectoryTableViewController.h"
#import "AMFolderTableViewCell.h"
#import "AMFileTableViewCell.h"
#import "UIView+UITableViewCell.h"
#import "AMCalculateSizeFileOperation.h"

static NSString* startPathForApplication = @"/Volumes/VMWare Shared Folders/Works";

@interface AMDirectoryTableViewController ()

@property (strong, nonatomic) NSArray* contents;
@property (strong, nonatomic) NSMutableDictionary* contentsSize;
@property (strong, nonatomic) NSOperationQueue* queue;

@end

@implementation AMDirectoryTableViewController

- (void) setPath:(NSString *)path {
    
    _path = path;
    
    NSError* error = nil;
    self.contents = [[NSFileManager alloc] contentsOfDirectoryAtPath:self.path error:&error];
    
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    if (!self.path) {
        self.path = startPathForApplication;
    }
    self.queue = [[NSOperationQueue alloc] init];
    [self removeHiddenFilesFromContents];
    [self sortContents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculateSizeFileOperationDidFinishNotification:) name:AMCalculateSizeFileOperationDidFinishNotification object:nil];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationItem.title = [self.path lastPathComponent];
    self.contentsSize = [[NSMutableDictionary alloc] init];
    [self.queue cancelAllOperations];
    
    AMCalculateSizeFileOperation* operation = [[AMCalculateSizeFileOperation alloc] initWithFileContents:self.contents atPath:self.path];
    
    [self.queue addOperation:operation];
    
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Notifications

- (void) calculateSizeFileOperationDidFinishNotification:(NSNotification*)notification {
    
    NSDictionary* userInfo = notification.userInfo;
    
    NSString* path = [userInfo objectForKey:AMCalculateSizeFileOperationUserInfoKeyFilePath];
    NSString* fileName = [userInfo objectForKey:AMCalculateSizeFileOperationUserInfoKeyFileName];
    long long size = [[userInfo objectForKey:AMCalculateSizeFileOperationUserInfoKeyFileSize] longLongValue];
    
    if ([self.path isEqualToString:path]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.contentsSize setObject:[NSNumber numberWithLongLong:size] forKey:fileName];
            
            [self.tableView beginUpdates];
            NSArray* indexes = [NSArray arrayWithObject:[self indexPathForFileName:fileName]];
            [self.tableView reloadRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
        
    }
    
}

#pragma mark - Actions

- (IBAction)actionAddBarButton:(UIBarButtonItem *)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Enter name new folder/file" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* folderButton = [UIAlertAction actionWithTitle:@"Create folder" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action){
                                                             if ([alertController.textFields[0].text length] > 0) {
                                                                 [self createNewFolderWithName:alertController.textFields[0].text];
                                                             }
                                                         }];
    
    UIAlertAction* fileButton = [UIAlertAction actionWithTitle:@"Create file" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action){
                                                           if ([alertController.textFields[0].text length] > 0) {
                                                               [self createNewFileWithName:alertController.textFields[0].text];
                                                           }
                                                       }];
    
    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:folderButton];
    [alertController addAction:fileButton];
    [alertController addAction:cancelButton];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Name";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)actionTouchUpInsideInfoButton:(UIButton *)sender {

    AMFileTableViewCell* cell = (AMFileTableViewCell*)[sender superCell];
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    NSString* path = [self pathToFile:fileName];
    
    NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    NSDate* dateCreation = attributes.fileCreationDate;
    NSDate* dateChanged = attributes.fileModificationDate;

    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Info" message:[NSString stringWithFormat:@"%@\ndate creation: %@\ndate changed: %@", fileName, [dateFormatter stringFromDate:dateCreation], [dateFormatter stringFromDate:dateChanged]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okButton];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - Methods

- (NSString*) pathToFile:(NSString*)fileName {
    
    return [self.path stringByAppendingPathComponent:fileName];
    
}

- (void) sortContents {
    
    self.contents = [self.contents sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        
        BOOL isDirectoryObj1 = [self isDirectoryFileAtPath:[self.path stringByAppendingPathComponent:obj1]];
        BOOL isDirectoryObj2 = [self isDirectoryFileAtPath:[self.path stringByAppendingPathComponent:obj2]];
        
        if (isDirectoryObj1 && !isDirectoryObj2) {
            return NSOrderedAscending;
        } else if (!isDirectoryObj1 && isDirectoryObj2) {
            return NSOrderedDescending;
        } else {
            return [obj1 compare:obj2];
        }
    }];
    
}

- (void) createNewFolderWithName:(NSString*)folderName {
    
    NSError* error = nil;
    if ([[NSFileManager defaultManager] createDirectoryAtPath:[self pathToFile:folderName] withIntermediateDirectories:NO attributes:nil error:&error]) {
        NSMutableArray* tempContents = [NSMutableArray arrayWithArray:self.contents];
        [tempContents addObject:folderName];
        self.contents = tempContents;
        [self sortContents];
        [self.contentsSize setObject:[NSNumber numberWithLongLong:0] forKey:folderName];
        
        [self insertRowInTableViewForFileName:folderName withRowAnimation:UITableViewRowAnimationLeft];
        
    } else {
        
        NSLog(@"%@",[error localizedDescription]);
        
    }
    
}

- (void) createNewFileWithName:(NSString*)fileName {
    
    NSError* error = nil;
    if ([[NSFileManager defaultManager] createFileAtPath:[self pathToFile:fileName] contents:nil attributes:nil]) {
        
        NSMutableArray* tempContents = [NSMutableArray arrayWithArray:self.contents];
        [tempContents addObject:fileName];
        self.contents = tempContents;
        [self.contentsSize setObject:[NSNumber numberWithLongLong:0] forKey:fileName];
        [self sortContents];
        
        [self insertRowInTableViewForFileName:fileName withRowAnimation:UITableViewRowAnimationRight];
        
    } else {
        NSLog(@"%@",[error localizedDescription]);
    }
    
}

- (void) insertRowInTableViewForFileName:(NSString*)fileName withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    
    [self.tableView beginUpdates];
    
    NSArray* indexes = [NSArray arrayWithObject:[self indexPathForFileName:fileName]];
    [self.tableView insertRowsAtIndexPaths:indexes withRowAnimation:rowAnimation];
    
    [self.tableView endUpdates];
    
}

- (NSIndexPath*) indexPathForFileName:(NSString*)fileName {
    
    NSInteger section = 0;
    NSInteger row = 0;
    for (NSInteger index = 0; index < [self.contents count]; index++) {
        if ([[self.contents objectAtIndex:index] isEqualToString:fileName]) {
            row = index;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void) removeHiddenFilesFromContents {
    
    NSMutableArray* contents = [NSMutableArray array];
    for (NSString* fileName in self.contents) {
        if (![self isHiddenFile:fileName]) {
            [contents addObject:fileName];
        }
    }
    self.contents = contents;
    
}

- (BOOL) isDirectoryFileAtPath:(NSString*)path {
    
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    return isDirectory;
    
}

- (BOOL) isHiddenFile:(NSString*)fileName {
    
    NSString* firstSymbol = [fileName substringToIndex:1];
    
    if ([firstSymbol isEqualToString:@"."]) {
        return YES;
    } else {
        return NO;
    }
    
}

- (NSString*) stringWithSize:(long long)sizeOfFile {
    
    NSArray* identifierSize = [NSArray arrayWithObjects:@"b", @"Kb", @"Mb", @"Gb", @"Tb", nil];
    
    NSInteger index = 0;
    
    CGFloat size = (CGFloat) sizeOfFile;
    
    if (size == 0) {
        return @"";
    }
    
    while (size >= 1024) {
        size /= 1024.f;
        index++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", size, [identifierSize objectAtIndex:index]];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    NSString* path = [self pathToFile:fileName];
    
    if ([self isDirectoryFileAtPath:path]) {
        
        AMDirectoryTableViewController* tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMDirectoryTableViewController"];
        tableViewController.path = path;
        [self.navigationController pushViewController:tableViewController animated:YES];
       
    }
    
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.contents count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifierFolderCell = @"AMFolderTableViewCell";
    static NSString* identifierFileCell = @"AMFileTableViewCell";
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    long long size = [[self.contentsSize objectForKey:fileName] longLongValue];
    
    if ([self isDirectoryFileAtPath:[self pathToFile:fileName]]) {
        AMFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierFolderCell];
        cell.title.text = fileName;
        cell.subtitle.text = [self stringWithSize:size];
        return cell;
    }
    
    AMFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierFileCell];
    cell.title.text = fileName;
    cell.subtitle.text = [self stringWithSize:size];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    
    if ([self isDirectoryFileAtPath:[self pathToFile:fileName]]) {
        return 60;
    }
    return 70;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    NSMutableArray* tempContents = [NSMutableArray arrayWithArray:self.contents];
    
    if ([[NSFileManager defaultManager] removeItemAtPath:[self pathToFile:fileName] error:nil]) {
        [tempContents removeObject:fileName];
        self.contents = tempContents;
        [self.contentsSize removeObjectForKey:fileName];
    }
    
    [self.tableView beginUpdates];
    NSArray* indexes = [NSArray arrayWithObject:indexPath];
    [self.tableView deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    
}

@end
