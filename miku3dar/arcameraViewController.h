//
//  MainViewController.h
//  GLBlender1
//
//  Created by RRC on 9/9/13.
//  Copyright (c) 2013 Ricardo Rendon Cepeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <GLKit/GLKit.h>
//#import "arView.h"

@interface arcameraViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate,GLKViewDelegate>
{
    //摄像头
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *videoLayer;
    AVCaptureDeviceInput *input;
    //AVCaptureStillImageOutput *output;
    AVCaptureDevice *device;
    
//    arView *arview;
    
    CGFloat accex;
    CGFloat accey;
    CGFloat accez;
}

@end
