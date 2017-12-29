//
//  ViewController.m
//  26Controls
//
//  Created by Admin on 02.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"

const int AMSizeFontNormal = 30;
const int AMSizeFontLarge = 40;


@interface ViewController ()

@property (strong, nonatomic) NSMutableArray* arrayImages;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.arrayImages = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"Fairy%d.gif",i]];
        [self.arrayImages addObject:image];
    }

    int sizeFontLabel;
    
    if (CGRectGetHeight(self.view.bounds) < 2048) {
        sizeFontLabel = AMSizeFontNormal;
    } else {
        sizeFontLabel = AMSizeFontLarge;
    }
    
    UIFont* font = [UIFont fontWithName:@"Zapfino" size:sizeFontLabel];
    NSDictionary* attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    for (UILabel* label in self.allLabels) {
        [label setFont:font];
    }
    
    [self.imageSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.testImageView.image = [self.arrayImages objectAtIndex:0];
    
}

- (BOOL) isAnimatedView {
    
    return self.rotationSwitch.isOn || self.scaleSwitch.isOn || self.TranslationSwitch.isOn;
    
}

- (void) animateTestView {
    
    [UIView animateWithDuration:(1.f / self.speedSlider.value) delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGAffineTransform nextTransform = self.testImageView.transform;
 
        if (self.rotationSwitch.isOn) {
            
            NSInteger direction = arc4random() % 2 ? 1 : -1;
            nextTransform = CGAffineTransformConcat(nextTransform, CGAffineTransformMakeRotation(direction * M_PI_4));
            
        }
        if (self.scaleSwitch.isOn) {
            
            CGFloat newScale = arc4random() % 2 ? 1.1f : 0.9f;
            
            nextTransform = CGAffineTransformConcat(nextTransform, CGAffineTransformMakeScale(newScale, newScale));

        }
        if (self.TranslationSwitch.isOn) {
            
            CGPoint newCenter = CGPointMake(arc4random() % (int)(CGRectGetWidth(self.view.bounds) * 0.8f) + 0.1f * CGRectGetWidth(self.view.bounds),
                                            arc4random() % (int)(CGRectGetHeight(self.view.bounds) * 0.4f) + 0.1f * CGRectGetHeight(self.view.bounds));
            self.testImageView.center = newCenter;
            
        }
        self.testImageView.transform = nextTransform;

    } completion:^(BOOL finished) {
        
        if ([self isAnimatedView]) {
            
            [self animateTestView];
            
        }
        
    }];
    
}

#pragma mark - Actions

- (IBAction)actionValueChangedSwitch:(UISwitch *)sender {
    
    [self animateTestView];
    
}

- (IBAction)actionValueChangedImageSegmentedControl:(UISegmentedControl *)sender {
    
    self.testImageView.image = [self.arrayImages objectAtIndex:sender.selectedSegmentIndex];
    
}
@end
