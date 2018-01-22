//
//  EditorViewController.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 26..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AloViewController.h"
#import "DataManager.h"

#import "CHTCollectionViewWaterfallLayout.h"

@class AppDelegate;
@class CameraViewController;

@interface EditorViewController : AloViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, weak) CameraViewController *cameraViewController;

@property (nonatomic, strong, setter=setProductInfo:) ProductInfo* productInfo;
@property (nonatomic, strong, setter=setProductImage:) UIImage *productImage;
@property (nonatomic, assign, setter=setBoxRect:) CGRect boxRect;
@property (nonatomic, assign, setter=setEditorResultInfos:) NSMutableArray<ProductInfo*>* editorResultInfos;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@end
