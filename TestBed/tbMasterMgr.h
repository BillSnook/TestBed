//
//  tbMasterMgr.h
//  TestBed
//
//  Created by Bill Snook on 9/2/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface tbMasterMgr : NSObject <UISplitViewControllerDelegate>


-(id)initWithSplitViewController:(UISplitViewController*)splitViewController withDetailRootControllers:(NSArray*)detailControllers;

-(void)changeDetailsToIndex: (int)index;


@end
