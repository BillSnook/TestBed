//
//  tbVideoMgr.m
//  TestBed
//
//  Created by Bill Snook on 8/31/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//


#import "tbVideoMgr.h"
#import "DLog.h"
#import <ImageIO/ImageIO.h>

#import <CoreImage/CIFilter.h>


/*
UIImage *imageFromSampleBuffer(CMSampleBufferRef sampleBuffer) {
	
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer.
    CVPixelBufferLockBaseAddress(imageBuffer,0);
	
    // Get the number of bytes per row for the pixel buffer.
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height.
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
	
    // Create a device-dependent RGB color space.
    static CGColorSpaceRef colorSpace = NULL;
    if (colorSpace == NULL) {
        colorSpace = CGColorSpaceCreateDeviceRGB();
		if (colorSpace == NULL) {
            // Handle the error appropriately.
            return nil;
        }
    }
	
    // Get the base address of the pixel buffer.
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
	
    // Create a Quartz direct-access data provider that uses data we supply.
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    // Create a bitmap image from data supplied by the data provider.
    CGImageRef cgImage = CGImageCreate( width, height, 8, 32, bytesPerRow,
				  colorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
				  dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
	
    // Create and return an image object to represent the Quartz image.
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
	
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
	
    return image;
}
*/

// Obj-C 
@implementation tbVideoMgr


@synthesize captureSession;
@synthesize previewLayer;
@synthesize stillImageOutput;
@synthesize stillImage;
@synthesize stillVideoConnection;
@synthesize backCamera;


#pragma mark Capture Session Configuration

- (id) init {
	if ((self = [super init])) {
		DLog( @"Alloc/init capture session" );
		self.captureSession = [[AVCaptureSession alloc] init];
/*
		if ( [CIFilter class] ) {	// Only use this if filters are implemented - iOS v5.0+
			NSArray *filterNames = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
			NSLog(@"Built in filters");
			for ( NSString *currentFilterName in filterNames ) {
				NSLog(@"  %@", currentFilterName);
			}
		} else {
			NSLog(@"No Filters available");
		}
*/
	}
	return self;
}


- (void) addVideoInput {
 	DLog( @"" );

    NSArray* devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice* device in devices) {
        DLog(@"Device name: %@", [device localizedName]);
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                DLog(@"  Device position : back");
                backCamera = device;
            }
        }
    }
	
    NSError* error = nil;    
	AVCaptureDeviceInput* backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice: backCamera error: &error];
	if ( ! error ) {
		if ([captureSession canAddInput: backFacingCameraDeviceInput]) {
			[captureSession addInput: backFacingCameraDeviceInput];
		} else {
			DLog(@"Couldn't add back facing video input");
		}
	}
	
	DLog( @"Initial session preset: %@", captureSession.sessionPreset);
	
//	if ( [captureSession canSetSessionPreset: AVCaptureSessionPresetHigh] ) {
//		captureSession.sessionPreset = AVCaptureSessionPresetHigh;
//	} else if ( [captureSession canSetSessionPreset: AVCaptureSessionPresetMedium] ) {
//		captureSession.sessionPreset = AVCaptureSessionPresetMedium;
//	} else {
//		captureSession.sessionPreset = AVCaptureSessionPreset640x480;
//	}

	 // Setup session parameters after i/o is set up
	 if ( [captureSession canSetSessionPreset: AVCaptureSessionPreset1920x1080] )
		captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
	 else if ( [captureSession canSetSessionPreset: AVCaptureSessionPresetHigh] )
		captureSession.sessionPreset = AVCaptureSessionPresetHigh;
	 else if ( [captureSession canSetSessionPreset: AVCaptureSessionPreset1280x720] )
		captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
	 else if ( [captureSession canSetSessionPreset: AVCaptureSessionPresetMedium] )
		captureSession.sessionPreset = AVCaptureSessionPresetMedium;
	 else if ( [captureSession canSetSessionPreset: AVCaptureSessionPreset640x480] )
		captureSession.sessionPreset = AVCaptureSessionPreset640x480;
	 else if ( [captureSession canSetSessionPreset: AVCaptureSessionPresetLow] )
		captureSession.sessionPreset = AVCaptureSessionPresetLow;
	 else if ( [captureSession canSetSessionPreset: AVCaptureSessionPreset352x288] )
		captureSession.sessionPreset = AVCaptureSessionPreset352x288;

	
	
	DLog( @"Session preset set to: %@", captureSession.sessionPreset);
}


