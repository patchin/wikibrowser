//
//  WikiSearch.h
//  wikibrowser
//
//  Created by Patrick Chin on 2015-01-27.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikiSearch : NSObject

+ (void)performSearch:(NSString *)strSearchTerm
             atOffset:(int)srOffset
            withBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler;

@end
