//
//  itVideoVC.m
//  TestBed
//
//  Created by Bill Snook on 8/11/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//

#import "itVideoVC.h"
#import "DLog.h"

#import "tbAppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>



@interface itVideoVC ()


@property (strong, nonatomic) IBOutlet	UIView					*preView;

@property (nonatomic, strong)			AVCaptureSession		*session;
@property (nonatomic, strong)			AVCaptureDevice			*videoDevice;

@end



@implementation itVideoVC


@synthesize preView;

@synthesize session;
@synthesize videoDevice;


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
	
	
	self.session = [[AVCaptureSession alloc] init];
	// Add inputs and outputs.
	
	// Setup video feed - preview layer from default video device
	DLog( @"Session original preset: %@", session.sessionPreset );
/*
	// Setup session parameters before i/o is set up - crashes on iPadsimulator otherwise
	if ( [session canSetSessionPreset: AVCaptureSessionPreset640x480] )
		session.sessionPreset = AVCaptureSessionPreset640x480;
	else if ( [session canSetSessionPreset: AVCaptureSessionPresetLow] )
		session.sessionPreset = AVCaptureSessionPresetLow;
	else if ( [session canSetSessionPreset: AVCaptureSessionPresetMedium] )
		session.sessionPreset = AVCaptureSessionPresetMedium;
	else if ( [session canSetSessionPreset: AVCaptureSessionPresetHigh] )
		session.sessionPreset = AVCaptureSessionPresetHigh;
	else if ( [session canSetSessionPreset: AVCaptureSessionPreset352x288] )
		session.sessionPreset = AVCaptureSessionPreset352x288;
	else if ( [session canSetSessionPreset: AVCaptureSessionPreset1280x720] )
		session.sessionPreset = AVCaptureSessionPreset1280x720;
	else if ( [session canSetSessionPreset: AVCaptureSessionPreset1920x1080] )
		session.sessionPreset = AVCaptureSessionPreset1920x1080;
	else {
		DLog( @"No Session preset accepted" );
		return;
	}
 
	DLog( @"Session preset now set to: %@", session.sessionPreset );
*/

	preView.backgroundColor = [UIColor lightGrayColor];
	self.view.backgroundColor = [UIColor grayColor];
	
	// Setup a video output device, a video preview layer
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession: session];
	CGRect f = preView.bounds;
	DLog( @"view bounds, x: %f, y: %f, w: %f, h: %f", f.origin.x, f.origin.y, f.size.width, f.size.height );
	captureVideoPreviewLayer.frame = f; // CGRectMake( 0.0, 0.0, 240.0, 320.0 );
	captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
	[preView.layer addSublayer: captureVideoPreviewLayer];
	
	// Setup a video input device
	self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice: videoDevice error: &error];
	if ( input ) {
		if ( [session canAddInput: input] ) {
			[session addInput: input];
		} else {
			DLog(@"Error trying to add video camera to session: %@", error);
			return;
		}
	} else {
		// Handle the error appropriately.
		DLog(@"Error trying to open video camera: %@", error);
		return;
	}
/*
	// Setup session parameters after i/o is set up
	if ( [session canSetSessionPreset: AVCaptureSessionPreset640x480] )
		session.sessionPreset = AVCaptureSessionPreset640x480;
	else if ( [session canSetSessionPreset: AVCaptureSessionPresetLow] )
		session.sessionPreset = AVCaptureSessionPresetLow;
	else if ( [session canSetSessionPreset: AVCaptureSessionPresetMedium] )
		session.sessionPreset = AVCaptureSessionPresetMedium;
	else if ( [session canSetSessionPreset: AVCaptureSessionPresetHigh] )
		session.sessionPreset = AVCaptureSessionPresetHigh;
	else if ( [session canSetSessionPreset: AVCaptureSessionPreset352x288] )
		session.sessionPreset = AVCaptureSessionPreset352x288;
	else if ( [session canSetSessionPreset: AVCaptureSessionPreset1280x720] )
		session.sessionPreset = AVCaptureSessionPreset1280x720;
	else if ( [session canSetSessionPreset: AVCaptureSessionPreset1920x1080] )
		session.sessionPreset = AVCaptureSessionPreset1920x1080;
*/
	
}


- (void)viewDidUnload {
 	DLog( @"" );
	self.session = nil;
	[self setPreView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)viewWillAppear:(BOOL)animated {
	
 	NLog( @"" );
	[super viewWillAppear: animated];

 	DLog( @"start video session" );
	[session startRunning];
	if ( NO && [videoDevice hasTorch] ) {
		NSError *error = nil;
		if ([videoDevice lockForConfiguration: &error]) {
			videoDevice.torchMode = AVCaptureTorchModeOn;
			[videoDevice unlockForConfiguration];
		}
	}

}


- (void)viewDidAppear:(BOOL)animated {
	
	NLog( @"" );
    [super viewDidAppear: animated];

}


- (void)viewWillDisappear:(BOOL)animated {
	
	NLog( @"" );
    [super viewWillDisappear: animated];

	if ( NO && [videoDevice hasTorch] ) {
		NSError *error = nil;
		if ([videoDevice lockForConfiguration: &error]) {
			videoDevice.torchMode = AVCaptureTorchModeOff;
			[videoDevice unlockForConfiguration];
		}
	}
	[session stopRunning];
 	DLog( @"stop video session" );
}


- (void)viewDidDisappear:(BOOL)animated {
	
	NLog( @"" );
    [super viewDidDisappear: animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	RLog( @"%@", [itAppDelegate orientString: interfaceOrientation] );
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	RLog( @"to %@", [itAppDelegate orientString: toInterfaceOrientation] );
	
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	RLog( @"from %@", [itAppDelegate orientString: fromInterfaceOrientation] );
	
	CGRect f = preView.frame; // UIScrollView
	CGSize s = f.size;
	s.height = f.size.height + ( 2 * f.origin.y );
	((UIScrollView *)(self.view)).contentSize = s;
}



@end
