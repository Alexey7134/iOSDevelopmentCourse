//
//  AMStudent.h
//  35UITableViewSearch
//
//  Created by Admin on 17.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MKAnnotation.h>

typedef NS_ENUM(NSInteger, AMGenderType) {
    AMGenderTypeMan,
    AMGenderTypeWoman
} ;

@interface AMStudent : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) AMGenderType gender;
@property (strong, nonatomic) NSDate* dateOfBirth;

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

+ (AMStudent*) randomStudent;

@end
