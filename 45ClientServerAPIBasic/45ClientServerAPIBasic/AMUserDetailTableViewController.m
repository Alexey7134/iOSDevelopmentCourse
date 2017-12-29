//
//  AMUserDetailTableViewController.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 04.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMUserDetailTableViewController.h"
#import "AMUser.h"
#import "AMServerManager.h"
#import "UIColor+AMCustomColor.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AMUserSubscriptionsViewController.h"
#import "AMUserWallViewController.h"

@interface AMUserDetailTableViewController ()

@end

@implementation AMUserDetailTableViewController

- (void) setUser:(AMUser *)user {
    
    _user = user;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    __weak typeof(self) weakSelf = self;
    
    [[AMServerManager sharedManager] getDetailUserForID:user.userID
                                              onSuccess:^(AMUser *user) {
                                                  _user = user;
                                                  [weakSelf showUserDetail];
                                                  [weakSelf.tableView reloadData];
                                              }
                                              onFailure:nil];
    
}

#pragma mark - UIView Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

#pragma mark - Methods

- (void) showUserDetail {
    
    if (self.user.dateOfBirth) {
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear
                                                   fromDate:self.user.dateOfBirth
                                                     toDate:[NSDate dateWithTimeIntervalSinceNow:0]
                                                    options:0];
        
        NSInteger year = components.year;
        
        self.ageLabel.text = [NSString stringWithFormat:@"%ld", (long)year];
        
    } else {
        
        self.ageLabel.text = @"???";
    }
    

    self.countryLabel.text = self.user.country;
    self.cityLabel.text = self.user.city;
    
    
    UIImage* withoutPhoto = [UIImage imageNamed:@"nophoto.png"];
    NSURLRequest* request = [NSURLRequest requestWithURL:self.user.photo200];
    
    __weak UIImageView* weakPhotoImageView = self.photoImageView;
    
    self.photoImageView.layer.cornerRadius = 20;
    self.photoImageView.layer.masksToBounds = YES;
    
    [self.photoImageView setImageWithURLRequest:request
                                  placeholderImage:withoutPhoto
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                               weakPhotoImageView.image = image;
                                           }
                                           failure:nil];
    
    
}

#pragma mark - UITableViewDelegate

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        return indexPath;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary* infoSegue = [NSMutableDictionary dictionary];
    [infoSegue setObject:@(self.user.userID) forKey:@"userID"];
    
    if (indexPath.section == 2) {
        
        switch (indexPath.row) {
                
            case 0:
                
                [infoSegue setObject:@(0) forKey:@"AMRequestType"];
                [self performSegueWithIdentifier:@"AMUserSubscriptionsViewController" sender:infoSegue];
                
                break;
            case 1:
                
                [infoSegue setObject:@(1) forKey:@"AMRequestType"];
                [self performSegueWithIdentifier:@"AMUserSubscriptionsViewController" sender:infoSegue];
                
                break;
            case 2:
                
                if ([[AMServerManager sharedManager] isLogin]) {
                    
                    [self performSegueWithIdentifier:@"AMUserWallViewController" sender:@(self.user.userID)];
                    
                } else {
                    
                }
                break;
                
        }
        
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect frame = cell.frame;
    
    UIView* backgroundView = [[UIView alloc] initWithFrame:frame];
    
    if (indexPath.section < 2) {
        
        backgroundView.backgroundColor = [UIColor lightGrayCustomColor];
        
    } else {
        
        backgroundView.backgroundColor = [UIColor clearColor];
     
        switch (indexPath.row) {
            case 0:
                backgroundView.backgroundColor = [UIColor yellowCustomColor];
                break;
            case 1:
                backgroundView.backgroundColor = [UIColor orangeCustomColor];
                break;
            case 2:
                backgroundView.backgroundColor = [UIColor pinkCustomColor];
                break;
        }
     
    }
    
    cell.backgroundView = backgroundView;
    
    backgroundView.layer.masksToBounds = YES;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    if (indexPath.section == 0) {
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: cell.backgroundView.bounds
                                                       byRoundingCorners: UIRectCornerAllCorners
                                                             cornerRadii: CGSizeMake(20, 20)];
        
        maskLayer.path = maskPath.CGPath;

        cell.backgroundView.layer.mask = maskLayer;
        
    } else {
        
        if (indexPath.row == 0) {
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: cell.backgroundView.bounds
                                                           byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight
                                                                 cornerRadii: CGSizeMake(20, 20)];
            
            maskLayer.path = maskPath.CGPath;
            
            cell.backgroundView.layer.mask = maskLayer;
                        
        } else if (indexPath.row == 2) {
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: cell.backgroundView.bounds
                                                           byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                 cornerRadii: CGSizeMake(20, 20)];
            
            maskLayer.path = maskPath.CGPath;
            
            cell.backgroundView.layer.mask = maskLayer;
            
        } else {
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:cell.backgroundView.bounds];
            
            maskLayer.path = maskPath.CGPath;
            cell.backgroundView.layer.mask = maskLayer;
            
        }
        
    }
    
}

#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[AMUserSubscriptionsViewController class]]) {
        
        AMUserSubscriptionsViewController* subController = segue.destinationViewController;
        NSDictionary* infoSegue = (NSDictionary*)sender;
        long userID = [[infoSegue objectForKey:@"userID"] longValue];
        subController.requestType = [[infoSegue objectForKey:@"AMRequestType"] intValue];
        subController.userID = userID;
        
    } else if ([segue.destinationViewController isKindOfClass:[AMUserWallViewController class]]) {
        
        AMUserWallViewController* wallController = segue.destinationViewController;
        wallController.userID = [sender longValue];
        
    }
    

    
}

@end
