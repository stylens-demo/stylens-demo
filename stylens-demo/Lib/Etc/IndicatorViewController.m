//
//  IndicatorViewController.m
//  Vintique
//
//  Created by 기대 여 on 11. 3. 19..
//  Copyright 2011 Gidae Yeo. All rights reserved.
//

#import "IndicatorViewController.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation IndicatorViewController

@synthesize indicator;
@synthesize superView;


@synthesize bCustomized;
@synthesize customizedSize;

- (void)dealloc
{
    if( superView ) {
//        [superView release], superView = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [indicator release], indicator = nil;
//    [blackView release], blackView = nil;
//    [progressLabel release], progressLabel = nil;
    
//    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{

    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIView* aView = nil;
    
    
    
    aView = [[UIView alloc] initWithFrame:app.screenRect];
    
    aView.backgroundColor = [UIColor clearColor];
    self.view = aView;
//    [aView release], aView = nil;
    aView = nil;
    
    blackView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 80/2 + curCustomizedSize.width, self.view.frame.size.height/2-80/2 + curCustomizedSize.height, 80, 80)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.8;
    blackView.layer.cornerRadius = 12;
    blackView.layer.masksToBounds = YES;
    
    [self.view addSubview:blackView];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 80/2 + curCustomizedSize.width, self.view.frame.size.height/2 + 40/2 + 10 + curCustomizedSize.height, 80, 20)];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.adjustsFontSizeToFitWidth = YES;
    progressLabel.font = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:progressLabel];
    progressLabel.hidden = YES;
    

    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 40/2 + curCustomizedSize.width, self.view.frame.size.height/2 - 40/2 + curCustomizedSize.height, 40, 40)];
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[self.view addSubview:indicator];
    
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if( UIInterfaceOrientationIsLandscape( toInterfaceOrientation ) ) {
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            self.view.frame = CGRectMake(0, 0, 1024, 768);
        } else {
            self.view.frame = CGRectMake(0, 0, 480, 320);
        }
        
    } else {
        
        self.view.frame = app.screenRect;
        
	}
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    if( bShowProgress == YES ) {
        blackView.frame = CGRectMake(width/2 - 80/2 + curCustomizedSize.width, height/2-80/2 + curCustomizedSize.height, 80, 100);
    } else {
        blackView.frame = CGRectMake(width/2 - 80/2 + curCustomizedSize.width, height/2-80/2 + curCustomizedSize.height, 80, 80);
    }
    
    progressLabel.frame = CGRectMake(width/2 - 80/2 + curCustomizedSize.width, height/2+40/2 + 10 + curCustomizedSize.height, 80, 20);
    indicator.frame = CGRectMake(width/2 - 40/2 + curCustomizedSize.width, height/2 - 40/2 + curCustomizedSize.height, 40, 40);

}

-(void)showProgress:(NSNotification*)aNotification {
    [self setProgress:[(NSNumber*)[aNotification object] intValue]];
    
    
//    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
}

-(void)_setProgress:(NSNumber*)aProgressNumber {
    
    NSUInteger aProgress = [aProgressNumber intValue];
    bShowProgress = YES;
    
    progressLabel.hidden = NO;
    
//    progressLabel.text = [NSString stringWithFormat:@"%d%%", aProgress];
    
    [progressLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%lu%%", aProgress] waitUntilDone:YES];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat heigh = self.view.frame.size.height;
        
    blackView.frame = CGRectMake(width/2 - 80/2 + curCustomizedSize.width, heigh/2-100/2 + curCustomizedSize.height, 80, 100);
    progressLabel.frame = CGRectMake(width/2 - 80/2 + curCustomizedSize.width, heigh/2+40/2+ 5 + curCustomizedSize.height, 80, 20);
        
    
//    [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
}

-(void)setProgress:(NSUInteger)aProgress {
    [self performSelectorOnMainThread:@selector(_setProgress:) withObject:[NSNumber numberWithInt:(int)aProgress] waitUntilDone:YES];
}


-(void)_setProgressString:(NSString*)aProgress {
    
    bShowProgress = YES;
    
    progressLabel.hidden = NO;
    
    //    progressLabel.text = [NSString stringWithFormat:@"%d%%", aProgress];
    
    
    CGFloat strWidth = [Global textSize:aProgress Font:progressLabel.font].width;
    CGFloat startStrX = 10;
    CGFloat blackViewWidth;
    
    if( (strWidth + startStrX*2) > 80 ) {
        blackViewWidth = strWidth + startStrX*2;
    } else {
        blackViewWidth = 80;
    }
    
    [progressLabel performSelectorOnMainThread:@selector(setText:) withObject:aProgress waitUntilDone:YES];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat heigh = self.view.frame.size.height;
    
    
    blackView.frame = CGRectMake(width/2 - blackViewWidth/2 + curCustomizedSize.width, heigh/2-100/2 + curCustomizedSize.height, blackViewWidth, 100+10);
    progressLabel.frame = CGRectMake(width/2 - strWidth/2 + curCustomizedSize.width, heigh/2+40/2 + 5+ curCustomizedSize.height, strWidth, 20);
    indicator.frame = CGRectMake(width/2 - 40/2 + curCustomizedSize.width, heigh/2 - 40/2 + curCustomizedSize.height, 40, 40);
        
    
    
    //    [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
}

-(void)setProgressString:(NSString*)aProgress {
    [self performSelectorOnMainThread:@selector(_setProgressString:) withObject:aProgress waitUntilDone:YES];
}


-(void)startIndicator {
	self.view.hidden = NO;
    if( superView ) {
        [superView bringSubviewToFront:self.view];
    }
    
    CGFloat width = self.view.frame.size.width;
    CGFloat heigh = self.view.frame.size.height;
    

    blackView.frame = CGRectMake(width/2 - 80/2 + curCustomizedSize.width, heigh/2-80/2 + curCustomizedSize.height, 80, 80);
    progressLabel.frame = CGRectMake(width/2 - 80/2 + curCustomizedSize.width, heigh/2+40/2 + 10 + curCustomizedSize.height, 80, 20);
    
    indicator.frame = CGRectMake(width/2 - 40/2 + curCustomizedSize.width, heigh/2 - 40/2 + curCustomizedSize.height, 40, 40);
    
	[indicator startAnimating];
}

-(void)_stopIndicator {
	[indicator stopAnimating];
	self.view.hidden = YES;
    bShowProgress = NO;
    
    progressLabel.hidden = YES;
    
    CGFloat width = self.view.frame.size.width;
    CGFloat heigh = self.view.frame.size.height;

    blackView.frame = CGRectMake(width/2 - 80/2 + curCustomizedSize.width, heigh/2-80/2 + curCustomizedSize.height, 80, 80);
    progressLabel.frame = CGRectMake(width/2 - 80/2 + curCustomizedSize.width, heigh/2+40/2 + 10 + curCustomizedSize.height, 80, 20);
    
}

-(void)stopIndicator {
    [self performSelectorOnMainThread:@selector(_stopIndicator) withObject:nil waitUntilDone:YES];
}

-(void)setBCustomized:(BOOL)aFlag {
    
    bCustomized = aFlag;
    
    if( bCustomized == YES ) {
        curCustomizedSize = customizedSize;
    } else {
        curCustomizedSize = CGSizeZero;
    }
    
}


@end
