//
//  itFileVC.m
//  TestBed
//
//  Created by Bill Snook on 8/4/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//

#import "itFileVC.h"
#import "itFileViewVC.h"
#import "DLog.h"


@interface itFileVC ()


@property(strong, nonatomic)			NSMutableArray	*fileBook;


-(void)addDirectory;


@end


@implementation itFileVC


@synthesize fileBook;

@synthesize currentDirectory;


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
	DLog( @"Dir: %@", [currentDirectory lastPathComponent] );
    [super viewDidLoad];

	self.fileBook = [NSMutableArray arrayWithCapacity:10];
	
	NSArray *itemsArray = [NSArray arrayWithObjects: self.editButtonItem, [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector( addDirectory )], nil];
	self.navigationItem.rightBarButtonItems = itemsArray;
}


- (void)viewDidUnload {
 	DLog( @"" );

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.fileBook = nil;
}


- (void)viewWillAppear:(BOOL)animated {
	
 	NLog( @"" );
	[super viewWillAppear: animated];
	
	// Walk subdirectory
	BOOL hasDirectory = NO;
	NSMutableArray *nonDirBook = [NSMutableArray arrayWithCapacity: 10];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* err = nil;
	NSArray *directory = [fileManager contentsOfDirectoryAtPath: currentDirectory error: &err]; // subpathsOfDirectoryAtPath
//	DLog( @"Directory array: %@", [directory description] );
	[fileBook removeAllObjects];
	if ( err != nil ) {
		DLog( @"getContents error: %@", [err description] );
		self.fileBook = [NSMutableArray arrayWithObject: [NSDictionary dictionaryWithObject: @"No Entries" forKey: @"FileName"]];
	} else {
		if ( [directory count] > 0 ) {
			for ( NSString *entry in directory ) {
				DLog( @"  %@", entry );
				NSString *entryPath = [currentDirectory stringByAppendingPathComponent: entry];
				NSDictionary *details = [fileManager attributesOfItemAtPath: entryPath error: &err]; // subpathsOfDirectoryAtPath
				if ( err != nil ) {
					DLog( @"getAttributes error: %@", [err description] );
				} else {
//					DLog( @"getAttributes details: %@", [details description] );

					NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity: 2];
					[info setObject: entry forKey: @"FileName"];
					[info setObject: details forKey: @"Details"];
					if ( [[details objectForKey: @"NSFileType"] isEqualToString: @"NSFileTypeDirectory"] ) {
						hasDirectory = YES;
						[fileBook addObject: info];
					} else {
						[nonDirBook addObject: info];
					}
				}
			}
			if ( [nonDirBook count] > 0 )
				[fileBook addObjectsFromArray: nonDirBook];
		} else {
			DLog( @"  Empty array" );
			self.fileBook = [NSMutableArray arrayWithObject: [NSDictionary dictionaryWithObject: @"No Entries" forKey: @"FileName"]];
			self.editButtonItem.enabled = NO;
		}
	}
	self.editButtonItem.enabled = hasDirectory;
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


-(void)dealloc {
	DLog( @"" );
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//	RLog( @"" );
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// First, save site URL in settings in case anything changed
	//	[self saveSettings];
	
	// Prepare for specific new pages to be loaded
	if ( [segue.identifier isEqualToString: @"toDirView2"] ) {
		NLog( @"toDirView2" );
		itFileVC *dirVC = segue.destinationViewController;
		NSIndexPath *indexPath = [[segue.sourceViewController tableView] indexPathForCell: sender];
		dirVC.currentDirectory = [self.currentDirectory stringByAppendingPathComponent: [[fileBook objectAtIndex: indexPath.row] objectForKey: @"FileName"]];
		dirVC.navigationItem.title = [[fileBook objectAtIndex: indexPath.row] objectForKey: @"FileName"];
	} else if ( [segue.identifier isEqualToString: @"toFileView2"] ) {
		NLog( @"toFileView2" );
		itFileViewVC *fileVC = segue.destinationViewController;
		NSIndexPath *indexPath = [[segue.sourceViewController tableView] indexPathForCell: sender];
		fileVC.filePath = [self.currentDirectory stringByAppendingPathComponent: [[fileBook objectAtIndex: indexPath.row] objectForKey: @"FileName"]];
		fileVC.navigationItem.title = [[fileBook objectAtIndex: indexPath.row] objectForKey: @"FileName"];
	} else {
		NLog( @"UNPROCESSED - %@", segue.identifier);
	}
}


