//
//  CameraViewController.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 24..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "CameraViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "NaviBaseViewController.h"

#import <SwaggerClient/SWGObjectApi.h>
#import <SwaggerClient/SWGImageApi.h>
#import <SwaggerClient/SWGPlaygroundApi.h>

#import "Global.h"
#import "BoxInfo.h"

#import "EditorViewController.h"
#import "EditorDemoViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

NSMutableArray<ProductInfo*>* editorResultInfos;
NSMutableDictionary *boxObjectsDic;
AVCaptureSession* session;
AVCaptureStillImageOutput* stillImageOutput;

-(id)initWithFrame:(CGRect)aFrame {
    
    self = [super init];
    if(self) {
        self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        self.frame = aFrame;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)dealloc {
}

-(void)loadView {
    UIView* aView = [[UIView alloc] initWithFrame:self.frame];
    self.view = aView;
    self.view.backgroundColor = [UIColor whiteColor];
    
    aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    aView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:aView];
    self.cameraCaptureArea = aView;
    
    UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    anImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:anImageView];
    self.previewImageView = anImageView;
    self.previewImageView.hidden = YES;
    
    aView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.width)];
    [self.view addSubview:aView];
    
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize aButtonSize = CGSizeMake(84*self.app.widthRatio, 84*self.app.heightRatio);
    aButton.frame = CGRectMake(aView.frame.size.width/2 - aButtonSize.width/2, aView.frame.size.height/2 - aButtonSize.height/2, aButtonSize.width, aButtonSize.height);
    [aButton setImage:[UIImage imageNamed:@"btnCameraShotNor"] forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:aButton];
    
    editorResultInfos = [[NSMutableArray alloc] init];
    
    aView = nil;
    aButton = nil;
    anImageView = nil;
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initCaptureSession];
}

-(void)takePhoto:(UIButton *)sender {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            //UIImage *anImage = [self fixOrientationOfImage:[UIImage imageWithData:imageData]];
            //UIImageWriteToSavedPhotosAlbum(anImage, nil, nil, nil);
            //imageData = UIImageJPEGRepresentation(anImage, 1.0);
            
//            UIImage *anImage = [UIImage imageNamed:@"sample01.jpg"];
            
//            self.previewImageView.hidden = NO;
//            [self.view bringSubviewToFront:self.previewImageView];
//            self.previewImageView.image = [Global resizeAndAdjustCropImage:[UIImage imageWithData:imageData] ToRect:CGRectMake(0, 0, 1000*self.app.widthRatio, 1000*self.app.heightRatio)];

            UIImage *anImage = [Global resizeAndAdjustCropImage:[UIImage imageWithData:imageData] ToRect:CGRectMake(0, 0, 380, 380)];
            imageData = UIImageJPEGRepresentation(anImage, 1.0);
            
            NSString *filePath = [self documentsPathForFileName:@"bh_stylens_camera_image.jpg"];
            NSLog(@"%@", filePath);
            [imageData writeToFile:filePath atomically:YES];
            
#if DEBUG
//            [self pushViewController:[Global resizeAndAdjustCropImage:[UIImage imageWithData:imageData] ToRect:CGRectMake(0, 0, 1000, 1000)] boxRect:CGRectMake(100, 100, 100, 100)];
#else
            NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
            NSLog(@"%@", url);
            [self getObjectsWithUserImage:url imageData:imageData];
//            [self getPlaygroundsObjectsWithUserImage:url imageData:imageData];
#endif

            [session stopRunning];
        }
    }];
}

#pragma mark - Networks
-(void)getObjectsWithUserImage:(NSURL *)anUrl imageData:(NSData *)anImageData {
    [self.app.baseViewController startIndicator];
    SWGObjectApi *apiInstance = [[SWGObjectApi alloc] init];
    [apiInstance getObjectsByUserImageFileWithFile:anUrl
                                 completionHandler:^(SWGGetObjectsResponse* output, NSError* error) {
                                     //                                         self.previewImageView.hidden = YES;
                                     //                                         [self.view bringSubviewToFront:self.cameraCaptureArea];
                                     
                                     [editorResultInfos removeAllObjects];
                                     boxObjectsDic = nil;
                                     
                                     if (output) {
                                         NSLog(@"%@", output);
                                         NSLog(@"");
                                         
                                         if (output.data.boxes) {
                                             boxObjectsDic = [self generateBoxInfos:output.data.boxes];
                                         }
                                         
                                         if (output.data.images) {
                                             [self generateEditorResultInfos:output.data.images];
                                         }

//                                         [session startRunning];
//                                         [self pushViewController:[Global resizeAndAdjustCropImage:[UIImage imageWithData:anImageData] ToRect:CGRectMake(0, 0, 1000, 1000)] boxObjectsDic:boxObjectsDic];
                                         
                                         [self pushViewController:[UIImage imageWithData:anImageData] boxObjectsDic:boxObjectsDic];
                                     }
                                     if (error) {
                                         [self.app.baseViewController stopIndicator];
                                         [session startRunning];
                                         NSLog(@"Error: %@", error);
                                         NSLog(@"");
                                     }
                                 }];
}

