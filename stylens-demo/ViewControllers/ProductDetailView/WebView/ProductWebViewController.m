//
//  ProductWebViewController.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 12. 11..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "ProductWebViewController.h"

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "NaviBaseViewController.h"

@interface ProductWebViewController ()

@end

@implementation ProductWebViewController

-(void)loadView {
    [super loadView];
    
    self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIWebView *aWebview
    
//    self.productWebView = aWebview;
    
    // back button
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize aButtonSize = CGSizeMake(48*self.app.widthRatio, 48*self.app.heightRatio);
    aButton.frame = CGRectMake(10*self.app.widthRatio, (statusBarHeight+10)*self.app.heightRatio, aButtonSize.width, aButtonSize.height);
    [aButton setImage:[UIImage imageNamed:@"btnBackNor"] forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    self.backButton = aButton;
}

#pragma mark - Setter
-(void)setUrlForLoad:(NSString*)aUrlForLoad {
    _urlForLoad = aUrlForLoad;
    NSLog(@"%@", aUrlForLoad);
    
    _productWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, statusBarHeight*self.app.heightRatio, self.app.screenRect.size.width, self.app.screenRect.size.height)];
    _productWebView.delegate = self;
    _productWebView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_productWebView];
    
    [self.view bringSubviewToFront:self.backButton];
    
    [self loadWebView];
}

#pragma mark - Methods
-(void)backButtonClicked:(id)sender {
    [self.app.baseViewController.aloNavi popViewCointroller:YES];
}

-(void)loadWebView {
    [self.productWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlForLoad]]];
}

#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

@end
