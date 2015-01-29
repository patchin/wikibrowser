//
//  ViewController.m
//  wikibrowser
//
//  Created by Patrick Chin on 2015-01-26.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import "ViewController.h"
#import "NSString+UrlEncodeForWiki.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "WikiSearch.h"

#define WIKI_URL_TEMPLATE @"http://en.wikipedia.org/wiki/%@"
#define PAGING_LABEL_TEMPLATE @"Page %i of %i"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    m_pageSize  = 10;
    m_srOffset  = 0;
    m_currPage  = 1;
    m_totalHits = 0;
    [m_pagingLabel setTitle:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    m_searchTerm = searchBar.text;

    // New search being performed so reset some vars.
    m_srOffset  = 0;
    m_currPage  = 1;
    m_totalHits = 0;
    
    // Dismiss keyboard.
    [searchBar endEditing:YES];
    
    [self performSearch];
}

//
// Send a search request to Wikipedia and process the results. Update the table view with the search results.
//
- (void)performSearch {
    
    [WikiSearch performSearch:[m_searchTerm urlEncodeForWiki] atOffset:m_srOffset
                withBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                    {
                        if (data.length > 0 && connectionError == nil)
                        {
                             NSDictionary *searchResult = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:0
                                                                                            error:NULL];
                             #ifdef DEBUG
                             NSLog(@"Got data: %@\n", searchResult);
                             #endif
                             
                             m_searchResults = [[searchResult objectForKey:@"query"] objectForKey:@"search"];
                             m_totalHits = [[[[searchResult objectForKey:@"query"] objectForKey:@"searchinfo"] objectForKey:@"totalhits"] intValue];
                             
                             NSString *strPageCaption;
                             
                             if (m_pageSize < m_totalHits) {
                                 int numPages = (m_totalHits + m_pageSize - 1) / m_pageSize; // ceil of m_totalHits/m_pageSize
                                 strPageCaption = [NSString stringWithFormat:PAGING_LABEL_TEMPLATE, m_currPage, numPages];
                             }
                             else {
                                 strPageCaption = @"All results.";
                             }
                             
                             [m_pagingLabel setTitle:strPageCaption];
                             
                             // this block is being performed on the main thread so the following
                             // call is safe
                             [self hideActivityViewer];
                             
                             [m_tableView reloadData];
                         }
                    }];
   
    // Show activity indicator.
    // Previous call is to async method so it returns immediately.
    // Now on main thread we show activity indicator.
    // When results arrive, callback block will execute on main thread
    // and hide the activity indicator.
    [self showActivityViewer];
}

//
// Generate the Wikipedia url for an article given the title.
//
- (NSString *)getUrlFromTitle:(NSString *)title {
    NSString *entry = [title urlEncodeForWiki];
    NSString *strUrl = [NSString stringWithFormat:WIKI_URL_TEMPLATE, entry];
    return strUrl;
}

//
// Display the previous page of search results.
//
- (IBAction)onPrev:(id)sender {
    // No more previous pages.
    if (m_srOffset == 0) {
        return;
    }
    
    m_srOffset -= m_pageSize;
    m_currPage--;
    if (m_srOffset < 0) {
        m_srOffset = 0;
        m_currPage = 1;
    }
    
    // Perform search with the current search params.
    [self performSearch];
}

//
// Display the next page of search results.
//
- (IBAction)onNext:(id)sender {
    if (m_srOffset + m_pageSize < m_totalHits) {
        m_srOffset += m_pageSize;
        m_currPage++;
        // Perform search with the current search params.
        [self performSearch];
    }
    // else - no more next pages
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    NSDictionary *searchEntry = [m_searchResults objectAtIndex:row];
    cell.textLabel.text = [searchEntry objectForKey:@"title"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *input = [searchEntry objectForKey:@"timestamp"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"]; //iso 8601 format
    NSDate *outputDate = [dateFormatter dateFromString:input];

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:NSDateFormatterFullStyle];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last edited: %@",[outputFormatter stringFromDate:outputDate]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSDictionary *searchEntry = [m_searchResults objectAtIndex:row];
    NSString *strUrl = [self getUrlFromTitle:[searchEntry objectForKey:@"title"]];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    WebViewController *controller = (WebViewController *)[storyboard instantiateViewControllerWithIdentifier:@"webvc"];
    [controller setUrl:url];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Activity Indicator

- (void)showActivityViewer {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = delegate.window;
    m_activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    m_activityView.backgroundColor = [UIColor blackColor];
    m_activityView.alpha = 0.5;
    
    UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(window.bounds.size.width / 2 - 12, window.bounds.size.height / 2 - 12, 24, 24)];
    activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    [m_activityView addSubview:activityWheel];
    [window addSubview: m_activityView];
    
    [[[m_activityView subviews] objectAtIndex:0] startAnimating];
}

- (void)hideActivityViewer {
    [[[m_activityView subviews] objectAtIndex:0] stopAnimating];
    [m_activityView removeFromSuperview];
    m_activityView = nil;
}

@end
