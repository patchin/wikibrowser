//
//  NSString+UrlEncode.m
//  wikibrowser
//
//  Created by Patrick Chin on 2015-01-26.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import "NSString+UrlEncodeForWiki.h"

@implementation NSString (NSString_UrlEncodeForWiki)

// Modified form of URLEncode.
// Turns spaces into '_'.

- (NSString *)urlEncodeForWiki {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"_"]; // for wiki titles the space is replaced with '_' to yield url
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end
