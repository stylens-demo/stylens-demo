//
//  EditorDemoViewController.m
//  stylens-demo
//
//  Created by 김대섭 on 2018. 1. 19..
//  Copyright © 2018년 Bluehack Inc. All rights reserved.
//

#import "EditorDemoViewController.h"

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "NaviBaseViewController.h"

#import <SwaggerClient/SWGImageApi.h>
#import <SwaggerClient/SWGObjectApi.h>

#import "CameraViewController.h"
#import "ProductDetailViewController.h"

#import "Global.h"
#import "AloImage.h"

#import "EditorDemoCell.h"
#import "EditorDemoCellHeader.h"
#import "EditorDemoCellFooter.h"

#define EDITOR_DEMO_CELL_IDENTIFIER @"EditorDemoCell"
#define EDITOR_DEMO_CELL_HEADER_IDENTIFIER @"EditorDemoCellHeader"
#define EDITOR_DEMO_CELL_FOOTER_IDENTIFIER @"EditorDemoCellFooter"

@interface EditorDemoViewController ()

@end

@implementation EditorDemoViewController

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

#pragma mark - Setters
-(void)setProductInfo:(ProductInfo *)aProductInfo {
    _productInfo = aProductInfo;
}

-(void)setProductImage:(UIImage *)aProductImage {
    _productImage = aProductImage;
}

-(void)setEditorProductResultInfos:(NSMutableArray<ProductInfo*>*)anEditorProductResultInfos {
    _editorProductResultInfos = anEditorProductResultInfos;
    
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.backButton];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(7*self.app.widthRatio, 7*self.app.heightRatio, 7*self.app.widthRatio, 7*self.app.heightRatio);
        layout.headerHeight = [EditorDemoCellHeader heightWithMainImageHeight:[Global calcImageHeight:self.productImage]];
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
        [_collectionView registerClass:[EditorDemoCell class]
            forCellWithReuseIdentifier:EDITOR_DEMO_CELL_IDENTIFIER];
        [_collectionView registerClass:[EditorDemoCellHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:EDITOR_DEMO_CELL_HEADER_IDENTIFIER];
        [_collectionView registerClass:[EditorDemoCellFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:EDITOR_DEMO_CELL_FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - Networks
-(void)getImagesWithObjectId:(NSString*)anObjectId {
    SWGImageApi *apiInstance = [[SWGImageApi alloc] init];
    [apiInstance getImagesByObjectIdWithObjectId:anObjectId offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:10] completionHandler: ^(SWGGetImagesResponse* output, NSError* error) {
        [self.editorProductResultInfos removeAllObjects];
        [self.app.baseViewController stopIndicator];
        
        if (output) {
            NSLog(@"%@", output);
            NSLog(@"");
            
            for (ProductInfo *aProductInfo in [self generateEditorResultInfos:output.data]) {
                [_editorProductResultInfos addObject:aProductInfo];
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
            }];
        }
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}
-(NSMutableArray*)generateEditorResultInfos:(NSArray<SWGSimImage*>*)anEditorResultInfos {
    NSMutableArray<ProductInfo*>* aProductInfos = [[NSMutableArray alloc] init];
    ProductInfo *aProductInfo = nil;
    for(SWGImage *aSWGImage in anEditorResultInfos) {
        aProductInfo = [[ProductInfo alloc] init];
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

        [aProductInfos addObject:aProductInfo];
    }
    return aProductInfos;
}

-(void)getObjectsImagesWithProductInfo:(ProductInfo*)aProductInfo {
    SWGObjectApi *apiInstance = [[SWGObjectApi alloc] init];
    [apiInstance getObjectsByImageIdWithImageId:aProductInfo._id completionHandler:^(SWGGetObjectsByImageIdResponse *output, NSError *error) {
        [self.app.baseViewController stopIndicator];
        
        if (output) {
            NSLog(@"%@", output);
            NSLog(@"");
            
            [self pushToProductDetail:aProductInfo boxInfos:[self generateBoxInfos:output.data.boxes] productInfos:[self generateEditorResultInfos:output.data.images]];
        }
        if (error) {
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
        
        [boxObjectDic setObject:aBoxInfo forKey:[NSNumber numberWithInt:i]];
    }
    return boxObjectDic;
}

#pragma mark - Methods
-(void)backButtonClicked:(id)sender {
    [self.app.baseViewController.aloNavi popViewCointroller:YES];
}

-(void)objectButtonClickedWithKey:(int)aKey {
    BoxInfo* aBoxInfo;
    for (NSNumber *key in self.boxInfos) {
        if ([key integerValue] != aKey) {
            continue;
        }
        aBoxInfo = [self.boxInfos objectForKey:key];
        NSLog(@"Value: %@ for key: %@", aBoxInfo._id, key);
        [self getImagesWithObjectId:aBoxInfo._id];
    }
}

-(void)pushToProductDetail:(ProductInfo*)aProductInfo boxInfos:(NSMutableDictionary*)aBoxInfos productInfos:(NSMutableArray<ProductInfo*>*)aProductInfos {
    
    ProductDetailViewController *aNewViewPush = [[ProductDetailViewController alloc] initWithSize:self.app.screenRect.size];
    aNewViewPush.bShowToolbar = NO;
    aNewViewPush.productInfos = aProductInfos;
    aNewViewPush.productInfo = aProductInfo;
    aNewViewPush.boxInfos = aBoxInfos;
    [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
}

#pragma mark - Utils
-(CGRect)getBoxRectWithBoxObject:(SWGBox*)aBox {
    CGFloat imageRatio = 380 / self.app.screenRect.size.width;
    
    CGFloat originX = [aBox.left floatValue] * imageRatio;
    CGFloat originY = [aBox.top floatValue] * imageRatio;
    CGFloat width = ([aBox.right floatValue] - originX) * imageRatio;
    CGFloat height = ([aBox.bottom floatValue] - originY) * imageRatio;
    
    return CGRectMake(originX, originY, width, height);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_editorProductResultInfos count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EditorDemoCell *cell = (EditorDemoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:EDITOR_DEMO_CELL_IDENTIFIER forIndexPath:indexPath];
    
    cell.productInfo = [_editorProductResultInfos objectAtIndex:indexPath.row];
    NSString *imageUrl = [_editorProductResultInfos objectAtIndex:indexPath.row].mobileThumbImageName;

    [AloImage imageWithUrl:imageUrl WithCompletionBlock:^(BOOL bSuccess, NSError *error, UIImage *anImage) {
        if (bSuccess) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                // set image
                cell.imageView.image = anImage;
            }];
        }
    }];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    EditorDemoCellHeader *cellHeader = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        cellHeader = (EditorDemoCellHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:EDITOR_DEMO_CELL_HEADER_IDENTIFIER forIndexPath:indexPath];
        cellHeader.editorView = self;
        cellHeader.productMainImage = self.productImage;
        return cellHeader;
    }
    else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:EDITOR_DEMO_CELL_FOOTER_IDENTIFIER forIndexPath:indexPath];
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", [self.editorProductResultInfos objectAtIndex:indexPath.row]._id);
    [self.app.baseViewController startIndicator];
    [self getObjectsImagesWithProductInfo:[self.editorProductResultInfos objectAtIndex:indexPath.row]];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[_editorProductResultInfos objectAtIndex:indexPath.row].imageSize CGSizeValue];
}

@end
