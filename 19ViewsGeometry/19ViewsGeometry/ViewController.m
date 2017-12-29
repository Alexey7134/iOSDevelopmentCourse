//
//  ViewController.m
//  19ViewsGeometry
//
//  Created by Admin on 10.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"

const NSInteger countCellToRow = 8;
const CGFloat sizeCheckerRelativeToCell = 0.7;

@interface ViewController ()

@property (weak, nonatomic) UIView* board;
@property (strong, nonatomic) UIColor* colorCell;

@end

@implementation ViewController

#pragma mark - HelpFunction

- (NSMutableArray*) fillBoard:(CGRect)board colorCell:(UIColor*)colorCell {

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
            cell.backgroundColor = colorCell;
            
            [array addObject:cell];
            
            CGFloat sideChecker = sideCell * sizeCheckerRelativeToCell;

            if (i < 3) {
                UIView* checkerWhite = [[UIView alloc] initWithFrame:CGRectMake(cellRect.origin.x + sideCell * 0.5 * (1 - sizeCheckerRelativeToCell),
                                                                               cellRect.origin.y + sideCell * 0.5 * (1 - sizeCheckerRelativeToCell),
                                                                               sideChecker, sideChecker)];
                checkerWhite.backgroundColor = [UIColor whiteColor];
                [array addObject:checkerWhite];
            } else if (i > 4) {
                UIView* checkerRed = [[UIView alloc] initWithFrame:CGRectMake(cellRect.origin.x + sideCell * 0.5 * (1 - sizeCheckerRelativeToCell),
                                                                                cellRect.origin.y + sideCell * 0.5 * (1 - sizeCheckerRelativeToCell),
                                                                                sideChecker, sideChecker)];
                checkerRed.backgroundColor = [UIColor redColor];
                [array addObject:checkerRed];
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
    
    self.colorCell = [UIColor blackColor];
    
    NSMutableArray* array = [self fillBoard:self.board.bounds colorCell:[UIColor blackColor]];
    for (UIView* cell in array) {
        [self.board addSubview:cell];
    }
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    NSArray* arrayColor = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor blueColor],
                           [UIColor magentaColor], [UIColor yellowColor], [UIColor grayColor],
                           [UIColor brownColor], [UIColor orangeColor], [UIColor purpleColor], nil];
    
    UIColor* randomColor = [arrayColor objectAtIndex:arc4random() % [arrayColor count]];
    
    for (UIView* cell in self.board.subviews) {
        if (cell.backgroundColor == self.colorCell) {
            cell.backgroundColor = randomColor;
        }
    }
    self.colorCell = randomColor;
    
    NSMutableArray* arrayCheckers = [[NSMutableArray alloc] init];
    
    for (UIView* subview in self.board.subviews) {
        if (subview.backgroundColor != self.colorCell) {
            [arrayCheckers addObject:subview];
        }
    }
    
    NSInteger randomCountChange = arc4random() % ([arrayCheckers count] / 2) + 1;
    
    for (NSInteger i = 0; i < randomCountChange; i++) {
        UIView* firstChecker = [arrayCheckers objectAtIndex:arc4random() % [arrayCheckers count]];
        UIView* secondChecker = [arrayCheckers objectAtIndex:arc4random() % [arrayCheckers count]];
        
        [UIView animateWithDuration:1 animations:^{
            
            CGRect tempRect = firstChecker.frame;
            [firstChecker setFrame:secondChecker.frame];
            [secondChecker setFrame:tempRect];
            
            [self.board bringSubviewToFront:firstChecker];
            [self.board bringSubviewToFront:secondChecker];
            
        }];
        
        /*
        CGRect tempRect = firstChecker.frame;
        [firstChecker setFrame:secondChecker.frame];
        [secondChecker setFrame:tempRect];
        [self.board bringSubviewToFront:firstChecker];
        [self.board bringSubviewToFront:secondChecker];
        
        */
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
