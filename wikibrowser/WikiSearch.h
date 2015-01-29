//
//  WikiSearch.h
//  wikibrowser
//
//  Performs a search on Wikipedia articles with the results
//  processed by a passed-in block.
//
//  Created by Patrick Chin on 2015-01-27.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikiSearch : NSObject

//
// Performs a search for Wikipedia articles which match strSearchTerm.
//   strSearchTerm must be url-encoded.
//   srOffset dictates the start of the search results, how many results to skip over
//   data is the search results returned, use the following to convert into an NSDictionary:
//       [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//
+ (void)performSearch:(NSString *)strSearchTerm
             atOffset:(int)srOffset
            withBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler;

@end
