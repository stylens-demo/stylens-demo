//
//  ViewController.m
//  stylens-demo
//
//  Created by 김대섭 on 2017. 12. 28..
//  Copyright © 2017년 Bluehack Inc. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"
#import "NaviBaseViewController.h"
#import "DataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.app.window.rootViewController = self;
    
    _naviBaseViewController = [[NaviBaseViewController alloc] init];
    [self.view addSubview:self.naviBaseViewController.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
