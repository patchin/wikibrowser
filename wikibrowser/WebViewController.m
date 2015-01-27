//
//  WebViewController.m
//  wikibrowser
//
//  Created by Patrick Chin on 2015-01-26.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:m_url];
    [m_webView setScalesPageToFit:YES];
    [m_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TODO: Replace with property?
- (void)setUrl:(NSURL *)url
{
    m_url = url;
}

- (IBAction)backToSearchPage:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        // do nothing
    }];
}

@end
