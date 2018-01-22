//
//  AloToolbar.m
//  TestApp
//
//  Created by 기대 여 on 2016. 4. 7..
//  Copyright © 2016년 기대 여. All rights reserved.
//

#import "AloToolbar.h"

#import "AloBackItemView.h"
#import "AloViewController.h"

@implementation AloToolbar


-(id)initWithFrame:(CGRect)frame {
 
    self = [super initWithFrame:frame];
    
    if( self ) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        CGFloat span = 0;
        _backItemView = [[AloBackItemView alloc] initWithFrame:CGRectMake(span, span +20, self.frame.size.height-span*2.0, self.frame.size.height-span*2.0)];
        [self addSubview:self.backItemView];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPiece:)];
        [self.backItemView addGestureRecognizer:tapGesture];
//        [tapGesture release], tapGesture = nil;
        tapGesture = nil;
    }
    
    return self;
}

-(void)dealloc {
    
    self.backItemView = nil;
    
    
//    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews {
    
    [super layoutSubviews];
}

-(void)tapPiece:(UIGestureRecognizer*)gestureRecognizer {
    
    [self.aloViewCotroller backItemTapped];
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGFloat span = 0;
    CGFloat itemViewSize;
    
    if( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) == YES || toInterfaceOrientation == UIInterfaceOrientationUnknown) {
    
        itemViewSize = self.frame.size.height - 20 - span*2;
        
        self.backItemView.frame = CGRectMake(span, span + 20, itemViewSize, itemViewSize);
    } else {
        
        itemViewSize = self.frame.size.height - span*2;
        
        self.backItemView.frame = CGRectMake(span, span, itemViewSize, itemViewSize);
    }
    
}
@end
