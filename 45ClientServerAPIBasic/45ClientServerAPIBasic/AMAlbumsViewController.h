//
//  AMAlbumsViewController.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 25.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMAlbumsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (assign, nonatomic) long ownerID;
@property (assign, nonatomic) BOOL isVideoAlbums;

@end
