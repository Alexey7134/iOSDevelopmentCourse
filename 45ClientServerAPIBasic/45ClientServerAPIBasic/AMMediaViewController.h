//
//  AMMediaViewController.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 26.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMMediaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView* collectionView;

@property (assign, nonatomic) BOOL isVideo;
@property (assign, nonatomic) long ownerID;
@property (assign, nonatomic) long albumID;

@end