-(NSString *)getFileSize: (NSNumber *)size {
	NSString *sizeString;
	float fSize = [size floatValue];
	if ( fSize > (1024.0 * 1024.0) ) {
		sizeString = [NSString stringWithFormat: @"%.2f MB", fSize / (1024.0 * 1024.0)];
	} else if ( fSize > 1024.0 ) {
		sizeString = [NSString stringWithFormat: @"%.2f KB", fSize / 1024.0];
	} else {
		sizeString = [NSString stringWithFormat: @"%f bytes", fSize];
	}
	return sizeString;
}


-(void)addDirectory {
	DLog( @"" );
	
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [fileBook count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell;
	NSDictionary *details = [[fileBook objectAtIndex: indexPath.row] objectForKey: @"Details"];
	if ( nil == details ) {
		cell = [tableView dequeueReusableCellWithIdentifier: @"nilViewCell"];
	} else
	if ( [[details objectForKey: @"NSFileType"] isEqualToString: @"NSFileTypeDirectory"] ) {
		cell = [tableView dequeueReusableCellWithIdentifier: @"dirViewCell"];
		cell.detailTextLabel.text = @"";
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier: @"fileViewCell"];
		cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", [self getFileSize: [details objectForKey: @"NSFileSize"]]];
	}
    
    // Configure the cell...
	cell.textLabel.text = [[fileBook objectAtIndex: indexPath.row] objectForKey: @"FileName"];
    
    return cell;
}



// Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	 NSDictionary *details = [[fileBook objectAtIndex: indexPath.row] objectForKey: @"Details"];
	 if ( details && [[details objectForKey: @"NSFileType"] isEqualToString: @"NSFileTypeDirectory"] )
    	return YES;
	else
    	return NO;
}



// Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	DLog( @"" );
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Remove the directory from the file system
		NSFileManager* fileManager = [NSFileManager defaultManager];
		NSError* err = nil;
		NSString *fileName = [[fileBook objectAtIndex: indexPath.row] objectForKey: @"FileName"];
		if ( ! [fileManager removeItemAtPath: [currentDirectory stringByAppendingPathComponent: fileName] error: &err] ) {
			DLog( @"remove directory error: %@", [err description] );
		}
		// Delete the row from the data source
		[fileBook removeObjectAtIndex: indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
		
		if ( 0 == [fileBook count]  ) {
			DLog( @"fileBook empty" );
			[tableView setEditing: NO];
			self.editButtonItem.enabled = NO;
		}
    }
//	else if (editingStyle == UITableViewCellEditingStyleInsert) {
	 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//	}
}


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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DLog( @"row: %d", indexPath.row );
	
	NSDictionary *details = [[fileBook objectAtIndex: indexPath.row] objectForKey: @"Details"];
	if ( nil == details )
		[tableView deselectRowAtIndexPath: indexPath animated: YES];
/*
	NSDictionary *details = [[fileBook objectAtIndex: indexPath.row] objectForKey: @"Details"];
	if ( [[details objectForKey: @"NSFileType"] isEqualToString: @"NSFileTypeDirectory"] ) {
		DLog( @"Directory type");
	} else {
		DLog( @"File type");
	}
*/
}

/* Defaults to Delete
- (UITableViewCellEditingStyle)tableView: tableView editingStyleForRowAtIndexPath: indexPath {
	DLog( @"" );
//	DLog( @"row: %d", indexPath.row );
	
	return UITableViewCellEditingStyleNone;
}
*/

@end
