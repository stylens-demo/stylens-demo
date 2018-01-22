//
//  EditorDemoCellHeader.m
//  stylens-demo
//
//  Created by 김대섭 on 2018. 1. 19..
//  Copyright © 2018년 Bluehack Inc. All rights reserved.
//

#import "EditorDemoCellHeader.h"

#import "AppDelegate.h"
#import "BaseViewController.h"

#import "EditorDemoViewController.h"
#import "BoxInfo.h"

#import "Global.h"
#import "AloImage.h"
#import "TKImageView.h"

@implementation EditorDemoCellHeader

NSMutableArray *objectDetectionButtons;
UIButton *currentButton;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:aView];
        self.productMainImageBgView = aView;
        aView.backgroundColor = [UIColor lightGrayColor];
        
        _tkImageView = [[TKImageView alloc] initWithFrame:CGRectZero];
        _tkImageView.backgroundColor = [UIColor blackColor];
        [self.productMainImageBgView addSubview:_tkImageView];
        
        UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        anImageView.backgroundColor = [UIColor lightGrayColor];
        [self.productMainImageBgView addSubview:anImageView];
        self.productMainImageView = anImageView;
    }
    return self;
}

- (void)dealloc {
    objectDetectionButtons = nil;
    currentButton = nil;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Setters
-(void)setProductMainImage:(UIImage *)aProductMainImage {
    if (!aProductMainImage) {
        return;
    }
    _productMainImage = aProductMainImage;
    
    self.productMainImageBgView.frame = CGRectMake(0, 0, self.app.screenRect.size.width, [Global calcImageHeight:_productMainImage]);
    
    self.productMainImageView.frame = self.productMainImageBgView.frame;
    self.productMainImageView.image = _productMainImage;
    
    if (!self.objectDetectionButtons) {
        if ([self.editorView.boxInfos count] > 0) {
            self.objectDetectionButtons = [[NSMutableArray alloc] init];
            BoxInfo* aBoxInfo;
            for (NSNumber *key in self.editorView.boxInfos) {
                aBoxInfo = [self.editorView.boxInfos objectForKey:key];
                NSLog(@"Value: %@ for key: %@", aBoxInfo, key);
                
                UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [aButton setImage:[UIImage imageNamed:@"btnObjectDotNor"] forState:UIControlStateNormal];
                [aButton addTarget:self action:@selector(objectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                aButton.tag = key.integerValue;
                aButton.frame = [self getObjectButtonRect:aBoxInfo];
                
                [self.objectDetectionButtons addObject:aButton];
                [self addSubview:aButton];
            }
        }
        
        if (_productMainImage) {
            self.productMainImageBgView.frame = CGRectMake(0, 0, self.app.screenRect.size.width, [Global calcImageHeight:_productMainImage]);
            
            self.productMainImageView.frame = self.productMainImageBgView.frame;
            self.productMainImageView.image = _productMainImage;
            
            [self setUpTKImageView:_productMainImage];
        }
        
        NSLog(@"%@", self.currentButton);
        
        if (self.currentButton) {
            self.productMainImageView.hidden = YES;
            [self resetObjectButtonViews:self.currentButton];
        }
    }
    
    
}

#pragma mark - Methods
- (void)setUpTKImageView:(UIImage*)anImage {
    
    _tkImageView.frame = CGRectMake(0, 0, self.productMainImageBgView.frame.size.width, self.productMainImageBgView.frame.size.height);
    _tkImageView.toCropImage = anImage;
    _tkImageView.showMidLines = NO;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = NO;
    _tkImageView.cornerBorderInImage = NO;
    
    _tkImageView.cropAreaCornerWidth = 25;
    _tkImageView.cropAreaCornerHeight = 25;
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _tkImageView.minSpace = 0;
    
    _tkImageView.cropAreaBorderLineWidth = 0;
}

-(void)setObjectBoxRectWithBoxInfo:(BoxInfo*)aBoxInfo {
    CGRect aRect = CGRectMake([aBoxInfo.x floatValue], [aBoxInfo.y floatValue], [aBoxInfo.width floatValue], [aBoxInfo.height floatValue]);
    [_tkImageView resetCropAreaWithCGRect:aRect];
}

-(CGRect)getObjectButtonRect:(BoxInfo*)aBoxInfo{
    CGSize aButtonSize = CGSizeMake(30*self.app.widthRatio, 30*self.app.heightRatio);
    
    CGFloat originX = aBoxInfo.x.floatValue + aBoxInfo.width.floatValue/2 - aButtonSize.width/2;
    CGFloat originY = aBoxInfo.y.floatValue + aBoxInfo.height.floatValue/2 - aButtonSize.height/2;
    
    CGRect aRect = CGRectMake(originX, originY, aButtonSize.width, aButtonSize.height);
    NSLog(@"%@", NSStringFromCGRect(aRect));
    
    return aRect;
}

-(void)resetObjectButtonViews:(UIButton *)anObjectButton {
    self.productMainImageView.hidden = YES;
    for (UIButton *aButton in self.objectDetectionButtons) {
        if (aButton.tag == anObjectButton.tag) {
            aButton.hidden = YES;
            self.currentButton = anObjectButton;
            [self setObjectBoxRectWithBoxInfo: [self.editorView.boxInfos objectForKey:[NSNumber numberWithLong:anObjectButton.tag]]];
        } else {
            aButton.hidden = NO;
        }
    }
}

-(void)objectButtonClicked:(UIButton *)anObjectButton {
    NSLog(@"%ld", (long)anObjectButton.tag);
    [self.app.baseViewController startIndicator];
    
    [self resetObjectButtonViews:anObjectButton];
    [self.editorView objectButtonClickedWithKey:(int)anObjectButton.tag];
    
//    for (id child in [self subviews]) {
//        if ([child isMemberOfClass:[UIButton class]]) {
//            [child removeFromSuperview];
//        }
//    }
//    self.objectDetectionButtons = nil;
    self.tkImageView.hidden = NO;
}

#pragma mark - Static
+(CGFloat)heightWithMainImageHeight:(CGFloat)mainImageHeight {
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return mainImageHeight * app.heightRatio;
}

@end
