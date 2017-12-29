//
//  ViewController.m
//  37MapKit
//
//  Created by Admin on 26.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "AMStudent.h"
#import "UIView+MKAnnotationView.h"
#import "AMInfoTableViewController.h"
#import "AMMeetingPlace.h"

typedef NS_ENUM(NSInteger, AMDistanceMettingPlace) {
    AMDistanceMettingPlaceClose = 1000,
    AMDistanceMettingPlaceMiddle = 2000,
    AMDistanceMettingPlaceFar = 3000
};

typedef NS_ENUM(NSInteger, AMProbabilityMetting) {
    AMProbabilityMettingImpossible = 5,
    AMProbabilityMettingLow = 20,
    AMProbabilityMettingMiddle = 50,
    AMProbabilityMettingHigh = 90
};

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIPopoverPresentationControllerDelegate>

@property (assign, nonatomic) CLLocationCoordinate2D coordinateCity;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) NSArray* students;

@property (strong, nonatomic) AMMeetingPlace* meetingPlace;
@property (strong, nonatomic) NSArray* meetingPlaceCircle;
@property (strong, nonatomic) UIColor* colorForCirclesMeeting;

@property (strong, nonatomic) NSArray* studentOnCloseDistance;
@property (strong, nonatomic) NSArray* studentOnMiddleDistance;
@property (strong, nonatomic) NSArray* studentOnFarDistance;

@property (strong, nonatomic) NSArray* annotation;
@property (strong, nonatomic) AMInfoTableViewController* infoTableViewController;

@property (strong, nonatomic) NSMutableArray* calculatingDirections;

@end

@implementation ViewController


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.coordinateCity = CLLocationCoordinate2DMake(52.03, 29.21);
    
    self.mapView.showsUserLocation = YES;
    self.mapView.region = MKCoordinateRegionMakeWithDistance(self.coordinateCity, 5000, 5000);
    [self.view sendSubviewToBack:self.mapView];
    
    [self generateStudents];
    self.meetingPlace = [[AMMeetingPlace alloc] initWithCoordinate:[self generateRandomCoordinate]];
    self.meetingPlace.title = @"Meeting place";
    self.meetingPlace.subtitle = @"GO";
    
    self.colorForCirclesMeeting = [UIColor brownColor];
    
    self.countStudentsOnFarDistanceLabel.backgroundColor = [self.colorForCirclesMeeting colorWithAlphaComponent:0.6f];
    self.countStudentsOnMiddleDistanceLabel.backgroundColor = [self.colorForCirclesMeeting colorWithAlphaComponent:0.4f];
    self.countStudentsOnCloseDistanceLabel.backgroundColor = [self.colorForCirclesMeeting colorWithAlphaComponent:0.2f];
    
    self.calculatingDirections = [NSMutableArray array];
    
    UIBarButtonItem* goMeetingBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionGoMeetingBarButtonItem:)];
    
    self.navigationItem.rightBarButtonItem = goMeetingBarButtonItem;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

}

#pragma mark - Methods

- (void) cancelCalculatingDirections {
    
    for (MKDirections* directions in self.calculatingDirections) {
        [directions cancel];
    }
    [self.calculatingDirections removeAllObjects];
    
}

- (void) showDirectionOfMovementForStudent:(AMStudent*)student {
    
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
    
    MKPlacemark* placemarkStudent = [[MKPlacemark alloc] initWithCoordinate:student.coordinate addressDictionary:nil];
    MKMapItem* mapItemStudent = [[MKMapItem alloc] initWithPlacemark:placemarkStudent];

    MKPlacemark* placemarkMeeting = [[MKPlacemark alloc] initWithCoordinate:self.meetingPlace.coordinate addressDictionary:nil];
    MKMapItem* mapItemMeeting = [[MKMapItem alloc] initWithPlacemark:placemarkMeeting];
    
    request.source = mapItemStudent;
    request.destination = mapItemMeeting;
    
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections* directions = [[MKDirections alloc] initWithRequest:request];
    
    [self.calculatingDirections addObject:directions];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            
        } else {
            
            NSMutableArray* routes = [NSMutableArray array];
            
            for (MKRoute* route in response.routes) {
                [routes addObject:route.polyline];
            }
            [self.mapView addOverlays:routes level:MKOverlayLevelAboveRoads];
            [self.mapView setNeedsDisplay];
        }
    }];
    
}

