//
//  ProductDetailViewController.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 12. 4..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AloViewController.h"

#import "DataManager.h"

#import "CHTCollectionViewWaterfallLayout.h"

@class AppDelegate;

@interface ProductDetailViewController : AloViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong, setter=setProductInfo:) ProductInfo* productInfo;
@property (nonatomic) CGFloat mainImageHeight;
@property (nonatomic, strong) NSMutableDictionary *boxInfos;
@property (nonatomic, strong) NSMutableArray<ProductInfo*> *productInfos;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UICollectionView *collectionView;

-(void)pushToEditorView;
-(void)pushToProductWebView;

@end
