//
//  AMTableViewController.m
//  31UITableViewEditing
//
//  Created by Admin on 10.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMTableViewController.h"
#import "AMTopic.h"
#import "AMGroup.h"

static NSString* tableHeaderIdentifier = @"tableHeaderIdentifier";
static NSString* tableFooterIdentifier = @"tableFooterIdentifier";
static const int customHeightHeaderFooter = 30;

@interface AMTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* groups;

@end

@implementation AMTableViewController

- (void) loadView {
    
    [super loadView];

    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    self.navigationItem.title = @"Marketplace";
    
    UIBarButtonItem* editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEditBarButton:)];
    self.navigationItem.rightBarButtonItem = editBarButton;
    
    UIBarButtonItem* addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddBarButton:)];
    self.navigationItem.leftBarButtonItem = addBarButton;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSArray* groupNames = [[NSArray alloc] initWithObjects:@"Sell", @"Buy", @"Exchange", @"Give", @"Find", @"Rent", @"Show", nil];
    
    NSMutableArray* groups = [NSMutableArray array];
    
    for (NSString* anyGroupName in groupNames) {
        AMGroup* newGroup = [[AMGroup alloc] init];
        newGroup.name = anyGroupName;
        NSMutableArray* topics = [NSMutableArray array];
        for (NSInteger i = 0; i < arc4random() % 20 + 1; i++) {
            AMTopic* newTopic = [AMTopic randomTopic];
            [topics addObject:newTopic];
        }
        newGroup.topics = topics;
        [groups addObject:newGroup];
    }
    
    self.groups = groups;
    
    
    UITableViewHeaderFooterView* customHeaderView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), customHeightHeaderFooter)];
    [self.tableView registerClass:[customHeaderView class] forHeaderFooterViewReuseIdentifier:tableHeaderIdentifier];
    
    UITableViewHeaderFooterView* customFooterView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), customHeightHeaderFooter)];
    [self.tableView registerClass:[customFooterView class] forHeaderFooterViewReuseIdentifier:tableFooterIdentifier];
    

    self.tableView.tableHeaderView = customHeaderView;
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
}

#pragma mark - Methods

- (NSInteger) rowTopicForIndexPath:(NSIndexPath*)indexPath {
    
    return indexPath.row - 1;
    
}

- (void) updateTextFooterForSection:(NSInteger)section {
    
    AMGroup* group = [self.groups objectAtIndex:section];
    UITableViewHeaderFooterView* footerView = [self.tableView footerViewForSection:section];
    footerView.textLabel.text = [NSString stringWithFormat:@"Count topics in section %@ - %d", group.name, (int)[group.topics count]];
    
}

- (void) updateData {
    
    [self.tableView reloadData];
}

#pragma mark - Actions Buttons


- (void) actionDeleteGroupButton:(UIButton*)sender {

    [self.groups removeObjectAtIndex:sender.tag];
    
    [self.tableView beginUpdates];
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:sender.tag];
    [self.tableView deleteSections:indexes withRowAnimation:UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
    
    [self performSelector:@selector(updateData) withObject:self afterDelay:0.3];
    
}

#pragma mark - Actions Bar Buttons

- (void) actionAddBarButton:(UIBarButtonItem*)sender {
    
    AMGroup* newGroup = [[AMGroup alloc] init];
    newGroup.name = @"New group";
    NSMutableArray* topics = [NSMutableArray array];
    for (NSInteger i = 0; i < arc4random() % 9 + 1; i++) {
        AMTopic* newTopic = [AMTopic randomTopic];
        [topics addObject:newTopic];
    }
    newGroup.topics = topics;
    
    [self.groups insertObject:newGroup atIndex:0];
    
    [self.tableView beginUpdates];
    
    NSInteger indexNewSection = 0;
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:indexNewSection];
    
    UITableViewRowAnimation sectionAnimated = UITableViewRowAnimationLeft;
    if ([self.groups count] > 1) {
        sectionAnimated = [self.groups count] % 2 ? UITableViewRowAnimationRight : UITableViewRowAnimationLeft;
    }
    
    [self.tableView insertSections:indexSet withRowAnimation:sectionAnimated];
    
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
    [self performSelector:@selector(updateData) withObject:self afterDelay:0.3f];
}

