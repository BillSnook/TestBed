//
//  tbMasterVC.h
//  TestBed
//
//  Created by Bill Snook on 8/25/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tbDetailVC;

@interface tbMasterVC : UITableViewController

@property (strong, nonatomic) tbDetailVC *detailViewController;

@end
