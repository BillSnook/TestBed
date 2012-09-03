//
//  tbVideoMgr.h
//  TestBed
//
//  Created by Bill Snook on 8/31/12.
//  Copyright (c) 2012 SnoWare. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>


#define kImageCapturedSuccessfully	@"imageCapturedSuccessfully"

#define kImageCaptureWidth			480 // 288
#define kImageCaptureHeight			200 // 120


@interface tbVideoMgr : NSObject {

}


@property (retain)				AVCaptureVideoPreviewLayer	*previewLayer;
@property (retain)				AVCaptureSession			*captureSession;
@property (retain)				AVCaptureStillImageOutput	*stillImageOutput;
@property (retain)				UIImage						*stillImage;
@property (retain)				AVCaptureConnection			*stillVideoConnection;
@property (retain)				AVCaptureDevice				*backCamera;


- (void) addVideoPreviewLayer: (CGRect)layerRect;
- (void) addCaptureOutput;
- (void) captureStillImage;
- (void) addVideoInput;
- (UIImage *) changeContrast: (CGFloat)contrast;
- (void) torchOn: (BOOL)Onoff;
//- (void) findStillImageOutputConnection ;


@end
