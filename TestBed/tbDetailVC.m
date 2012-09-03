//
//  tbDetailVC.m
//  TestBed
//
//  Created by Bill Snook on 8/25/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//


#import "tbDetailVC.h"
#import "tbAppDelegate.h"
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

    if (self.masterPopoverController != nil)
        [self.masterPopoverController dismissPopoverAnimated: YES];

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
	
//	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//	    self.contentSizeForViewInPopover = CGSizeMake(320.0, 400.0);
//	}
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
	RLog( @"to: %@", [tbAppDelegate orientString: interfaceOrientation] );

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	DLog( @"identifier: %@", [segue identifier] );
	
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
    }
}


@end
