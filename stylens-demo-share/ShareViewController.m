//
//  ShareViewController.m
//  stylens-demo-share
//
//  Created by 김대섭 on 2017. 12. 28..
//  Copyright © 2017년 Bluehack Inc. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        for (NSItemProvider* itemProvider in ((NSExtensionItem*)self.extensionContext.inputItems[0]).attachments ) {
    
            if([itemProvider hasItemConformingToTypeIdentifier:@"public.jpeg"]) {
                NSLog(@"itemprovider = %@", itemProvider);
    
                [itemProvider loadItemForTypeIdentifier:@"public.jpeg" options:nil completionHandler: ^(id<NSSecureCoding> item, NSError *error) {
    
                    NSData *imgData;
                    if([(NSObject*)item isKindOfClass:[NSURL class]]) {
                        imgData = [NSData dataWithContentsOfURL:(NSURL*)item];
                    }
                    if([(NSObject*)item isKindOfClass:[UIImage class]]) {
                        imgData = UIImagePNGRepresentation((UIImage*)item);
                    }
    
                    NSDictionary *dict = @{
                                           @"imgData" : imgData,
                                           @"name" : self.contentText
                                           };
                    NSUserDefaults *defauls = [[NSUserDefaults alloc] initWithSuiteName:@"group.stylens.share.extension"];
                    [defauls setObject:dict forKey:@"img"];
                    [defauls synchronize];
                }];
            }
        }
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