- (void) calculateStudentsForMeetingPlace {

    NSMutableArray* studentOnCloseDistance = [NSMutableArray array];
    NSMutableArray* studentOnMiddleDistance = [NSMutableArray array];
    NSMutableArray* studentOnFarDistance = [NSMutableArray array];
    
    MKMapPoint pointMeeting = MKMapPointForCoordinate(self.meetingPlace.coordinate);
    
    for (AMStudent* student in self.students) {
        MKMapPoint point = MKMapPointForCoordinate(student.coordinate);
        
        double distance = MKMetersBetweenMapPoints(point, pointMeeting);
        
        if (distance <= AMDistanceMettingPlaceClose) {
            [studentOnCloseDistance addObject:student];
        } else if (distance <= AMDistanceMettingPlaceMiddle) {
            [studentOnMiddleDistance addObject:student];
        } else if (distance <= AMDistanceMettingPlaceFar){
            [studentOnFarDistance addObject:student];
        }
        
    }

    self.countStudentsOnCloseDistanceLabel.text = [NSString stringWithFormat:@"close distance - %d", [studentOnCloseDistance count]];
    self.countStudentsOnMiddleDistanceLabel.text = [NSString stringWithFormat:@"middle distance - %d", [studentOnMiddleDistance count]];
    self.countStudentsOnFarDistanceLabel.text = [NSString stringWithFormat:@"far distance - %d", [studentOnFarDistance count]];
    
    self.studentOnCloseDistance = studentOnCloseDistance;
    self.studentOnMiddleDistance = studentOnMiddleDistance;
    self.studentOnFarDistance = studentOnFarDistance;
    
    [self.mapView setNeedsDisplay];
    
}

- (void) createCircleOverlaysForCoordinate:(CLLocationCoordinate2D)coordinate {
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    MKCircle* smallCircle = [MKCircle circleWithCenterCoordinate:coordinate radius:AMDistanceMettingPlaceClose];
    MKCircle* mediumCircle = [MKCircle circleWithCenterCoordinate:coordinate radius:AMDistanceMettingPlaceMiddle];
    MKCircle* largeCircle = [MKCircle circleWithCenterCoordinate:coordinate radius:AMDistanceMettingPlaceFar];
    
    [self.mapView addOverlays:[NSArray arrayWithObjects:smallCircle, mediumCircle, largeCircle, nil]];
    
}

- (CLLocationCoordinate2D) generateRandomCoordinate {
    
    NSInteger directionLatitude = arc4random() % 2 ? 1 : -1;
    double deltaLatitude = (double)(arc4random() % 100) / 3000.f;
    double newLatitude = self.coordinateCity.latitude + directionLatitude * deltaLatitude;
    
    NSInteger directionLongitude = arc4random() % 2 ? 1 : -1;
    double deltaLongitude = (double)(arc4random() % 100) / 2000.f;
    double newLongitude = self.coordinateCity.longitude + directionLongitude * deltaLongitude;
    
    return CLLocationCoordinate2DMake(newLatitude, newLongitude);
    
}

- (void) generateStudents {
    
    NSMutableArray* students = [NSMutableArray array];
    for (NSInteger i = 0; i < (arc4random() % 20) + 10; i++) {
        
        AMStudent* student = [AMStudent randomStudent];
        student.coordinate = [self generateRandomCoordinate];
        
        [students addObject:student];
        
    }
    
    self.students = students;
    
}

- (void) showAlertWithTitle:(NSString*)title andWithMessage:(NSString*)message {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okButton];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (UIPopoverPresentationController*) showPopoverFromController:(UIViewController*)viewController withAnchorBarButtonItem:(UIBarButtonItem*)barButtonItem orWithAnchorView:(UIView*)view {
    
    UIPopoverPresentationController* popoverController  = [viewController popoverPresentationController];
    popoverController.backgroundColor = [UIColor lightGrayColor];
    popoverController.delegate = self;
    
    if (barButtonItem != nil) {
        popoverController.barButtonItem = barButtonItem;
    } else if (view != nil) {
        popoverController.sourceView = self.view;
        popoverController.sourceRect = [view convertRect:view.bounds toView:self.view];
    }
    
    return popoverController;
}

#pragma mark - Actions

- (void) actionGoMeetingBarButtonItem:(UIBarButtonItem*)sender {
    
    if (self.calculatingDirections) {
        [self cancelCalculatingDirections];
    }
    
    for (id <MKOverlay> overlay in self.mapView.overlays) {
        if ([overlay isKindOfClass:[MKPolyline class]]) {
            [self.mapView removeOverlay:overlay];
        }
    }
    
    for (AMStudent* student in self.students) {
        if ([self.studentOnCloseDistance containsObject:student]) {
            
            NSInteger probability = (arc4random() % 1000 + 1) / 10;
            if (probability <= AMProbabilityMettingHigh) {
                [self showDirectionOfMovementForStudent:student];
            }
            
        } else if ([self.studentOnMiddleDistance containsObject:student]) {
            
            NSInteger probability = arc4random() % 1001 / 10;
            if (probability <= AMProbabilityMettingMiddle) {
                [self showDirectionOfMovementForStudent:student];
            }
            
        } else if ([self.studentOnFarDistance containsObject:student]) {
            
            NSInteger probability = arc4random() % 1001 / 10;
            if (probability <= AMProbabilityMettingLow) {
                [self showDirectionOfMovementForStudent:student];
            }
            
        } else {
            
            NSInteger probability = arc4random() % 1001 / 10;
            if (probability <= AMProbabilityMettingImpossible) {
                [self showDirectionOfMovementForStudent:student];
            }
            
        }
    }
    
}

