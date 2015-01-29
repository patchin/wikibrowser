//
//  NSString+UrlEncode.h
//  wikibrowser
//
//  Category that adds a method to NSString to return
//  a url-encoded version of the string.
//
//  Created by Patrick Chin on 2015-01-26.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_UrlEncodeForWiki)

// Returns a url-encoded version of the string with
// one difference: space is replaced by underscore ('_').
// This is specifically for wikipedia urls.
- (NSString *)urlEncodeForWiki;

@end
