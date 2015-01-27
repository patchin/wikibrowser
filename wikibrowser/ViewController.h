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
    NSArray *m_searchResults;
}

@end

