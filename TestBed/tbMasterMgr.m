//
//  tbMasterMgr.m
//  TestBed
//
//  Created by Bill Snook on 9/2/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//


#import "tbMasterMgr.h"
#import "DLog.h"


@interface tbMasterMgr ()

@property (weak,nonatomic)UISplitViewController* splitViewController;
@property (strong,nonatomic)NSArray* detailControllers;
@property (weak,nonatomic)UIViewController* currentDetailController;

// management of the UISplitViewController button and popover
@property (strong,nonatomic) UIBarButtonItem* masterBarButtonItem;
@property (strong,nonatomic) UIPopoverController* masterPopoverController;


@end


@implementation tbMasterMgr


@synthesize splitViewController;
@synthesize detailControllers;
@synthesize masterBarButtonItem;
@synthesize masterPopoverController;
@synthesize currentDetailController;


-(id)initWithSplitViewController:(UISplitViewController*)_splitViewController withDetailRootControllers:(NSArray*)_detailControllers {
	DLog( @"" );
    self = [super init];
    if ( self ) {
        self.splitViewController = _splitViewController;
        self.detailControllers = [_detailControllers copy];
		DLog( @"detailControllers: %@", [detailControllers description]);
        UINavigationController* detailRoot = [splitViewController.viewControllers objectAtIndex: 1];
        self.currentDetailController = detailRoot.topViewController;
		
        splitViewController.delegate = self;
    }
	
    return self;
}


//	Change detail view to reflect the current master controller
-(void)changeDetailsToIndex: (int)index {
	DLog( @"" );
	
    UINavigationController* detailRootController = [self.detailControllers objectAtIndex: index];
    UIViewController* detailController = detailRootController.topViewController;
    
    if ( detailController != self.currentDetailController ) {			// If really changing detail view
        // swap button in detail controller
        [self.currentDetailController.navigationItem setLeftBarButtonItem: nil animated: NO];
        self.currentDetailController = detailController;
        [self.currentDetailController.navigationItem setLeftBarButtonItem: self.masterBarButtonItem animated: NO];
        
		DLog( @"Before update viewControllers" );
        // update controllers in splitview
        UIViewController* masterController = [self.splitViewController.viewControllers objectAtIndex: 0];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects: masterController, detailRootController, nil];
 		DLog( @"After update viewControllers" );
       
        // replace the passthrough views with current detail navigationbar
        if ( [masterPopoverController isPopoverVisible] ){
			DLog( @"Popover is visible" );
            masterPopoverController.passthroughViews = [NSArray arrayWithObject: detailRootController.navigationBar];
        } else {
			DLog( @"Popover is not visible" );
		}
    }
	if ( [masterPopoverController isPopoverVisible] )
		[masterPopoverController dismissPopoverAnimated: YES];

	DLog( @"At exit" );
}


#pragma mark - UISplitViewControllerDelegate


//	Forward the message to the current detail view - all detail views must implement UISplitViewControllerDelegate
-(void)splitViewController: (UISplitViewController *)svc willHideViewController: (UIViewController *)aViewController withBarButtonItem: (UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc {
//	DLog( @"" );
	CGRect f = aViewController.view.frame;
	DLog( @"viewController being hidden's view frame, x: %.1f, y: %.1f, w: %.1f, h: %.1f", f.origin.x, f.origin.y, f.size.width, f.size.height );

	CGSize s = pc.popoverContentSize;
	DLog( @"popoverController size if triggered from button, w: %.1f, h: %.1f", s.width, s.height );

    self.masterBarButtonItem = barButtonItem;
    self.masterPopoverController = pc;
    
    barButtonItem.title = NSLocalizedString(@"Features", @"Master");
    
    [self.currentDetailController.navigationItem setLeftBarButtonItem: masterBarButtonItem animated: YES];
}



//	Forward the message to the current detail view - all detail views must implement UISplitViewControllerDelegate
-(void)splitViewController: (UISplitViewController *)svc willShowViewController: (UIViewController *)aViewController invalidatingBarButtonItem: (UIBarButtonItem *)barButtonItem {
//	DLog( @"aViewController frame:" );
	
	CGRect f = aViewController.view.frame;
	DLog( @"viewController being shown's view frame, x: %.1f, y: %.1f, w: %.1f, h: %.1f", f.origin.x, f.origin.y, f.size.width, f.size.height );
	
	CGSize s = masterPopoverController.popoverContentSize;
	DLog( @"popoverController size, w: %.1f, h: %.1f", s.width, s.height );
	

    self.masterBarButtonItem = nil;
    self.masterPopoverController = nil;
    
    [self.currentDetailController.navigationItem setLeftBarButtonItem: nil animated: YES];
}


@end
