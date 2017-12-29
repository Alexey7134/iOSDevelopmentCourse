//
//  ViewController.m
//  17ViewController
//
//  Created by Admin on 08.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray* arrayColors;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayColors = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor redColor], [UIColor blackColor],
                            [UIColor grayColor], [UIColor darkGrayColor], [UIColor lightGrayColor],
                            [UIColor magentaColor], [UIColor greenColor], [UIColor yellowColor],
                            [UIColor purpleColor], [UIColor blueColor], [UIColor brownColor],
                            [UIColor clearColor], [UIColor orangeColor], nil];
    NSInteger randomColor = arc4random() % [self.arrayColors count];
    self.view.backgroundColor = [self.arrayColors objectAtIndex:randomColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSInteger randomColor = arc4random() % [self.arrayColors count];
    self.view.backgroundColor = [self.arrayColors objectAtIndex:randomColor];
}

@end
