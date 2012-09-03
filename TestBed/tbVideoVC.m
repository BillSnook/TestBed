//
//  tbVideoVC
//  TestBed
//
//  Created by Bill Snook on 8/11/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//

#import "tbVideoVC.h"
#import "tbVideoMgr.h"
#import "DLog.h"

#import "tbAppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>



@interface tbVideoVC ()


//@property (nonatomic, strong)			AVCaptureSession		*session;
//@property (nonatomic, strong)			AVCaptureDevice			*videoDevice;
@property (retain)						tbVideoMgr				*captureManager;

@property (nonatomic, retain)			UIImageView				*imageView;

@property(nonatomic)					BOOL					iPad;
//@property(nonatomic)					BOOL					capturing;


@end



@implementation tbVideoVC


//@synthesize session;
//@synthesize videoDevice;

@synthesize captureManager;
@synthesize imageView;

@synthesize iPad;
//@synthesize capturing;


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
	// Do any additional setup after loading the view.
//	self.capturing = NO;
	self.iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);

/*
	NSMutableString *list = [NSMutableString stringWithString: @"\nDEVICES:\n"];
	NSArray *devices = [AVCaptureDevice devices];
	for (AVCaptureDevice *device in devices) {
		DLog(@"Device name: %@", [device localizedName]);
		[list appendFormat: @"%@ -", [device localizedName]];
		BOOL foundMedia = NO;
		if ( [device hasMediaType: AVMediaTypeVideo] ) {
			[list appendString: @" Video"];
			foundMedia = YES;
			if ( [device hasFlash] ||  [device hasTorch] ) {
				[list appendString: @"\n  "];
				if ( [device hasFlash] )
					[list appendString: @"Flash"];
				if ( [device hasFlash] && [device hasTorch] )
					[list appendString: @" and "];
				if ( [device hasTorch] )
					[list appendString: @"Torch"];
			}
		}
		if ( [device hasMediaType: AVMediaTypeAudio] ) {
			[list appendString: @" Audio"];
			foundMedia = YES;
		}
		if ( [device hasMediaType: AVMediaTypeText] ) {
			[list appendString: @" Text"];
			foundMedia = YES;
		}
		if ( [device hasMediaType: AVMediaTypeClosedCaption] ) {
			[list appendString: @" ClosedCaption"];
			foundMedia = YES;
		}
		if ( [device hasMediaType: AVMediaTypeSubtitle] ) {
			[list appendString: @" Subtitle"];
			foundMedia = YES;
		}
		if ( [device hasMediaType: AVMediaTypeTimecode] ) {
			[list appendString: @" Timecode"];
			foundMedia = YES;
		}
		if ( [device hasMediaType: AVMediaTypeTimedMetadata] ) {
			[list appendString: @" TimedMetadata"];
			foundMedia = YES;
		}
		if ( [device hasMediaType: AVMediaTypeMuxed] ) {
			[list appendString: @" Muxed"];
			foundMedia = YES;
		}
		if ( ! foundMedia ) {
			[list appendString: @" Unknown Type"];
		}
		if ( [device hasFlash] )
			[list appendString: @", Flash"];
		if ( [device hasTorch] )
			[list appendString: @", Torch"];
		[list appendString: @"\n"];
	}
	label.hidden = YES;
*/


/* ----
	self.session = [[AVCaptureSession alloc] init];
	// Add inputs and outputs.
	
	// Setup video feed - preview layer from default video device
	DLog( @"Session original preset: %@", session.sessionPreset );
*/
	[self setCaptureManager: [[tbVideoMgr alloc] init]];
	
	[captureManager addVideoInput];				// Setup Front Camera
	
	if ( iPad ) {
	} else {
	}
	
	CGRect f = self.view.frame;
	DLog( @"view frame, x: %.1f, y: %.1f, w: %.1f, h: %.1f", f.origin.x, f.origin.y, f.size.width, f.size.height );
	f.origin.y = 0.0;
	f.size.height -= 44.0;		//Account for nav bar

	[captureManager addVideoPreviewLayer: f];
///    [self.view.layer addSublayer: [captureManager previewLayer] ];
	
///	[captureManager addCaptureOutput];
	
	// Destination for video
	UIView *overlayView = [[UIView alloc] initWithFrame: f];	// Fills window
	overlayView.backgroundColor = [UIColor clearColor];
//	[[captureManager previewLayer] setCornerRadius: 20];	// 6];
//	[[captureManager previewLayer] setMasksToBounds: YES];
//	[[captureManager previewLayer] setBackgroundColor: [[UIColor whiteColor] CGColor]];
	[overlayView.layer addSublayer: [captureManager previewLayer] ];
	overlayView.backgroundColor = [UIColor blackColor];
	[self.view addSubview: overlayView];

//	self.view.backgroundColor = [UIColor orangeColor];

}


- (void)viewDidUnload {
 	DLog( @"" );
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.captureManager = nil;
	self.imageView = nil;
}


- (void)viewWillAppear:(BOOL)animated {
	
 	NLog( @"" );
	[super viewWillAppear: animated];

 	DLog( @"start video session" );
	[[captureManager captureSession] startRunning];
	[captureManager torchOn: YES];

}


- (void)viewDidAppear:(BOOL)animated {
	
	NLog( @"" );
    [super viewDidAppear: animated];

}


- (void)viewWillDisappear:(BOOL)animated {
	
	NLog( @"" );
    [super viewWillDisappear: animated];

	[captureManager torchOn: NO];
	[captureManager.captureSession stopRunning];
 	DLog( @"stop video session" );
}


- (void)viewDidDisappear:(BOOL)animated {
	
	NLog( @"" );
    [super viewDidDisappear: animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	RLog( @"%@", [tbAppDelegate orientString: interfaceOrientation] );
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	RLog( @"to %@", [tbAppDelegate orientString: toInterfaceOrientation] );
	
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	RLog( @"from %@", [tbAppDelegate orientString: fromInterfaceOrientation] );
	
}


@end
