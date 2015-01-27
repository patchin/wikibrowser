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

// TODO: No results message.
// TODO: Progress indicator.
// TODO: Paging.
// TODO: Fancier dates (n days ago, n hours ago)
// TODO: Unit testing.

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    m_pageSize = 10;
    m_srOffset = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    m_searchTerm = searchBar.text;

    // Dismiss keyboard.
    [searchBar endEditing:YES];
    
    [self performSearch];
}

- (void)performSearch {
    // Perform wiki search with the string.
    
    NSString *strFormat = @"http://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=%@&srprop=timestamp&format=json&sroffset=%i";
    NSString *strUrl = [NSString stringWithFormat:strFormat, [m_searchTerm urlEncodeForWiki], m_srOffset];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
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
             //m_sroffset = [[[[searchResult objectForKey:@"query-continue"] objectForKey:@"search"] objectForKey:@"sroffset"] integerValue];
             m_totalPages = [[[[searchResult objectForKey:@"query"] objectForKey:@"searchinfo"] objectForKey:@"totalhits"] integerValue];
             [m_tableView reloadData];
         }
     }];
}

- (NSString *)getUrlFromTitle:(NSString *)title
{
    NSString *entry = [title urlEncodeForWiki];
    NSString *strUrl = [NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", entry];
    return strUrl;
}

- (IBAction)onPrev:(id)sender
{
    m_srOffset -= m_pageSize;
    if (m_srOffset < 0) {
        m_srOffset = 0;
    }
    
    // Perform search with the current search term.
    [self performSearch];
}

- (IBAction)onNext:(id)sender
{
    m_srOffset += m_pageSize;
    if (m_srOffset > m_totalPages) {
        m_srOffset = m_totalPages - m_pageSize;
    }
    
    // Perform search with the current search term.
    [self performSearch];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSDictionary *searchEntry = [m_searchResults objectAtIndex:row];
    NSString *strUrl = [self getUrlFromTitle:[searchEntry objectForKey:@"title"]];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    WebViewController *controller = (WebViewController *)[storyboard instantiateViewControllerWithIdentifier:@"webvc"];
    [controller setUrl:url];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