- (void) addVideoPreviewLayer: (CGRect)layerRect {
 	DLog( @"" );

	self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession: [self captureSession]];
	[previewLayer setVideoGravity: AVLayerVideoGravityResizeAspectFill]; // AVLayerVideoGravityResizeAspectFill
    [previewLayer setBounds: layerRect];
    [previewLayer setPosition: CGPointMake( CGRectGetMidX( layerRect ), CGRectGetMidY( layerRect ) )];
}


- (void) addCaptureOutput {
 	DLog( @"" );

	self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
	NSDictionary* outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
									AVVideoCodecJPEG, AVVideoCodecKey,
									[NSNumber numberWithInteger: kImageCaptureWidth], AVVideoWidthKey,
									[NSNumber numberWithInteger: kImageCaptureHeight], AVVideoHeightKey, nil];
	[stillImageOutput setOutputSettings: outputSettings];
	[captureSession addOutput: stillImageOutput];
}


- (void) torchOn: (BOOL)Onoff {
	return;
	
 	DLog( @"" );
	
	if ( backCamera.hasTorch ) {	// && backCamera.torchAvailable - iOS 5+ only
		AVCaptureTorchMode torchMode;
		if ( Onoff )
			torchMode = AVCaptureTorchModeOn;
		else
			torchMode = AVCaptureTorchModeOff;
		if ( [backCamera isTorchModeSupported: torchMode] ) {
			NSError *error = nil;
			if ( [backCamera lockForConfiguration: &error] ) {
				backCamera.torchMode = torchMode;
				[backCamera unlockForConfiguration];
//			} else {
//				NSLog( @"CSM torchOn, cannot lock back camera, error: %@", [error description] );
			}
//		} else {
//			NSLog( @"CSM torchOn, torch mode not supported: %d", torchMode );
		}
//	} else {
//		NSLog( @"CSM torchOn, back camera has no torch" );
	}
}


static inline double radians (double degrees) {return degrees*  M_PI/180;}


- (void) captureStillImage {			// contrast is 0..1
	DLog( @"" );						// Time check
	
	self.stillVideoConnection = nil;
	for (AVCaptureConnection* connection in [[self stillImageOutput] connections]) {
		for (AVCaptureInputPort* port in [connection inputPorts]) {
			if ([[port mediaType] isEqual: AVMediaTypeVideo]) {
				self.stillVideoConnection = connection;
				break;
			}
		}
		if (stillVideoConnection) { 
			break; 
		}
	}
  
///	NSLog(@"about to request a capture from: %@", [self stillVideoConnection]);
///	NSLog(@"about to request a capture for: %@", [self stillImageOutput]);
	[stillImageOutput captureStillImageAsynchronouslyFromConnection: stillVideoConnection
						completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError* error) {
/*
			CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
			if (exifAttachments) {
//				NSLog(@"attachments: %@", exifAttachments);
				NSLog(@"attachments");
			} else { 
				NSLog(@"no attachments");
			}
*/
			NSData* imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation: imageSampleBuffer];
			UIImage* simage = [[UIImage alloc] initWithData: imageData];

			CGImageRef image = simage.CGImage;
			float width = CGImageGetWidth(image);
			float height = CGImageGetHeight(image);
			DLog(@"CaptureStillImage Block, w: %.1f, h: %.1f", width, height);	// Time check
            
			CGRect imgRect = CGRectMake(0, 0, width, height);
			CGAffineTransform transform = CGAffineTransformMakeRotation(radians(-90));
			transform = CGAffineTransformTranslate(transform, width/2., height/2.);
			CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);

			CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
			CGContextRef bmContext = CGBitmapContextCreate(NULL,
														   rotatedRect.size.width,
														   rotatedRect.size.height,
														   8, 0, colorSpace,
														   kCGImageAlphaPremultipliedFirst);
			CGColorSpaceRelease(colorSpace);
			CGContextTranslateCTM(bmContext,
								  (rotatedRect.size.width/2),
								  (rotatedRect.size.height/2));
			CGContextRotateCTM(bmContext, radians(-90));
			CGContextDrawImage(bmContext,
							   CGRectMake(-width/2.,
										  -height/2.,
										  width,
										  height),
							   image);
                                                           
			CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
			CFRelease(bmContext);
			DLog(@"After rotation"); // Time check

			// Offset into video to get still image slice - get kImageCaptureHeight slice that is centered vertically
			// because AVLayerVideoGravityResizeAspect fills the width in this case and the top and bottom are not displayed
			CGFloat hLevel = height / 2.4;
			CGFloat yOffset = (width - hLevel) / 2.0;
			CGRect subRect = CGRectMake( 0.0, yOffset, height, hLevel );
			DLog( @"CaptureStillImage Block, subRect, x: %.1f, y: %.1f, w: %.1f, h: %.1f", subRect.origin.x, subRect.origin.y, subRect.size.width, subRect.size.height );
			CGImageRef subset = CGImageCreateWithImageInRect(rotatedImage, subRect);
			CGImageRelease(rotatedImage);
			
