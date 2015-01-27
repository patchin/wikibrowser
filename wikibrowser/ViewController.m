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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;

    // Perform wiki search with the string.

    NSString *strFormat = @"http://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=%@&srprop=timestamp&format=json";
    NSString *strUrl = [NSString stringWithFormat:strFormat, [searchTerm urlEncodeForWiki]];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             //self.greetingId.text = [[greeting objectForKey:@"id"] stringValue];
             //self.greetingContent.text = [greeting objectForKey:@"content"];
             NSLog(@"Got data.\n");
             
             m_searchResults = [[greeting objectForKey:@"query"] objectForKey:@"search"];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    NSDictionary *searchEntry = [m_searchResults objectAtIndex:row];
    cell.textLabel.text = [searchEntry objectForKey:@"title"];
    cell.detailTextLabel.text = [searchEntry objectForKey:@"timestamp"];
    
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
