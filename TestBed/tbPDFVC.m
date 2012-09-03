//
//  tbPDFVC.m
//  TestBed
//
//  Created by Bill Snook on 7/29/12.
//  Copyright (c) SnoWare All rights reserved.
//

#import "tbPDFVC.h"
#import "DLog.h"


#define tmpPDFFile	 @"tmpPDF1.pdf"
#define testPDFFile	 @"http://samplepdf.com/sample.pdf"


@interface tbPDFVC ()


//@property (strong, nonatomic) IBOutlet	UIImageView		*imgView;
@property (strong, nonatomic) IBOutlet	UIWebView *webView;
@property (strong, nonatomic) IBOutlet	UIActivityIndicatorView	*activityIndicator;
@property (strong, nonatomic)			NSString* pdfsDirectory;
@property (strong, nonatomic)			NSString* pdfFile;


- (void)initializeDirectories;


@end


@implementation tbPDFVC


@synthesize webView;
@synthesize activityIndicator;
@synthesize pdfsDirectory;
@synthesize pdfFile;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {

	DLog( @"" );
	[super viewDidLoad];

	[self initializeDirectories];
	
	DLog( @"At end." );
}


- (void)viewDidUnload {
	
	DLog( @"" );
	[super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)viewWillAppear:(BOOL)animated {
	
 	NLog( @"" );
	[super viewWillAppear: animated];

//	[[UIApplication sharedApplication] setStatusBarHidden: NO];
//	[self.navigationController setNavigationBarHidden: NO animated: NO];
//	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

	[self exampleAnnotation2];
	
	NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL fileURLWithPath: pdfFile]];
	[webView loadRequest: request];
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//	RLog( @"" );
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}


- (void)initializeDirectories {
	DLog( @"" );
	
	// Get PDF subdirectory path including Documents folder
	NSArray* docDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [docDirectories objectAtIndex: 0];
	self.pdfsDirectory = [[NSString alloc] initWithFormat: @"%@/%@", documentsDirectory, @"PDFs"];
	self.pdfFile = [[NSString alloc] initWithFormat: @"%@/%@", pdfsDirectory, tmpPDFFile];
	
	// Verify and create PDFs subdirectory
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* err = nil;
	//	NSArray *files =
	[fileManager contentsOfDirectoryAtPath: pdfsDirectory error: &err];
	//	DLog( @"Files: %@", [files description] );
	if ( err != nil ) {
		// Check for other error producing reason? Assume for now does not exist
		[fileManager createDirectoryAtPath: pdfsDirectory withIntermediateDirectories: YES attributes: nil error: nil];
	}
}


- (void) exampleAnnotation1 {
	DLog( @"" );
	
	NSURL *url = [NSURL URLWithString: testPDFFile];
	CGPDFDocumentRef templateDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)(url));
	
	if ( ! templateDocument ) {
		DLog( @"No CGPDFDocumentCreateWithURL" );
		return;
	}
	
	//get amount of pages in template
	size_t count = CGPDFDocumentGetNumberOfPages(templateDocument);
	DLog( @"count: %d", count );
    if (count == 0) {
        NSLog(@"PDF needs at least one page");
        return;
    }
	
	//for each page in template
	for (size_t pageNumber = 1; pageNumber <= count; pageNumber++) {
		//get bounds of template page
		CGPDFPageRef templatePage = CGPDFDocumentGetPage(templateDocument, pageNumber);
		CGRect templatePageBounds = CGPDFPageGetBoxRect(templatePage, kCGPDFCropBox);
		
		//create empty page with corresponding bounds in new document
		UIGraphicsBeginPDFContextToFile( pdfFile, templatePageBounds, nil);
		
		UIGraphicsBeginPDFPageWithInfo(templatePageBounds, nil);
		CGContextRef context = UIGraphicsGetCurrentContext();
		if ( ! context ) {
			DLog( @"Bad context" );
			return;
		}
		
		//flip context due to different origins
		CGContextTranslateCTM(context, 0.0, templatePageBounds.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		//copy content of template page on the corresponding page in new file
		CGContextDrawPDFPage(context, templatePage);
		
		//flip context back
		CGContextTranslateCTM(context, 0.0, templatePageBounds.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		/* Here you can do any drawings */
		[@"Modified copy of local page" drawAtPoint:CGPointMake(100, 50) withFont:[UIFont systemFontOfSize:20]];
	}
	CGPDFDocumentRelease(templateDocument);
	UIGraphicsEndPDFContext();
	
}


- (void) exampleAnnotation2 {
	DLog( @"" );
	
	NSURL *url = [NSURL URLWithString: testPDFFile];
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL ((__bridge CFURLRef) url);

	if ( ! document ) {
		DLog( @"No CGPDFDocumentCreateWithURL" );
		return;
	}
	
	// Get number of pages
	size_t count = CGPDFDocumentGetNumberOfPages (document);
    if (count == 0) {
        NSLog(@"PDF needs at least one page");
        return;
    }
	
    CGPDFPageRef page = CGPDFDocumentGetPage (document, 1); // grab page 1 of the PDF
	CGRect paperSize = CGPDFPageGetBoxRect( page, kCGPDFCropBox );
	
	UIGraphicsBeginPDFContextToFile( pdfFile, paperSize, nil);
	
    UIGraphicsBeginPDFPageWithInfo(paperSize, nil);
	
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
	if ( ! currentContext ) {
		DLog( @"Bad context" );
		return;
	}
	
    // flip context so page is right way up
    CGContextTranslateCTM(currentContext, 0, paperSize.size.height);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
	
    CGContextDrawPDFPage (currentContext, page); // draw page 1 into graphics context
	
	// flip context so annotations are right way up
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, -paperSize.size.height);
	
    [@"Modified local copy!" drawInRect:CGRectMake(50.0, 50.0, 300.0, 40.0) withFont:[UIFont systemFontOfSize:18.0]];
	
    UIGraphicsEndPDFContext();
	
    CGPDFDocumentRelease (document);
}


@end
