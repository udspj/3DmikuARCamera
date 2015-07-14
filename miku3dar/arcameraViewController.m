//
//  MainViewController.m
//
//  Created by udspj
//

#import "arcameraViewController.h"

#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

#import "arViewController.h"

@implementation arcameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCamera];
    
    arViewController *arvc = [[arViewController alloc] init];
    GLKView *glkview = (GLKView *)arvc.view;
    glkview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:glkview];
    [self addChildViewController:arvc];
    [arvc didMoveToParentViewController:self];
    arvc.view.frame = self.view.bounds;
}

-(void)setupCamera
{
    // 初始化摄像头和输入
    session = [[AVCaptureSession alloc] init];
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (input) {
        [session addInput:input];
    }
    
    // 设置摄像头输出
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
	dispatch_queue_t queue = dispatch_queue_create("cameraQueue", NULL);
	[captureOutput setSampleBufferDelegate:self queue:queue];
	NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
	[captureOutput setVideoSettings:videoSettings];
    [session addOutput:captureOutput];
    
    // 摄像view层
    videoLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    videoLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    videoLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:videoLayer below:self.view.layer];
    
    [session startRunning];
}

@end
