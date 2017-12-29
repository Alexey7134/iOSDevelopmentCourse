//
//  ViewController.m
//  39UIWebView
//
//  Created by Admin on 31.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"
#import "AMWebViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray* pathsToPDF;
@property (strong, nonatomic) NSArray* pathsToURL;

@end

@implementation ViewController


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pathsToPDF = [NSArray arrayWithObjects:@"File1.pdf", @"File2.pdf", nil];
    self.pathsToURL = [NSArray arrayWithObjects:@"https://vk.com/iosdevcourse", @"https://developer.apple.com/develop", @"https://github.com" , nil];
    
    self.tableView.allowsSelection = YES;
    self.navigationItem.title = @"Resource";

}

#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[AMWebViewController class]]) {
        
        AMWebViewController* destinationController = segue.destinationViewController;
        
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        if (indexPath.section == 0) {
            
            NSString* file = [self.pathsToPDF objectAtIndex:indexPath.row];
            destinationController.navigationItem.title = file;
            
            NSString* filePath = [[NSBundle mainBundle] pathForResource:file ofType:nil];
            
            destinationController.filePath = filePath;
            destinationController.typeFilePath = AMTypeFilePathPDF;
    
        } else {
            NSString* file = [self.pathsToURL objectAtIndex:indexPath.row];
            destinationController.navigationItem.title = file;
            
            destinationController.filePath = file;
            destinationController.typeFilePath = AMTypeFilePathHTML;
            
        }
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"AMWebViewController" sender:indexPath];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [self.pathsToPDF count];
    } else {
        return [self.pathsToURL count];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"AMTableViewCell";
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"PDF filetype.png"];
        cell.textLabel.text = [self.pathsToPDF objectAtIndex:indexPath.row];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"HTML filetype.png"];
        cell.textLabel.text = [self.pathsToURL objectAtIndex:indexPath.row];
    }
    
    return cell;
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"PDF";
    } else {
        return @"HTML";
    }
    
}

@end
