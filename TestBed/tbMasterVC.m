//
//  tbMasterVC.m
//  TestBed
//
//  Created by Bill Snook on 8/25/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//


#import "tbMasterVC.h"
#import "tbDetailVC.h"
#import "itFileVC.h"
#import "DLog.h"


@interface tbMasterVC () {
	
	
    NSMutableArray *_objects;
	
	
}

@end


@implementation tbMasterVC


- (void)awakeFromNib {
	DLog( @"" );
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    self.clearsSelectionOnViewWillAppear = YES;
	    self.contentSizeForViewInPopover = CGSizeMake(240.0, 200.0);
	}
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


- (void)insertNewObject:(id)sender {
	
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/*
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return _objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DLog( @"" );

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	NSDate *object = [_objects objectAtIndex:indexPath.row];
	cell.textLabel.text = [object description];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/
/*
// Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

}
*/

/*
// Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DLog( @"row: %d", indexPath.row );

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"MainStoryboard_iPad" bundle: nil];
		NSString *identifier;
		switch ( indexPath.row ) {
			case 0:
				identifier = @"DirView";
				break;
				
			case 1:
				identifier = @"PDFView";
				break;
				
			case 2:
				identifier = @"VideoView";
				break;
				
			default:
				break;
		}
//		[storyBoard instantiateViewControllerWithIdentifier: identifier ];
			
/*
        NSDate *object = [_objects objectAtIndex:indexPath.row];
        self.detailViewController.detailItem = object;
*/
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	// Called before destination viewDidLoad
	
	// First, save site URL in settings in case anything changed
	//	[self saveSettings];
	
	// Prepare for specific new pages to be loaded
	if ( [segue.identifier isEqualToString: @"toDirView"] ) {	// dirView displays contents of currentDirectory
		NLog( @"toDirView" );									// It can be sequeued to recursively
		itFileVC *fileVC = segue.destinationViewController;
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
	[self dismissViewControllerAnimated: YES completion: nil];
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	DLog( @"identifier: %@", [segue identifier] );

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = [_objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}
*/

@end
