//
//  EbayHelper.m
//  Price Advice
//
//  Created by Tullie Murrell on 10/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "EbayHelper.h"
#import "NSString+URLEncoder.h"

@interface EbayHelper()
@end

@implementation EbayHelper

#define EBAY_PRODUCTION_KEY @""
#define EBAY_ENTRIES_PER_PAGE 25

+ (NSURL *)getEbayFetchURL:(NSString *)keyword maxPrice:(NSInteger)maxPrice minPrice:(NSInteger)minPrice
{    
    //Get current country code
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    // API request variables
    NSString *query = keyword;
    NSString *endpoint = @"http://svcs.ebay.com/services/search/FindingService/v1";  // URL to call
    NSString *version = @"1.0.0";  // API version supported by your application
    NSString *appid = EBAY_PRODUCTION_KEY;
    NSString *globalid = [NSString stringWithFormat:@"EBAY-%@",countryCode];  // Global ID of the eBay site
    NSString *encodedQuery = [query stringForHTTPRequest];  // Make the query URL-friendly
    NSString *entries = [NSString stringWithFormat:@"%d",EBAY_ENTRIES_PER_PAGE];
    
    //Max and min price filters
    NSString *maxFilter = [NSString stringWithFormat:@"itemFilter(1).name=MaxPrice&itemFilter(1).value=%ld", (long)maxPrice];
    NSString *minFilter = [NSString stringWithFormat:@"itemFilter(2).name=MinPrice&itemFilter(2).value=%ld", (long)minPrice];
    
    // Construct the findItemsByKeywords HTTP GET call
    NSURL *callURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=%@&SECURITY-APPNAME=%@&GLOBAL-ID=%@&keywords=%@&paginationInput.entriesPerPage=%@&itemFilter(0).name=ListingType&itemFilter(0).value=FixedPrice&%@&%@",endpoint, version, appid, globalid, encodedQuery, entries, maxFilter, minFilter]];
 
    return callURL;
}

+ (NSDictionary *)ebayCategoryIDs
{
    // Not complete
    NSDictionary *IDs = @{@"All" : @0,
                          @"Antiques" : @20081,
                          @"Art" : @550
                          };
    
    return IDs;
}

@end