- (IBAction) actionValueChangedStyleMapSegmentedControl:(UISegmentedControl *)sender {
    
    self.mapView.mapType = (MKMapType)sender.selectedSegmentIndex;
    
}

- (void) actionDoneBarButtonItem:(UIBarButtonItem*)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)actionInfoButtonAnnotation:(UIButton*)sender {
    
    MKAnnotationView* annotationView = [sender superAnnotationView];
    
    AMStudent* student = annotationView.annotation;
    
    self.infoTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMInfoTableViewController"];
    self.infoTableViewController.student = student;
    
    UINavigationController* infoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.infoTableViewController];
    infoNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    
    CGFloat minSide = MIN(CGRectGetWidth(self.mapView.bounds), CGRectGetHeight(self.mapView.bounds));
    infoNavigationController.preferredContentSize = CGSizeMake( minSide / 3,  minSide / 2);
    
    UIBarButtonItem* cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionDoneBarButtonItem:)];
    
    self.infoTableViewController.navigationItem.rightBarButtonItem = cancelBarButton;
    
    [self presentViewController:infoNavigationController animated:YES completion:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        [self showPopoverFromController:infoNavigationController withAnchorBarButtonItem:nil orWithAnchorView:sender];
        
    }
    
}

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    
    if (!self.annotation) {
        
        NSMutableArray* annotations = [NSMutableArray array];
        
        for (AMStudent* student in self.students) {
            
            [annotations addObject:student];
        }
        
        self.annotation = annotations;
        
        [annotations addObject:self.meetingPlace];
        
        [self.mapView addAnnotations:annotations];
        
    }
  
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[AMStudent class]]) {
        
        static NSString* identifierStudent = @"identifierStudent";
        AMStudent* student = (AMStudent*)annotation;
        
        MKAnnotationView* annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifierStudent];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifierStudent];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.canShowCallout = YES;
        
        if (student.gender == AMGenderTypeMan) {
            annotationView.image = [UIImage imageNamed:@"ManFace"];
        } else {
            annotationView.image = [UIImage imageNamed:@"WomanFace.png"];
        }
        
        UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [infoButton addTarget:self action:@selector(actionInfoButtonAnnotation:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = infoButton;
        
        return annotationView;
        
    } else if ([annotation isKindOfClass:[AMMeetingPlace class]]) {
        
        static NSString* identifierMeeting = @"identifierMeeting";
        AMMeetingPlace* meetingPlace = (AMMeetingPlace*)annotation;
        
        MKAnnotationView* annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifierMeeting];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifierMeeting];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.image = [UIImage imageNamed:@"Meeting.png"];
        annotationView.draggable = YES;

        [self createCircleOverlaysForCoordinate:meetingPlace.coordinate];
        [self calculateStudentsForMeetingPlace];
        
        return annotationView;
        
    } else {
        
        return nil;
        
    }
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    AMMeetingPlace* meetingPlace = view.annotation;
    
    if (newState == MKAnnotationViewDragStateEnding) {
        
        [self createCircleOverlaysForCoordinate:meetingPlace.coordinate];
        [self calculateStudentsForMeetingPlace];
        
        view.dragState = MKAnnotationViewDragStateNone;
        
    } else if (newState == MKAnnotationViewDragStateStarting) {
        
        if (self.calculatingDirections) {
            [self cancelCalculatingDirections];
        }
        view.dragState = MKAnnotationViewDragStateDragging;
        
    }
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircle* circle = (MKCircle*)overlay;
        
        MKCircleRenderer* circleRenderer = [[MKCircleRenderer alloc] initWithCircle:circle];
        if (circle.radius == AMDistanceMettingPlaceClose) {
            circleRenderer.fillColor = [self.colorForCirclesMeeting colorWithAlphaComponent:0.6f];
        } else if (circle.radius == AMDistanceMettingPlaceMiddle) {
            circleRenderer.fillColor = [self.colorForCirclesMeeting colorWithAlphaComponent:0.4f];
        } else {
            circleRenderer.fillColor = [self.colorForCirclesMeeting colorWithAlphaComponent:0.2f];
        }
        
        return circleRenderer;
    }
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolyline* polyline = (MKPolyline*)overlay;
        MKPolylineRenderer* polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
        polylineRenderer.strokeColor = [UIColor blueColor];
        polylineRenderer.lineWidth = 2;
        
        return polylineRenderer;
        
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    self.infoTableViewController = nil;
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    [self.locationManager stopUpdatingLocation];

}


@end
