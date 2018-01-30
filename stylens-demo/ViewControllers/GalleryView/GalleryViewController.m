//
//  GalleryViewController.m
//  stylens-demo
//
//  Created by 김대섭 on 2018. 1. 28..
//  Copyright © 2018년 Bluehack Inc. All rights reserved.
//

#import "GalleryViewController.h"

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "NaviBaseViewController.h"

#import "Global.h"
#import <SwaggerClient/SWGObjectApi.h>
#import "BoxInfo.h"

#import "EditorDemoViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

NSMutableArray<ProductInfo*>* galleryResultInfos;
NSMutableDictionary *galleryBoxObjectsDic;

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
    
//    UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.app.screenRect.size.width, self.app.screenRect.size.height/2)];
//    anImageView.backgroundColor = [UIColor darkGrayColor];
//    [self.view addSubview:anImageView];
//    self.previewImageView = anImageView;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    self.imagePickerController = imagePickerController;
    
    galleryResultInfos = [[NSMutableArray alloc] init];
}

#pragma mark - Networks
-(void)getObjectsWithUserImage:(NSURL *)anUrl imageData:(NSData *)anImageData {
    [self.app.baseViewController startIndicator];
    
    SWGObjectApi *apiInstance = [[SWGObjectApi alloc] init];
    [apiInstance getObjectsByUserImageFileWithFile:anUrl
                                 completionHandler:^(SWGGetObjectsResponse* output, NSError* error) {
                                     
                                     [galleryResultInfos removeAllObjects];
                                     galleryBoxObjectsDic = nil;
                                     
                                     if (output) {
                                         NSLog(@"%@", output);
                                         NSLog(@"");
                                         
                                         if (output.data.boxes) {
                                             galleryBoxObjectsDic = [self generateBoxInfos:output.data.boxes];
                                         }

                                         if (output.data.images) {
                                             [self generateEditorResultInfos:output.data.images];
                                         }
                                         
                                         [self pushViewController:[UIImage imageWithData:anImageData] boxObjectsDic:galleryBoxObjectsDic];
                                     }
                                     if (error) {
                                         [self.app.baseViewController stopIndicator];
                                         NSLog(@"Error: %@", error);
                                     }
                                 }];
}

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
        
        [galleryResultInfos addObject:aProductInfo];
    }
}

#pragma mark - Methods
-(void)showGallery {
    [self.app.baseViewController.naviBaseViewController presentViewController:self.imagePickerController animated:YES completion:nil];
}

// demo
-(void)pushViewController:(UIImage *)anImage boxObjectsDic:(NSMutableDictionary *)aBoxObjectsDic {
    EditorDemoViewController *aNewViewPush = [[EditorDemoViewController alloc] initWithSize:self.app.screenRect.size];
    aNewViewPush.bShowToolbar = NO;
    aNewViewPush.galleryViewController = self;
    aNewViewPush.productImage = anImage;
    aNewViewPush.boxInfos = aBoxObjectsDic;
    aNewViewPush.editorProductResultInfos = galleryResultInfos;

    [self.app.baseViewController stopIndicator];
    [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *resizedImage = [Global resizeImage:[info valueForKey:UIImagePickerControllerOriginalImage] MaxSize:380.0];
    self.previewImage = resizedImage;
    
    NSLog(@"%f x %f", resizedImage.size.width, resizedImage.size.height);
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(resizedImage, 1.0)];
    
    NSString *filePath = [self documentsPathForFileName:@"bh_stylens_camera_image.jpg"];
    [imageData writeToFile:filePath atomically:YES];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
    [self getObjectsWithUserImage:url imageData:imageData];
    
    [self.app.baseViewController.naviBaseViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utils
-(CGRect)getBoxRectWithBoxObject:(SWGBox*)aBox {
    CGFloat imageRatio = self.app.screenRect.size.width / self.previewImage.size.width;
    
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

@end
