//
//  WebViewController.h
//  wikibrowser
//
//  ViewController that displays a full-screen UIWebView.
//  The UIWebView is used to display Wikipedia articles.
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

// Set the url the UIWebView will display.
- (void)setUrl:(NSURL *)url;

// Dismiss the web view controller and return to the search page.
- (IBAction)backToSearchPage:(id)sender;

@end
