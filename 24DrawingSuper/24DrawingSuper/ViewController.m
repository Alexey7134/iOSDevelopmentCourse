//
//  ViewController.m
//  24DrawingSuper
//
//  Created by Admin on 27.09.17.
//  Copyright © 2017 AMiksiuk. All rights reserved.
//

#import "ViewController.h"
#import "AMDrawingView.h"
#import "AMDrawingPoint.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.redSlider.value = (float)(arc4random() % 256) / 255;
    self.greenSlider.value = (float)(arc4random() % 256) / 255;
    self.blueSlider.value = (float)(arc4random() % 256) / 255;
    self.brushView.layer.cornerRadius = 0.5f * CGRectGetWidth(self.brushView.bounds);
    [self setColorOfDrawing];
    self.sizeBrushSlider.value = 0.5f;
    
    NSMutableArray* points = [[NSMutableArray alloc] init];
    self.drawingView.drawnPoints = points;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPan:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.drawingView addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPan:)];
    [self.drawingView addGestureRecognizer:panGesture];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Functions


- (void) setColorOfDrawing {
    
    self.brushView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1.f];
    
}

- (AMDrawingPoint*) createDrawnPoint:(CGPoint)point withColor:(UIColor*)color withWidth:(CGFloat)width {
    
    AMDrawingPoint* drawnPoint = [[AMDrawingPoint alloc] initWithCoordinate:point];
    drawnPoint.color = color;
    drawnPoint.width = width;
    return drawnPoint;
    
}

- (void) addDrawnPoint:(AMDrawingPoint*)drawnPoint {
    
    for (NSInteger i = 0; i < [self.drawingView.drawnPoints count]; i++) {
        AMDrawingPoint* currentPoint = [self.drawingView.drawnPoints objectAtIndex:i];
        if (CGPointEqualToPoint(currentPoint.coordinate, drawnPoint.coordinate)) {
            currentPoint.color = drawnPoint.color;
            currentPoint.width = drawnPoint.width;
            return;
        }
    }
    [self.drawingView.drawnPoints addObject:drawnPoint];
    [self.drawingView setNeedsDisplay];
    
}

- (void) clearDrawnPoint {
    
    [self.drawingView.drawnPoints removeAllObjects];
    [self.drawingView setNeedsDisplay];
    
}

#pragma mark Gesture

- (void) handleTapPan:(UIGestureRecognizer*) gesture {
    
    CGPoint point = [gesture locationInView:self.drawingView];
    CGFloat offset = CGRectGetWidth(self.brushView.bounds) * self.sizeBrushSlider.value / 2;
    [self addDrawnPoint:[self createDrawnPoint:CGPointMake(point.x - offset, point.y - offset) withColor:self.brushView.backgroundColor withWidth:CGRectGetWidth(self.brushView.bounds) * self.sizeBrushSlider.value]];
    
}

#pragma mark Actions

- (IBAction)actionRedSlider:(id)sender {
    
    [self setColorOfDrawing];
    
}

- (IBAction)actionGreenSlider:(id)sender {
    
    [self setColorOfDrawing];
    
}

- (IBAction)actionBlueSlider:(id)sender {
    
    [self setColorOfDrawing];
    
}
- (IBAction)actionSizeBrushSlider:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.brushView.transform = CGAffineTransformMakeScale(self.sizeBrushSlider.value + 0.5f, self.sizeBrushSlider.value + 0.5f);
    }];
    
}
- (IBAction)actionClearButton:(id)sender {
    
    [self clearDrawnPoint];
    
}

@end