- (void) actionEditBarButton:(UIBarButtonItem*)sender {
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.isEditing) {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(actionEditBarButton:)];
    
    [self.navigationItem setRightBarButtonItem:editBarButton animated:YES];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        AMGroup* group = [self.groups objectAtIndex:indexPath.section];
        NSMutableArray* topics = [NSMutableArray arrayWithArray:group.topics];
        [topics insertObject:[AMTopic randomTopic] atIndex:0];
        group.topics = topics;
        [tableView beginUpdates];
        NSArray* indexes = [NSArray arrayWithObject:[NSIndexPath indexPathForItem:indexPath.row + 1 inSection:indexPath.section]];
        [tableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
        [self updateTextFooterForSection:indexPath.section];
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    }
    
    return proposedDestinationIndexPath;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleDelete;
    
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AMGroup* group = [self.groups objectAtIndex:indexPath.section];
        NSMutableArray* topics = [NSMutableArray arrayWithArray:group.topics];
        [topics removeObjectAtIndex:[self rowTopicForIndexPath:indexPath]];
        group.topics = topics;
        
        [tableView beginUpdates];
  
        NSArray* indexes = [NSArray arrayWithObject:indexPath];
        [tableView deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationLeft];
        
        [tableView endUpdates];
        
        [self updateTextFooterForSection:indexPath.section];
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Delete topic";
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return customHeightHeaderFooter;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return customHeightHeaderFooter;
    
}

- (nullable UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView* customHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:tableHeaderIdentifier];

    customHeaderView.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4f];

    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.tableView.bounds) * 0.75f, 0, CGRectGetWidth(self.tableView.bounds) / 4, 30)];
    button.tag = section;

    [button setTitle:@"Delete" forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor purpleColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionDeleteGroupButton:) forControlEvents:UIControlEventTouchDown];
    [customHeaderView.contentView addSubview:button];
    
    return customHeaderView;

}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView* customFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:tableFooterIdentifier];
    
    customFooterView.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2f];
    
    return customFooterView;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.groups count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    AMGroup* group = [self.groups objectAtIndex:section];
    
    return [group.topics count] + 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        static NSString* addIdentifier = @"Add new topic";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addIdentifier];
            
        }
        cell.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2f];
        cell.textLabel.text = addIdentifier;
        cell.textLabel.textColor = [UIColor purpleColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        
        AMGroup* group = [self.groups objectAtIndex:indexPath.section];
        AMTopic* topic = [group.topics objectAtIndex:[self rowTopicForIndexPath:indexPath]];
        
        static NSString* identifier = @"Topic";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];

        }
        cell.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1f];
        cell.textLabel.text = topic.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", topic.price];
        return cell;
        
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    AMGroup* group = [self.groups objectAtIndex:section];
    
    return group.name;
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    AMGroup* group = [self.groups objectAtIndex:section];
    
    return [NSString stringWithFormat:@"Count topics in section %@ - %ld", group.name, [group.topics count]];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
    
}
- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    if (destinationIndexPath.row != 0) {
        
        AMGroup* sourceGroup = [self.groups objectAtIndex:sourceIndexPath.section];
        AMTopic* sourceTopic = [sourceGroup.topics objectAtIndex:[self rowTopicForIndexPath:sourceIndexPath]];
        
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:sourceGroup.topics];
        
        if (sourceIndexPath.section == destinationIndexPath.section) {
            
            [tempArray removeObject:sourceTopic];
            [tempArray insertObject:sourceTopic atIndex:[self rowTopicForIndexPath:destinationIndexPath]];
            sourceGroup.topics = tempArray;
            
        } else {
            
            [tempArray removeObject:sourceTopic];
            sourceGroup.topics = tempArray;
            
            AMGroup* destinationGroup = [self.groups objectAtIndex:destinationIndexPath.section];
            tempArray = [NSMutableArray arrayWithArray:destinationGroup.topics];
            [tempArray insertObject:sourceTopic atIndex:[self rowTopicForIndexPath:destinationIndexPath]];
            destinationGroup.topics = tempArray;
            [self updateTextFooterForSection:sourceIndexPath.section];
            [self updateTextFooterForSection:destinationIndexPath.section];
            
        }
    }
    
}

@end
