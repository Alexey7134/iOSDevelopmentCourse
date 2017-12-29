//
//  AMInfoTableViewController.m
//  37MapKit
//
//  Created by Admin on 29.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMInfoTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AMStudent.h"

@interface AMInfoTableViewController ()

@property (strong, nonatomic) CLGeocoder* geoCoder;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;

@end

@implementation AMInfoTableViewController

#pragma mark - View lifecycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.geoCoder = [[CLGeocoder alloc] init];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"YYYY"];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.student.firstName, self.student.lastName];
    self.yearLabel.text = [self.dateFormatter stringFromDate:self.student.dateOfBirth];
    if (self.student.gender == AMGenderTypeMan) {
        self.genderLabel.text = @"man";
    } else {
        self.genderLabel.text = @"woman";
    }
    
    CLLocation* locationStudent = [[CLLocation alloc] initWithLatitude:self.student.coordinate.latitude longitude:self.student.coordinate.longitude];
    
    [self.geoCoder reverseGeocodeLocation:locationStudent completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            
        } else {
            
            if ([placemarks count] > 0) {

                CLPlacemark* placemark = [placemarks firstObject];
 
                NSMutableString* fullAddress = [NSMutableString string];
                
                [fullAddress appendFormat:@"%@, %@, %@ ", placemark.country, placemark.administrativeArea, placemark.subAdministrativeArea];
                
                if (placemark.thoroughfare) {
                    [fullAddress appendString:placemark.thoroughfare];
                }
                
                self.addressLabel.text = fullAddress;
                [self.tableView reloadData];
                
            }
            
        }
        
    }];

    
}

- (void) dealloc {
    
    if (self.geoCoder.isGeocoding) {
        
        [self.geoCoder cancelGeocode];
        
    }
}

@end