/*
-(void)getObjectsWithUserImage:(NSURL *)anUrl imageData:(NSData *)anImageData {
    [self.app.baseViewController startIndicator];
    SWGObjectApi *apiInstance = [[SWGObjectApi alloc] init];
    [apiInstance getObjectsByUserImageFileWithFile:anUrl
                                 completionHandler:^(SWGGetObjectsResponse* output, NSError* error) {
                                     //                                         self.previewImageView.hidden = YES;
                                     //                                         [self.view bringSubviewToFront:self.cameraCaptureArea];
                                     
                                     [editorResultInfos removeAllObjects];
                                     
                                     if (output) {
                                         NSLog(@"%@", output);
                                         NSLog(@"");
                                         
//                                         SWGBoxObject *highestScoredObject = output.data.boxes[0];
//                                         CGRect aBoxRect = [self getBoxRectWithBoxObject:highestScoredObject.box];
//
//                                         ProductInfo *aProductInfo = nil;
//                                         for(SWGImage *aSWGImage in highestScoredObject.images) {
//                                             aProductInfo = [[ProductInfo alloc] init];
//                                             aProductInfo.swgImage = aSWGImage;
//                                             aProductInfo._id = aSWGImage._id;
//                                             aProductInfo.mainImageName = aSWGImage.mainImageMobileFull;
//                                             aProductInfo.mobileThumbImageName = aSWGImage.mainImageMobileThumb;
//                                             aProductInfo.titleLabel = aSWGImage.productName;
//                                             aProductInfo.priceLabel = [NSString stringWithFormat:@"%@ %@",
//                                                                        [Global getStringNumberFormat:aSWGImage.price],
//                                                                        [Global getCurrencyUnit:aSWGImage.currencyUnit]];
//
//                                             UIImage *anImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aSWGImage.mainImageMobileThumb]]];
//                                             aProductInfo.imageSize = [NSValue valueWithCGSize:CGSizeMake(anImage.size.width, anImage.size.height)];
//
//                                             [editorResultInfos addObject:aProductInfo];
//                                         }
//
//                                         [session startRunning];
//                                         [self pushViewController:[Global resizeAndAdjustCropImage:[UIImage imageWithData:anImageData] ToRect:CGRectMake(0, 0, 1000, 1000)] boxRect:aBoxRect];
                                     }
                                     if (error) {
                                         [self.app.baseViewController stopIndicator];
                                         [session startRunning];
                                         NSLog(@"Error: %@", error);
                                         NSLog(@"");
                                     }
                                 }];
}
*/

-(void)getPlaygroundsObjectsWithUserImage:(NSURL *)anUrl imageData:(NSData *)anImageData {
    SWGPlaygroundApi *apiInstance = [[SWGPlaygroundApi alloc] init];
    [apiInstance getPlaygroundObjectsByUserImageFileWithFile:anUrl completionHandler:^(SWGGetObjectsResponse* output, NSError* error) {
        if (output) {
            NSLog(@"%@", output);
            NSLog(@"");
        }
        if (error) {
            [self.app.baseViewController stopIndicator];
            [session startRunning];
            NSLog(@"Error: %@", error);
            NSLog(@"");
        }
    }];
}

