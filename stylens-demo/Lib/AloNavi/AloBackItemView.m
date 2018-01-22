//
//  AloBackItemView.m
//  TestApp
//
//  Created by 기대 여 on 2016. 4. 7..
//  Copyright © 2016년 기대 여. All rights reserved.
//

#import "AloBackItemView.h"

@implementation AloBackItemView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if( self ) {
        self.itemColor = [UIColor blackColor];
        
        self.backgroundColor = [UIColor clearColor];
        
        _arrowWidth = -1;
        _arrowSpan = 15;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.imageView];
        self.imageView.hidden = YES;
    }
    
    return self;
}

-(void)dealloc {
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)setItemColor:(UIColor *)anItemColor {
    
#if !__has_feature(objc_arc)
    if( self.itemColor ) {
        [_itemColor release], _itemColor = nil;
    }
    
    _itemColor = [anItemColor retain];
#else
    _itemColor = anItemColor;
#endif
    
    [self setNeedsLayout];
}

-(void)setArrowSpan:(CGFloat)anArrowSpan {
    
    _arrowSpan = anArrowSpan;
    
    [self setNeedsLayout];
}

-(void)setArrowWidth:(CGFloat)anArrowWidth {
    _arrowWidth = anArrowWidth;
    
    [self setNeedsLayout];
}

-(void)setNormalImageName:(NSString *)aNormalImageName {
    
    _normalImageName = aNormalImageName;
    
    if( self.normalImageName ) {
        UIImage* anImage = [UIImage imageNamed:self.normalImageName];
        
        self.imageView.hidden = NO;
        self.imageView.image = [Global resizeAndAdjustCropImage:anImage ToRect:CGRectMake(0, 0, self.frame.size.width*2, self.frame.size.height*2)];
    } else {
        self.imageView.hidden = YES;
    }
}

-(void)setImageSize:(CGSize)anImageSize {
    
    _imageSize = anImageSize;
    
    if( self.imageSize.width < self.frame.size.width) {
        
        self.imageView.frame = CGRectMake(self.frame.size.width/2 - self.imageSize.width/2, self.frame.size.height/2 - self.imageSize.height/2, self.imageSize.width, self.imageSize.height);
        
    } else {
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
}

-(void)drawRect:(CGRect)rect {
    
    if( self.normalImageName && [self.normalImageName length] > 0 ) {
        return;
    }
    
    if( self.bNotUse == YES ) {
        return;
    }
    
    CGFloat span = self.arrowSpan;;
    CGRect drawRect = CGRectMake(span, span, rect.size.width - span*2.0, rect.size.height - span*2.0);
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    if( self.arrowWidth == -1 ) {
        arrowPath.lineWidth = drawRect.size.width * 0.13;
    } else {
        arrowPath.lineWidth = self.arrowWidth;
    }
    
    
    
    [arrowPath moveToPoint:CGPointMake(drawRect.origin.x + drawRect.size.width * 0.7, drawRect.origin.y + drawRect.size.height * 0.1)];
    [arrowPath addLineToPoint:CGPointMake(drawRect.origin.x + drawRect.size.width * 0.3, drawRect.origin.y + drawRect.size.height*0.5)];
    [arrowPath addLineToPoint:CGPointMake(drawRect.origin.x + drawRect.size.width * 0.7, drawRect.origin.y + drawRect.size.height*0.9)];
    //[arrowPath closePath];
    
    [self.itemColor setStroke];
    [arrowPath stroke];
    
    
    
}

@end
