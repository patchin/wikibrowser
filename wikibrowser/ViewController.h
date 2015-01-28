//
//  ViewController.h
//  wikibrowser
//
//  Created by Patrick Chin on 2015-01-26.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    IBOutlet UISearchBar *m_searchBar;
    IBOutlet UITableView *m_tableView;
    IBOutlet UIBarButtonItem *m_pagingLabel;
    IBOutlet UIBarButtonItem *m_prevButton;
    IBOutlet UIBarButtonItem *m_nextButton;
    
    NSArray *m_searchResults;
    NSInteger m_srOffset;
    int m_currPage;
    int m_pageSize;
    int m_totalHits;
    NSString *m_searchTerm;
    UIView *m_activityView;
}

- (IBAction)onPrev:(id)sender;
- (IBAction)onNext:(id)sender;

@end

