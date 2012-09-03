//
//  tbMasterVC.m
//  TestBed
//
//  Created by Bill Snook on 8/25/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//


#import "tbMasterVC.h"
#import "tbDetailVC.h"
#import "tbAppDelegate.h"
#import "tbFileVC.h"
#import "tbPDFVC.h"
#import "tbVideoVC.h"
#import "tbMasterMgr.h"
#import "DLog.h"


@interface tbMasterVC ()


@property (nonatomic, assign)			UISplitViewController	*splitViewController;


@end


@implementation tbMasterVC


@synthesize splitViewController;


- (void)awakeFromNib {
	DLog( @"" );
	
    [super awakeFromNib];
}


- (void)viewDidLoad {
	DLog( @"" );

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//	self.navigationItem.leftBarButtonItem = self.editButtonItem;

//	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//	self.navigationItem.rightBarButtonItem = addButton;
//	self.detailViewController = (tbDetailVC *)[[self.splitViewController.viewControllers lastObject] topViewController];

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		self.splitViewController = (UISplitViewController *)(self.navigationController.parentViewController);
	    self.clearsSelectionOnViewWillAppear = YES;
	    self.contentSizeForViewInPopover = CGSizeMake( 320.0, 320.0 );
	}
}


- (void)viewDidUnload {
	DLog( @"" );

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)viewWillAppear:(BOOL)animated {
	NLog( @"" );
	
	[super viewWillAppear: animated];

	self.contentSizeForViewInPopover = CGSizeMake( 320.0, 320.0 );
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DLog( @"row: %d", indexPath.row );
	
	[((tbAppDelegate *)([[UIApplication sharedApplication] delegate])).masterManager changeDetailsToIndex: indexPath.row];

/*
    NSUInteger row = indexPath.row;
    
    UIViewController <tbSubstituteDetailVC> *detailViewController = nil;
	
    if (row == 0) {
        tbFileVC *newDetailViewController = [[tbFileVC alloc] initWithNibName: nil bundle: nil];
        detailViewController = newDetailViewController;

		tbFileVC *fileVC = (tbFileVC *)detailViewController;
		NSArray* docDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		fileVC.currentDirectory = [docDirectories objectAtIndex: 0];
		fileVC.navigationItem.title = @"Documents";

} else if (row == 1) {
        tbPDFVC *newDetailViewController = [[tbPDFVC alloc] initWithNibName: nil bundle: nil];
        detailViewController = newDetailViewController;
    } else if (row == 1) {
        tbVideoVC *newDetailViewController = [[tbVideoVC alloc] initWithNibName: nil bundle: nil];
        detailViewController = newDetailViewController;
    }
	
    // Update the split view controller's view controllers array.
    NSArray *viewControllers = [[NSArray alloc] initWithObjects: self.navigationController, detailViewController, nil];
    splitViewController.viewControllers = viewControllers;
    
    // Dismiss the popover if it's present.
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }
	
    // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
    if (popoverButtonItem != nil) {
        [detailViewController showRootPopoverButtonItem: popoverButtonItem];
    }
*/
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	// Called before destination viewDidLoad
	
	// First, save site URL in settings in case anything changed
	//	[self saveSettings];
	
	// Prepare for specific new pages to be loaded
	if ( [segue.identifier isEqualToString: @"toDirView"] ) {	// dirView displays contents of currentDirectory
		NLog( @"toDirView" );									// It can be sequeued to recursively
		tbFileVC *fileVC = segue.destinationViewController;
		NSArray* docDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		fileVC.currentDirectory = [docDirectories objectAtIndex: 0];
		fileVC.navigationItem.title = @"Documents";
	} else if ( [segue.identifier isEqualToString: @"toPDFView"] ) {
		NLog( @"toPDFView" );
	} else if ( [segue.identifier isEqualToString: @"toVideoView"] ) {
		NLog( @"toVideoView" );
	} else if ( [segue.identifier isEqualToString: @"showDetail"] ) {
		NLog( @"showDetail" );
	} else {
		NLog( @"UNPROCESSED - %@", segue.identifier);
	}
//	[self dismissViewControllerAnimated: YES completion: nil];
}

/*
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)masterPopoverController {
	DLog( @"" );
	
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = NSLocalizedString(@"Features", @"Master");
    self.popoverController = masterPopoverController;
    self.popoverButtonItem = barButtonItem;
    UIViewController <tbSubstituteDetailVC> *detailViewController = [splitViewController.viewControllers objectAtIndex: 1];
    [detailViewController showRootPopoverButtonItem: popoverButtonItem];

}


- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	DLog( @"" );

    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UIViewController <tbSubstituteDetailVC> *detailViewController = [splitViewController.viewControllers objectAtIndex: 1];
    [detailViewController invalidateRootPopoverButtonItem: popoverButtonItem];
    self.popoverController = nil;
    self.popoverButtonItem = nil;

}
 
 
 #pragma mark - Managing the popover
 
 - (void)showRootPopoverButtonItem:(UIBarButtonItem *) barButtonItem {
 DLog( @"" );
 
 // Add the popover button to the left navigation item.
 [self.navigationController.navigationBar.topItem setLeftBarButtonItem: barButtonItem animated: NO];
 }
 
 
 - (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
 DLog( @"" );
 
 // Remove the popover button.
 [self.navigationController.navigationBar.topItem setLeftBarButtonItem: nil animated: NO];
 }
 
 

*/

@end