/*
			CGImageRef outImageRef = [ImageUtilities normalize: subset];
			if ( outImageRef == nil ) {
				NSLog( @"outImageRef is nil" );
			} else {
				self.stillImage = [UIImage imageWithCGImage: outImageRef];
				if ( stillImage == nil ) {
					NSLog( @"stillImage is nil" );
				}
			}
//			CGImageRelease( outImageRef );
*/
			
			self.stillImage = [UIImage imageWithCGImage: subset];
			CGImageRelease(subset);

			CGSize size = [stillImage size];
			CGFloat scale = [stillImage scale];
			NSLog( @"CaptureStillImage Block, final still img size, w: %.1f, h: %.1f; scale: %.2f", size.width, size.height, scale );

			[[NSNotificationCenter defaultCenter] postNotificationName: kImageCapturedSuccessfully object: nil];
			NSLog(@"CaptureStillImage Block at end");	// Time check
		}];
}


- (UIImage *) changeContrast: (CGFloat)contrast {
 	DLog( @"to: %.2f", contrast);

	if ( stillImage ) {
//		NSLog(@"CSM changeContrast before CIImage");
		CIImage *inputImage = [[CIImage alloc] initWithImage: stillImage];
		if ( inputImage ) {
			CIFilter *eFilter = [CIFilter filterWithName: @"CIColorControls"];
			[eFilter setDefaults];
			[eFilter setValue: inputImage forKey: @"inputImage"];
			[eFilter setValue: [NSNumber numberWithFloat: 0.0] forKey: @"inputSaturation"];	// 0..2
			[eFilter setValue: [NSNumber numberWithFloat: 1.0] forKey: @"inputBrightness"];	// -1..1
			[eFilter setValue: [NSNumber numberWithFloat: (contrast * 2.0) + 1.9] forKey: @"inputContrast"];	// 0..4
			CIImage *outputImage = [eFilter valueForKey: @"outputImage"];
			// define context
			CIContext *context = [CIContext contextWithOptions: nil];
			// set image to UIImageView
			CGImageRef tmpImage = [context createCGImage: outputImage fromRect: outputImage.extent];
	//		[outputImage release];
	//		NSLog(@"CSM changeContrast after CIImage");
			UIImage *outImg = [UIImage imageWithCGImage: tmpImage];
			CGImageRelease( tmpImage );
			if ( outImg ) {
				return outImg;
			} else {
				DLog(@"Could not create UIImage from CGImage");
			}
		} else {
			DLog(@"Could not allocate CIImage from stillImage");
		}
	} else {
		DLog(@"No stillImage");
	}
	return nil;
}


- (void) dealloc {
 	DLog( @"" );

	[[self captureSession] stopRunning];

	self.stillVideoConnection = nil;
	self.previewLayer = nil;
	self.captureSession = nil;
	self.stillImageOutput = nil;
	self.stillImage = nil;
}


@end
