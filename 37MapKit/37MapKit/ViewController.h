//
//  ViewController.h
//  37MapKit
//
//  Created by Admin on 26.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *countStudentsOnCloseDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countStudentsOnMiddleDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countStudentsOnFarDistanceLabel;

- (IBAction)actionValueChangedStyleMapSegmentedControl:(UISegmentedControl *)sender;

@end

