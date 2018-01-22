//
//  AloToolbar.h
//  TestApp
//
//  Created by 기대 여 on 2016. 4. 7..
//  Copyright © 2016년 기대 여. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AloBackItemView;
@class AloViewController;

@interface AloToolbar : UIView

@property (nonatomic, retain) AloBackItemView* backItemView;
@property (nonatomic, assign) AloViewController* aloViewCotroller;

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end
