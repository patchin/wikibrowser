//
//  WebViewController.h
//  wikibrowser
//
//  Created by Patrick Chin on 2015-01-26.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *m_webView;
    NSURL *m_url;
}

- (void)setUrl:(NSURL *)url;
- (IBAction)backToSearchPage:(id)sender;

@end
