//
//  tbDetailVC.h
//  TestBed
//
//  Created by Bill Snook on 8/25/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface tbDetailVC : UIViewController


@property (strong, nonatomic)				id			detailItem;

@property (weak, nonatomic)		IBOutlet	UILabel		*detailDescriptionLabel;


@end
