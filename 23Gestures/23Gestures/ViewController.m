//
//  ViewController.m
//  23Gestures
//
//  Created by Admin on 22.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) UIImageView* stars;
@property (assign, nonatomic) BOOL isRotated;
@property (assign, nonatomic) BOOL breakRotation;
@property (assign, nonatomic) CGFloat rotationStars;
@property (assign, nonatomic) CGFloat scaleStars;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSMutableArray* imageArray= [[NSMutableArray alloc] init];
    
    for (NSInteger i = 1; i < 9; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Star%d.png",i]]];
    }

    UIImageView* imageStars = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 50,
                                                                           CGRectGetMidY(self.view.bounds) - 50, 100, 100)];
    
    imageStars.animationImages = imageArray;
    imageStars.animationDuration = 3;
    [self.view addSubview:imageStars];
    self.stars = imageStars;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];

    UISwipeGestureRecognizer* leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer* rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
    
    UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer* rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [self.view addGestureRecognizer:rotateGesture];
    
    self.isRotated = NO;
    self.breakRotation = NO;
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.stars startAnimating];
    
}

#pragma mark - Additional Function

- (void)rotateView:(UIView*)view withAngle:(CGFloat)angle withClockwiseDirection:(BOOL)clockwiseDirection {

    NSInteger direction = clockwiseDirection ? 1 : -1;
    CGFloat stepRotation = M_PI_4 / 4;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGAffineTransform currentTransform = view.transform;
        view.transform = CGAffineTransformRotate(currentTransform, direction * stepRotation);
        self.rotationStars = self.rotationStars + direction * stepRotation;
        
    } completion:^(BOOL finished) {
        
        if (self.isRotated && angle > stepRotation) {
            __weak UIView* weakView = view;
            [self rotateView:weakView withAngle:angle - stepRotation withClockwiseDirection:clockwiseDirection];
        } else {
            if (!self.breakRotation) {
                self.isRotated = !self.isRotated;
            } else {
                self.breakRotation = !self.breakRotation;
            }
        }
        
    }];

}

#pragma mark - Gesture

- (void) handleTap:(UITapGestureRecognizer*)tapGesture {

    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.stars.center = [tapGesture locationInView:self.view];
    } completion:^(BOOL finished) { }];
    
}

- (void) handleDoubleTap:(UITapGestureRecognizer*)doubleTapGesture {
    
    self.breakRotation = YES;
    self.isRotated = NO;
    
}

- (void) handleLeftSwipe:(UISwipeGestureRecognizer*)leftSwipeGesture {

    self.isRotated = !self.isRotated;
    [self rotateView:self.stars withAngle:2 * M_PI withClockwiseDirection:NO];
    
}

- (void) handleRightSwipe:(UISwipeGestureRecognizer*)rightSwipeGesture {

    self.isRotated = !self.isRotated;
    [self rotateView:self.stars withAngle:2 * M_PI withClockwiseDirection:YES];

}

- (void) handlePinch:(UIPinchGestureRecognizer*)pinchGesture {

    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.scaleStars = pinchGesture.scale;
    }
    
    CGFloat delta = pinchGesture.scale - self.scaleStars;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGAffineTransform currentTransform = self.stars.transform;
        self.stars.transform = CGAffineTransformScale(currentTransform, 1 + delta, 1 + delta);
    } completion:^(BOOL finished) {
        
    }];
    
    self.scaleStars = pinchGesture.scale;
    
}

- (void) handleRotate:(UIRotationGestureRecognizer*)rotationGesture {
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan) {
        self.rotationStars = rotationGesture.rotation;
    }
    
    CGFloat delta = rotationGesture.rotation - self.rotationStars;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGAffineTransform currentTransform = self.stars.transform;
        self.stars.transform = CGAffineTransformRotate(currentTransform, delta);
    } completion:^(BOOL finished) {
        
    }];
    
    self.rotationStars = rotationGesture.rotation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
