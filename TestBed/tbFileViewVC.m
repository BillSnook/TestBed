//
//  tbFileViewVC.m
//  TestBed
//
//  Created by Bill Snook on 8/4/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//

#import "tbFileViewVC.h"
#import "DLog.h"


@interface tbFileViewVC ()


@end


@implementation tbFileViewVC


@synthesize filePath;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
//	DLog( @"File: %@", filePath );
	DLog( @"File: %@", [filePath lastPathComponent] );
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
//	NSFileManager* fileManager = [NSFileManager defaultManager];
//	NSError* err = nil;
//	NSDictionary *details = [fileManager attributesOfItemAtPath: filePath error: &err];
//	DLog( @"File attributes: %@", [details description] );
}


- (void)viewDidUnload {
 	DLog( @"" );
	
    [super viewDidUnload];

    // Release any retained subviews of the main view.
	self.filePath = nil;
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


@end
