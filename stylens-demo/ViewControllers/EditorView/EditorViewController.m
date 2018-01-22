//
//  EditorViewController.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 26..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "EditorViewController.h"

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "NaviBaseViewController.h"

#import <SwaggerClient/SWGObjectApi.h>

#import "Global.h"
#import "AloImage.h"

#import "CameraViewController.h"
#import "ProductDetailViewController.h"

#import "EditorCell.h"
#import "EditorCellHeader.h"
#import "EditorCellFooter.h"

#define EDITOR_CELL_IDENTIFIER @"EditorCell"
#define EDITOR_CELL_HEADER_IDENTIFIER @"EditorCellHeader"
#define EDITOR_CELL_FOOTER_IDENTIFIER @"EditorCellFooter"

@interface EditorViewController ()

@end

@implementation EditorViewController

CGFloat productImageHeight;

#pragma mark - Life Cycle
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.cameraViewController) {
        [self.cameraViewController startCaptureSession];
    }
}

-(void)loadView {
    [super loadView];
    
    self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bUsePanGesture = NO;
    
    [self.view addSubview:self.collectionView];
    
    // back button
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize aButtonSize = CGSizeMake(48*self.app.widthRatio, 48*self.app.heightRatio);
    aButton.frame = CGRectMake(10*self.app.widthRatio, (statusBarHeight+10)*self.app.heightRatio, aButtonSize.width, aButtonSize.height);
    [aButton setImage:[UIImage imageNamed:@"btnBackNor"] forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    self.backButton = aButton;
}

#pragma mark - Accessors
// from Feed
-(void)setProductInfo:(ProductInfo *)aProductInfo {
    _productInfo = aProductInfo;
    NSLog(@"%@", _productInfo._id);
    
    NSString *imageUrl = _productInfo.mainImageName;
#if DEBUG
    self.productImage = [UIImage imageNamed:imageUrl];
#else
    SWGObjectApi *apiInstance = [[SWGObjectApi alloc] init];
    [apiInstance getObjectsByImageIdWithImageId:_productInfo._id
                              completionHandler: ^(SWGGetObjectsByImageIdResponse* output, NSError* error) {
                                  if (output) {
                                      NSLog(@"%@", output);
                                      NSLog(@"");
                                  }
                                  if (error) {
                                      NSLog(@"Error: %@", error);
                                  }
                              }];
    
    [AloImage imageWithUrl:imageUrl WithCompletionBlock:^(BOOL bSuccess, NSError *error, UIImage *anImage) {
        if (bSuccess) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                self.productImage = anImage;
            }];
        }
    }];
#endif
}

// from Camera, Library, Share Activity
-(void)setProductImage:(UIImage *)aProductImage {
    _productImage = aProductImage;
}

-(void)setBoxRect:(CGRect)aBoxRect {
    _boxRect = aBoxRect;
}

-(void)setEditorResultInfos:(NSMutableArray<ProductInfo*>*)anEditorResultInfos {
    _editorResultInfos = anEditorResultInfos;
    
    [self.app.baseViewController stopIndicator];
    
    // calc mainImageHeight for HeaderCell
    productImageHeight = [Global calcImageHeight:_productImage];
    [self.view addSubview:self.collectionView];
    
    [self.view bringSubviewToFront:self.backButton];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(7*self.app.widthRatio, 7*self.app.heightRatio, 7*self.app.widthRatio, 7*self.app.heightRatio);
        layout.headerHeight = [EditorCellHeader heightWithMainImageHeight:productImageHeight];
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = 6*self.app.widthRatio;
        layout.minimumInteritemSpacing = 6*self.app.heightRatio;
        layout.columnCount = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        //        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[EditorCell class]
            forCellWithReuseIdentifier:EDITOR_CELL_IDENTIFIER];
        [_collectionView registerClass:[EditorCellHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:EDITOR_CELL_HEADER_IDENTIFIER];
        [_collectionView registerClass:[EditorCellFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:EDITOR_CELL_FOOTER_IDENTIFIER];
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return [self.app.baseViewController.dataManager.editorResultInfos count];
    return [_editorResultInfos count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EditorCell *cell = (EditorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:EDITOR_CELL_IDENTIFIER forIndexPath:indexPath];
    
//    cell.homeViewController = self;
    cell.productInfo = [_editorResultInfos objectAtIndex:indexPath.row];
    NSString *imageUrl = [_editorResultInfos objectAtIndex:indexPath.row].mobileThumbImageName;
    [AloImage imageWithUrl:imageUrl WithCompletionBlock:^(BOOL bSuccess, NSError *error, UIImage *anImage) {
        if (bSuccess) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                // set image
                cell.imageView.image = anImage;
            }];
        }
    }];
//    cell.imageView.image = [UIImage imageNamed:[self.app.baseViewController.dataManager.productInfos objectAtIndex:indexPath.row].mobileThumbImageName];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    EditorCellHeader *cellHeader = nil;

    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        cellHeader = (EditorCellHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:EDITOR_CELL_HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        cellHeader.productInfo = self.productInfo;
        cellHeader.productImage = self.productImage;
        cellHeader.boxRect = self.boxRect;
        return cellHeader;
    }
    else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:EDITOR_CELL_FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailViewController *aNewViewPush = [[ProductDetailViewController alloc] initWithSize:self.app.screenRect.size];
    aNewViewPush.bShowToolbar = NO;
    aNewViewPush.productInfo = [_editorResultInfos objectAtIndex:indexPath.row];
    [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return [[self.app.baseViewController.dataManager.editorResultInfos objectAtIndex:indexPath.row].imageSize CGSizeValue];
    return [[_editorResultInfos objectAtIndex:indexPath.row].imageSize CGSizeValue];
}

#pragma mark - Methods
-(void)backButtonClicked:(id)sender {
    [self.app.baseViewController.aloNavi popViewCointroller:YES];
}

@end
