//
//  tbDetailVC.m
//  TestBed
//
//  Created by Bill Snook on 8/25/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//


#import "tbDetailVC.h"
#import "DLog.h"


@interface tbDetailVC ()


@property (strong, nonatomic) UIPopoverController *masterPopoverController;


- (void)configureView;


@end


@implementation tbDetailVC


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
	DLog( @"" );

    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

//    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
//    }
}


- (void)configureView {
	DLog( @"" );

    // Update the user interface for the detail item.

	if (self.detailItem) {
	    self.detailDescriptionLabel.text = [self.detailItem description];
	}
}


- (void)awakeFromNib {
	DLog( @"" );
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    self.contentSizeForViewInPopover = CGSizeMake(320.0, 400.0);
	}
    [super awakeFromNib];
}


- (void)viewDidLoad {
	DLog( @"" );

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
}


- (void)viewDidUnload {
	DLog( @"" );

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)viewWillAppear:(BOOL)animated {
	NLog( @"" );
	
	[super viewWillAppear: animated];
}


- (void)viewDidAppear:(BOOL)animated {
	NLog( @"" );
	
	[super viewDidAppear: animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	NLog( @"" );
	
	[super viewWillDisappear: animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	NLog( @"" );
	
	[super viewDidDisappear: animated];
}


- (void)dealloc {
	DLog( @"" );
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	RLog( @"" );

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
	DLog( @"" );

    barButtonItem.title = NSLocalizedString(@"Features", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}


- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	DLog( @"" );

    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