#pragma mark - Methods
-(void)initCaptureSession {
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [self.view layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.cameraCaptureArea.frame;
    [previewLayer setFrame:frame];
    [rootLayer addSublayer:previewLayer];
    //    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [self startCaptureSession];
}

-(void)startCaptureSession {
    [session startRunning];
}

// demo
-(void)pushViewController:(UIImage *)anImage boxObjectsDic:(NSMutableDictionary *)aBoxObjectsDic {
    EditorDemoViewController *aNewViewPush = [[EditorDemoViewController alloc] initWithSize:self.app.screenRect.size];
    aNewViewPush.bShowToolbar = NO;
    aNewViewPush.cameraViewController = self;
    aNewViewPush.productImage = anImage;
    aNewViewPush.boxInfos = aBoxObjectsDic;
#if DEBUG
//    aNewViewPush.editorResultInfos = self.app.baseViewController.dataManager.productInfos;
#else
    aNewViewPush.editorProductResultInfos = editorResultInfos;
#endif
    [self.app.baseViewController stopIndicator];
    [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
}
//-(void)pushViewController:(UIImage *)anImage boxRect:(CGRect)aBoxRect {
//    EditorViewController *aNewViewPush = [[EditorViewController alloc] initWithSize:self.app.screenRect.size];
//    aNewViewPush.bShowToolbar = NO;
//    aNewViewPush.cameraViewController = self;
//    aNewViewPush.productImage = anImage;
//    aNewViewPush.boxRect = aBoxRect;
//#if DEBUG
//    aNewViewPush.editorResultInfos = self.app.baseViewController.dataManager.productInfos;
//#else
//    aNewViewPush.editorResultInfos = editorResultInfos;
//#endif
//    [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
//}

-(NSMutableDictionary*)generateBoxInfos:(NSArray<SWGBoxObject *>*)aBoxObjects {
    NSMutableDictionary *boxObjectDic = [[NSMutableDictionary alloc] init];
    BoxInfo *aBoxInfo;
    int i;
    for (i=0; i<[aBoxObjects count]; i++) {
        aBoxInfo = [[BoxInfo alloc] init];
        aBoxInfo._id = aBoxObjects[i]._id;
        aBoxInfo.classCode = aBoxObjects[i].classCode;
        aBoxInfo.score = aBoxObjects[i].score;
        
        CGRect aBoxRect = [self getBoxRectWithBoxObject:aBoxObjects[i].box];
        aBoxInfo.x = [NSNumber numberWithFloat:aBoxRect.origin.x];
        aBoxInfo.y = [NSNumber numberWithFloat:aBoxRect.origin.y];
        aBoxInfo.width = [NSNumber numberWithFloat:aBoxRect.size.width];
        aBoxInfo.height = [NSNumber numberWithFloat:aBoxRect.size.height];
        
//        [boxObjectDic setObject:aBoxInfo forKey:[NSString stringWithFormat:@"%d", i]];
        [boxObjectDic setObject:aBoxInfo forKey:[NSNumber numberWithInt:i]];
    }
    return boxObjectDic;
}

-(void)generateEditorResultInfos:(NSArray<SWGSimImage*>*)anEditorResultInfos {
    ProductInfo *aProductInfo = nil;
    for(SWGSimImage *aSWGImage in anEditorResultInfos) {
        aProductInfo = [[ProductInfo alloc] init];
//        aProductInfo.swgImage = aSWGImage;
        aProductInfo._id = aSWGImage._id;
        aProductInfo.mainImageName = aSWGImage.mainImageMobileFull;
        aProductInfo.mobileThumbImageName = aSWGImage.mainImageMobileThumb;
        aProductInfo.titleLabel = aSWGImage.productName;
        aProductInfo.priceLabel = [NSString stringWithFormat:@"%@ %@",
                                   [Global getStringNumberFormat:aSWGImage.price],
                                   [Global getCurrencyUnit:aSWGImage.currencyUnit]];
        aProductInfo.productUrl = aSWGImage.productUrl;
        
        UIImage *anImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aSWGImage.mainImageMobileThumb]]];
        aProductInfo.imageSize = [NSValue valueWithCGSize:CGSizeMake(anImage.size.width, anImage.size.height)];
        
        [editorResultInfos addObject:aProductInfo];
    }
}

#pragma mark - Utils
-(CGRect)getBoxRectWithBoxObject:(SWGBox*)aBox {
    CGFloat imageRatio = 380 / self.app.screenRect.size.width;
    
    CGFloat originX = [aBox.left floatValue] * imageRatio;
    CGFloat originY = [aBox.top floatValue] * imageRatio;
    CGFloat width = ([aBox.right floatValue] - [aBox.left floatValue]) * imageRatio;
    CGFloat height = ([aBox.bottom floatValue] - [aBox.top floatValue]) * imageRatio;
    
    return CGRectMake(originX, originY, width, height);
}

- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

- (UIImage *)fixOrientationOfImage:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
