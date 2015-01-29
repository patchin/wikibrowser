//
//  WikiSearch.m
//  wikibrowser
//
//  Created by Patrick Chin on 2015-01-27.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import "WikiSearch.h"

#define SEARCH_STR_TEMPLATE @"http://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=%@&srprop=timestamp&format=json&sroffset=%i"

@implementation WikiSearch

+ (void)performSearch:(NSString *)strSearchTerm
             atOffset:(int)srOffset
            withBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler
{
    // Perform wiki search with the string.
    NSString *strFormat = SEARCH_STR_TEMPLATE;
    NSString *strUrl = [NSString stringWithFormat:strFormat, strSearchTerm, srOffset];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];
}

@end
