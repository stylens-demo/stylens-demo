//
//  IndicatorViewController.h
//  Vintique
//
//  Created by 기대 여 on 11. 3. 19..
//  Copyright 2011 Gidae Yeo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface IndicatorViewController : UIViewController {
    
    UIActivityIndicatorView* indicator;
    
    UIView* blackView;
    UILabel* progressLabel;
    
    BOOL bShowProgress;
    
    UIView* superView;
    
    CGSize curCustomizedSize;
    
    CGSize customizedSize;
    BOOL bCustomized;
    AppDelegate* app; 
    
}

@property (nonatomic, retain) UIActivityIndicatorView* indicator;
@property (nonatomic, retain) UIView* superView;

@property (nonatomic, assign) CGSize customizedSize;
@property (nonatomic, assign, setter = setBCustomized:, getter = bCustomized) BOOL bCustomized;
-(void)startIndicator;
-(void)stopIndicator;
-(void)setProgress:(NSUInteger)aProgress;
-(void)setProgressString:(NSString*)aProgress;


@end
