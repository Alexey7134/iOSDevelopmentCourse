//
//  AMDirectoryTableViewController.m
//  33UITableViewNavigation
//
//  Created by Admin on 13.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDirectoryTableViewController.h"

@interface AMDirectoryTableViewController ()

@property (strong, nonatomic) NSString* path;
@property (strong, nonatomic) NSArray* contents;
@property (strong, nonatomic) NSMutableDictionary* contentsSize;

@end

@implementation AMDirectoryTableViewController

- (id) initWithFolderPath:(NSString*)path {
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        self.path = path;
        NSError* error = nil;
        self.contents = [[NSFileManager alloc] contentsOfDirectoryAtPath:self.path error:&error];
        if (error) {
            NSLog(@"Error description - %@", [error localizedDescription]);
        }
    }
    
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self removeHiddenFilesFromContents];
    
    [self sortContents];
    
    self.navigationItem.title = [self.path lastPathComponent];
    
    UIBarButtonItem* addNewItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddNewItem)];

    self.navigationItem.rightBarButtonItem = addNewItem;
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.contentsSize = [[NSMutableDictionary alloc] init];
    for (NSString* anyContent in self.contents) {
        [[self getQueueForCells] addOperationWithBlock:^{
            
            long long size = [self sizeForFile:[self pathToFile:anyContent]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.contentsSize setObject:[NSNumber numberWithLongLong:size] forKey:anyContent];
                
                [self.tableView beginUpdates];
                NSArray* indexes = [NSArray arrayWithObject:[self indexPathForFileName:anyContent]];
                [self.tableView reloadRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            });
        }];
    }
    
}

#pragma mark - Actions

- (void) actionAddNewItem {
 
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

#pragma mark - Methods

- (NSOperationQueue*) getQueueForCells {
    
    static NSOperationQueue* queueCells = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queueCells = [[NSOperationQueue alloc] init];
    });
    return queueCells;
    
}

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
        [self.contentsSize setObject:[NSNumber numberWithLongLong:[self sizeForFile:folderName]] forKey:folderName];
        
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
        [self.contentsSize setObject:[NSNumber numberWithLongLong:[self sizeForFile:fileName]] forKey:fileName];
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

- (long long) sizeForFile:(NSString*)fileName {
    
    long long size = 0;
    
    if ([self isDirectoryFileAtPath:fileName]) {
        NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fileName error:nil];
        for (NSString* anyFileName in contents) {
            size += [self sizeForFile:[fileName stringByAppendingPathComponent:anyFileName]];
        }
    } else {
        
        NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:nil];
        size =  attributes.fileSize;
        
    }

    return size;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    NSString* path = [self pathToFile:fileName];
    
    if ([self isDirectoryFileAtPath:path]) {
        AMDirectoryTableViewController* tableViewController = [[AMDirectoryTableViewController alloc] initWithFolderPath:path];
        
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
    
    static NSString* identifierCell = @"identifierCell";

    UITableViewCell *cell;
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    
    UIImage* imageFileName = nil;
    
    if ([self isDirectoryFileAtPath:[self pathToFile:fileName]]) {
        imageFileName = [UIImage imageNamed:@"Folder.png"];
    } else {
        imageFileName = [UIImage imageNamed:@"File.png"];
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierCell];
    } else {
        cell.detailTextLabel.text = @"";
    }

    long long size = [[self.contentsSize objectForKey:fileName] longLongValue];
    cell.detailTextLabel.text = [self stringWithSize:size];
    cell.imageView.image = imageFileName;
    cell.textLabel.text = fileName;
    
    return cell;
    
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
