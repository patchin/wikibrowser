//
//  wikibrowserTests.m
//  wikibrowserTests
//
//  Created by Patrick Chin on 2015-01-26.
//  Copyright (c) 2015 PatCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+UrlEncodeForWiki.h"
#import "WikiSearch.h"

@interface wikibrowserTests : XCTestCase

@end

@implementation wikibrowserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUrlEncodeForWiki {
    NSString *strTitle;
    NSString *strResult;
    
    strTitle = @"Batman";
    strResult = [strTitle urlEncodeForWiki];
    XCTAssertTrue([strResult isEqualToString:@"Batman"]);
    
    strTitle = @"Gotham City";
    strResult = [strTitle urlEncodeForWiki];
    XCTAssertTrue([strResult isEqualToString:@"Gotham_City"]);
    
    strTitle = @"Airplane!";
    strResult = [strTitle urlEncodeForWiki];
    XCTAssertTrue([strResult isEqualToString:@"Airplane%21"]);
    
    strTitle = @"ben and jerry's";
    strResult = [strTitle urlEncodeForWiki];
    XCTAssertTrue([strResult isEqualToString:@"ben_and_jerry%27s"]);
}

- (void)testPerformSearch {
    
    XCTestExpectation *searchExpectation = [self expectationWithDescription:@"download search results"];
    
    [WikiSearch performSearch:[@"gotham city" urlEncodeForWiki] atOffset:0
                    withBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                    {
                        NSDictionary *searchResult = [NSJSONSerialization JSONObjectWithData:data
                                                                                     options:0
                                                                                       error:NULL];
                        
                        int totalHits = [[[[searchResult objectForKey:@"query"] objectForKey:@"searchinfo"] objectForKey:@"totalhits"] intValue];
                        
                        XCTAssert(connectionError == nil);
                        XCTAssert(totalHits > 0);
                        
                        // Fulfill the expectation-this will cause -waitForExpectation
                        // to invoke its completion handler and then return.
                        [searchExpectation fulfill];
                    }];
    
    // The test will pause here, running the run loop, until the timeout is hit
    // or all expectations are fulfilled.
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        // do nothing
    }];
}

@end
