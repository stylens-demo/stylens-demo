//
//  EditorDemoViewController.h
//  stylens-demo
//
//  Created by 김대섭 on 2018. 1. 19..
//  Copyright © 2018년 Bluehack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AloViewController.h"
#import "DataManager.h"
#import "BoxInfo.h"

#import "CHTCollectionViewWaterfallLayout.h"

@class AppDelegate;
@class CameraViewController;
@class GalleryViewController;

@interface EditorDemoViewController : AloViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, weak) CameraViewController *cameraViewController;
@property (nonatomic, weak) GalleryViewController *galleryViewController;

@property (nonatomic, strong, setter=setProductInfo:) ProductInfo *productInfo;
@property (nonatomic, strong, setter=setProductImage:) UIImage *productImage;
@property (nonatomic, strong, setter=setBoxInfos:) NSMutableDictionary *boxInfos;
//@property (nonatomic, assign, setter=setBoxRect:) CGRect boxRect;
@property (nonatomic, strong, setter=setEditorProductResultInfos:) NSMutableArray<ProductInfo*> *editorProductResultInfos;

@property (nonatomic, strong) UIButton *currentButton;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UICollectionView *collectionView;

-(void)objectButtonClickedWithButton:(UIButton*)button;

@end
