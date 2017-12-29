//
//  ViewController.m
//  21Animation
//
//  Created by Admin on 18.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray* arrayRect;
@property (strong, nonatomic) NSMutableArray* arrayAngleRect;
@property (strong, nonatomic) UIImageView* girlView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    CGFloat part1_10 = CGRectGetWidth(self.view.bounds) / 10;
    
    self.arrayAngleRect = [NSMutableArray array];
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, part1_10, part1_10)];
    view1.backgroundColor = [UIColor redColor];
    
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 2 *part1_10, part1_10, part1_10)];
    view2.backgroundColor = [UIColor blueColor];
  
    UIView* view3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - part1_10, 0, part1_10, part1_10)];
    view3.backgroundColor = [UIColor yellowColor];
    
    UIView* view4 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 2 * part1_10, CGRectGetHeight(self.view.bounds) - 2 * part1_10, part1_10, part1_10)];
    view4.backgroundColor = [UIColor greenColor];
    
    [self.arrayAngleRect addObject:view1];
    [self.arrayAngleRect addObject:view3];
    [self.arrayAngleRect addObject:view4];
    [self.arrayAngleRect addObject:view2];
    
    for (UIView* view in self.arrayAngleRect) {
        [self.view addSubview:view];
    }
    
    NSInteger countViewRect = 16;
    CGFloat stepY = (CGRectGetHeight(self.view.bounds) - 3 * part1_10) / countViewRect;
    CGFloat x = part1_10;
    CGFloat y = part1_10;
    
    self.arrayRect = [NSMutableArray array];
    
    for (NSInteger i = 0; i < countViewRect; i++) {
        UIView* viewRect = [[UIView alloc] initWithFrame:CGRectMake(x, y, stepY / 2, stepY)];
        viewRect.backgroundColor = [self randomColor];
        
        [self.arrayRect addObject:viewRect];
        [self.view addSubview:viewRect];
        
        y += stepY;
    }
    
    NSArray* imageGirl = [NSArray arrayWithObjects:[UIImage imageNamed:@"Girl1.png"],
                                              [UIImage imageNamed:@"Girl2.png"],
                                              [UIImage imageNamed:@"Girl3.png"],
                                              [UIImage imageNamed:@"Girl4.png"], nil];
    
    
    self.girlView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - part1_10, part1_10, part1_10)];
    self.girlView.animationImages = imageGirl;
    self.girlView.animationDuration = 0.3f;
    
    [self.view addSubview:self.girlView];
    
}

- (UIColor*) randomColor {
    
    return [UIColor colorWithRed:(float)(arc4random() % 256) / 255.f
                           green:(float)(arc4random() % 256) / 255.f
                            blue:(float)(arc4random() % 256) / 255.f
                           alpha:1.f];
    
}

-(void) moveView:(UIView*)view withOptions:(UIViewAnimationOptions)options {

    [UIView animateWithDuration:3
                          delay:0
                        options:options
                     animations:^{
                         [view setFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - CGRectGetWidth(view.bounds) - view.frame.origin.x, CGRectGetMinY(view.frame), CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))];
                         view.backgroundColor = [self randomColor];
                         view.transform = CGAffineTransformMakeRotation(M_PI);
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

- (void) moveViews:(NSMutableArray*)arrayViews withClockwiseDirection:(BOOL)clockwiseDirection {
    
    [UIView animateWithDuration:3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if (clockwiseDirection) {
                             UIView* firstView = [arrayViews firstObject];
                             CGRect firstFrame = firstView.frame;
                             UIColor* firstColor = firstView.backgroundColor;
                             
                             for (NSInteger i = 0; i < [arrayViews count]; i++) {
                                 NSInteger j = i + 1;
                                 if (j < [arrayViews count]) {
                                     UIView* view1 = [arrayViews objectAtIndex:i];
                                     UIView* view2 = [arrayViews objectAtIndex:j];
                                     [view1 setFrame:view2.frame];
                                     view1.backgroundColor = view2.backgroundColor;
                                 } else {
                                        UIView* view1 = [arrayViews objectAtIndex:i];
                                     [view1 setFrame:firstFrame];
                                     view1.backgroundColor = firstColor;
                                 }
                             }
                         } else {
                             UIView* lastView = [arrayViews lastObject];
                             CGRect lastFrame = lastView.frame;
                             UIColor* lastColor = lastView.backgroundColor;
                             
                             for (NSInteger i = [arrayViews count] - 1; i >= 0 ; i--) {
                                 NSInteger j = i - 1;
                                 if (j >= 0) {
                                     UIView* view1 = [arrayViews objectAtIndex:i];
                                     UIView* view2 = [arrayViews objectAtIndex:j];
                                     [view1 setFrame:view2.frame];
                                     view1.backgroundColor = view2.backgroundColor;
                                 } else {
                                     UIView* view1 = [arrayViews objectAtIndex:i];
                                     [view1 setFrame:lastFrame];
                                     view1.backgroundColor = lastColor;
                                 }
                             }
                         }
                     }
                     completion:^(BOOL finished){
                         [self moveViews:arrayViews withClockwiseDirection:arc4random() % 2];
                     }];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    for (NSInteger i = 0; i < [self.arrayRect count]; i++) {
        UIView* view = [self.arrayRect objectAtIndex:i];
        if (i % 4 == 0) {
            [self moveView:view withOptions:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat];
             } else if (i % 4 == 1) {
                        [self moveView:view withOptions:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat];
                        } else if (i % 4 == 2) {
                                    [self moveView:view withOptions:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat];
                                    } else {
                                            [self moveView:view withOptions:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat];
                                    }
    }
    
    //------------------------------------------------------

    [UIView animateWithDuration:3
                          delay:0
                        options:UIViewAnimationOptionRepeat
                     animations:^{
                         [self.girlView setFrame:CGRectMake(CGRectGetWidth(self.view.bounds), self.girlView.frame.origin.y, CGRectGetWidth(self.girlView.bounds), CGRectGetWidth(self.girlView.bounds))];
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [self.girlView startAnimating];
    
    [self moveViews:self.arrayAngleRect withClockwiseDirection:arc4random() % 2];
  
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
