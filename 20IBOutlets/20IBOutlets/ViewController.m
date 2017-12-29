//
//  ViewController.m
//  20IBOutlets
//
//  Created by Admin on 13.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *board;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray* arrayBlackCells;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray* checkers;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
    
}

- (UITraitCollection*) overrideTraitCollectionForChildViewController:(UIViewController *)childViewController {
    
    if (self.view.bounds.size.width > self.view.bounds.size.height) {
        return [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassCompact];
    } else {
        return self.view.traitCollection;
    }
    
}


- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    //[self setOverrideTraitCollection:[self overrideTraitCollectionForChildViewController:self] forChildViewController:self];
    
    UIColor* randomColor = [UIColor colorWithRed:(CGFloat) (arc4random() % 256) / 255 green:(CGFloat) (arc4random() % 256) / 255 blue:(CGFloat) (arc4random() % 256) / 255 alpha:1.f];
    
    for (UIView* cell in self.arrayBlackCells) {
        cell.backgroundColor = randomColor;
    }
    
    
    NSInteger randomCountChange = arc4random() % ([self.checkers count] / 2) + 1;
    
    for (NSInteger i = 0; i < randomCountChange; i++) {
        UIView* firstChecker = [self.checkers objectAtIndex:arc4random() % [self.checkers count]];
        UIView* secondChecker = [self.checkers objectAtIndex:arc4random() % [self.checkers count]];
        
        UIColor* colorFirstChecker = firstChecker.backgroundColor;
        firstChecker.backgroundColor = secondChecker.backgroundColor;
        secondChecker.backgroundColor = colorFirstChecker;
        
    }

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
