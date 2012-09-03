//
//  tbAppDelegate.h
//  TestBed
//
//  Created by Bill Snook on 8/25/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//


#import <UIKit/UIKit.h>


@class tbMasterMgr;


@interface tbAppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic)		UIWindow		*window;

@property (strong,nonatomic)			tbMasterMgr		*masterManager;



+ (NSString *)orientString: (UIInterfaceOrientation)interfaceOrientation;


@end
