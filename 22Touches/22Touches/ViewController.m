//
//  ViewController.m
//  22Touches
//
//  Created by Admin on 20.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"

const NSInteger countCellToRow = 8;
const CGFloat sizeCheckerRelativeToCell = 0.7;

@interface ViewController ()

@property (weak, nonatomic) UIView* board;
@property (weak, nonatomic) UIView* draggingChecker;
@property (strong, nonatomic) NSMutableSet* freeCells;
@property (strong, nonatomic) NSMutableArray* checkers;
@property (assign, nonatomic) CGPoint touchOffset;
@property (assign, nonatomic) CGPoint previosPositionDraggedChecker;

@end

@implementation ViewController

#pragma mark - Drawing

- (NSMutableArray*) fillBoard:(CGRect)board withFillingFreeCells:(NSMutableSet*)freeCells withFillingCheckers:(NSMutableArray*)checkers {
    
    CGFloat sideCell = CGRectGetWidth(board) / countCellToRow;
    
    NSMutableArray* array = [NSMutableArray array];
    
    CGRect cellRect = CGRectMake(0, 0, sideCell, sideCell);
    
    for (NSInteger i = 0; i < 8; i ++) {
        for (NSInteger j = 0; j < 4; j++) {
            if (i % 2) {
                cellRect.origin.x = j * 2 * sideCell;
            } else {
                cellRect.origin.x = (j * 2  + 1) * sideCell;
            }
            cellRect.origin.y = i * sideCell;
            
            UIView* cell = [[UIView alloc] initWithFrame:cellRect];
            cell.backgroundColor = [UIColor blackColor];
            
            [array addObject:cell];
            
            CGFloat sideChecker = sideCell * sizeCheckerRelativeToCell;
            
            if (i < 3) {
                UIView* checkerWhite = [[UIView alloc] initWithFrame:CGRectMake(cellRect.origin.x + sideCell * 0.5 * (1 - sizeCheckerRelativeToCell),
                                                                                cellRect.origin.y + sideCell * 0.5 * (1 - sizeCheckerRelativeToCell),
                                                                                sideChecker, sideChecker)];
                checkerWhite.backgroundColor = [UIColor whiteColor];
                checkerWhite.layer.cornerRadius = sideChecker * 0.5f;
                [array addObject:checkerWhite];
                [checkers addObject:checkerWhite];
            } else if (i > 4) {
                UIView* checkerRed = [[UIView alloc] initWithFrame:CGRectMake(cellRect.origin.x + sideCell * 0.5 * (1 - sizeCheckerRelativeToCell),
                                                                              cellRect.origin.y + sideCell * 0.5 * (1 - sizeCheckerRelativeToCell),
                                                                              sideChecker, sideChecker)];
                checkerRed.backgroundColor = [UIColor redColor];
                checkerRed.layer.cornerRadius = sideChecker * 0.5f;
                [array addObject:checkerRed];
                [checkers addObject:checkerRed];
            } else {
                [freeCells addObject:[NSValue valueWithCGPoint:cell.center]];
            }
        }
    }
    return array;
    
}

#pragma mark - Events

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat minSide = MIN(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    
    UIView* boardView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - minSide / 2.0f,
                                                                 self.view.center.y - minSide / 2.0f,
                                                                 minSide, minSide)];
    boardView.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.8];
    boardView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.board = boardView;
    
    [self.view addSubview:boardView];
    
    self.freeCells = [[NSMutableSet alloc] init];
    self.checkers = [[NSMutableArray alloc] init];
    
    NSMutableArray* array = [self fillBoard:self.board.bounds withFillingFreeCells:self.freeCells withFillingCheckers:self.checkers];
    
    for (UIView* cell in array) {
        [self.board addSubview:cell];
    }

}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Additional functions

- (BOOL) isCheckerView:(UIView*)currentView {
    
    for (UIView* view in self.checkers) {
        if ([view isEqual:currentView]) {
            return YES;
        }
    }
    
    return NO;
}

- (void) breakAnimationChecker:(UIView*)checker {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         checker.transform = CGAffineTransformIdentity;
                         checker.alpha = 1.f;
                     }];
}

- (void) moveChecker:(UIView*)checker onPosition:(CGPoint)position{
    checker.center = position;
}

- (CGPoint) findFreeCellFor:(CGPoint)pointChecker {
    
    CGFloat minLength = CGRectGetWidth(self.board.bounds) * 2;
    CGPoint nearestPoint = CGPointZero;
    
    NSArray* arrayPoint = [self.freeCells allObjects];
    
    for (NSInteger i = 0; i < [arrayPoint count]; i ++) {
        
        CGPoint point = [[arrayPoint objectAtIndex:i] CGPointValue];
        CGFloat dx = fabsf(point.x - pointChecker.x);
        CGFloat dy = fabsf(point.y - pointChecker.y);
        
        CGFloat length = sqrtf(powf(dx, 2) + powf(dy, 2));
        
        if (length < minLength) {
            minLength = length;
            nearestPoint = point;
        }
   
    }
    return nearestPoint;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.board];
    UIView* view = [self.board hitTest:point withEvent:event];
    if ([self isCheckerView:view]) {
        self.previosPositionDraggedChecker = view.center;
        self.draggingChecker = view;
        self.touchOffset = CGPointMake(CGRectGetMidX(self.draggingChecker.frame) - point.x, CGRectGetMidY(self.draggingChecker.frame) - point.y);
        [self.draggingChecker.layer removeAllAnimations];
        [self.board bringSubviewToFront:self.draggingChecker];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.draggingChecker.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                             self.draggingChecker.alpha = 0.6f;
                         }];
    } else {
        
        self.draggingChecker = nil;
        self.previosPositionDraggedChecker = CGPointZero;
        
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    if (self.draggingChecker) {
        
        UITouch* touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.board];
        if ([self.board pointInside:point withEvent:event]) {
            
            self.draggingChecker.center = CGPointMake(point.x + self.touchOffset.x, point.y + self.touchOffset.y);
            
        } else {
            
            [self breakAnimationChecker:self.draggingChecker];
            [self moveChecker:self.draggingChecker onPosition:self.previosPositionDraggedChecker];
            self.draggingChecker = nil;
            self.previosPositionDraggedChecker = CGPointZero;
            
        }
        
    }
  
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    if (self.draggingChecker) {
        
        [self breakAnimationChecker:self.draggingChecker];

        [self.freeCells addObject:[NSValue valueWithCGPoint:self.previosPositionDraggedChecker]];
        
        CGPoint pointNearestFreeCell = [self findFreeCellFor:CGPointMake(self.draggingChecker.center.x + self.touchOffset.x,
                                                                         self.draggingChecker.center.y + self.touchOffset.y)];
        
        [self moveChecker:self.draggingChecker onPosition:pointNearestFreeCell];
        
        [self.freeCells removeObject:[NSValue valueWithCGPoint:pointNearestFreeCell]];
        
        self.draggingChecker = nil;
        self.previosPositionDraggedChecker = CGPointZero;
        
    }
  
}

- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    if (self.draggingChecker) {
        
        [self breakAnimationChecker:self.draggingChecker];
        [self moveChecker:self.draggingChecker onPosition:self.previosPositionDraggedChecker];
        self.draggingChecker = nil;
        self.previosPositionDraggedChecker = CGPointZero;
        
    }

    
}

@end
