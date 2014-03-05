//
//  AmazonHelper.m
//  Price Advice
//
//  Created by Tullie Murrell on 13/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "AmazonHelper.h"
#import "NSString+URLEncoder.h"
#import "AmazonAuthUtils.h"
#import "DTBase64Coding.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation AmazonHelper

#define AMAZON_PUBLIC_KEY @"" 
#define AMAZON_SECRET_KEY @""
#define EBAY_ENTRIES_PER_PAGE 20

+ (NSURL *)getAmazonItemsURL:(NSString *)keyword
{
    NSString *accessKey = AMAZON_PUBLIC_KEY;
    NSString *secretKey = AMAZON_SECRET_KEY;
    
    NSString *verb = @"GET";
    NSString *hostName = @"webservices.amazon.com";
    NSString *path = @"/onca/xml";
    
    NSString *keywordQuery = [keyword stringForHTTPRequest];
    
    NSDictionary *params = @{@"Service": @"AWSECommerceService",
                             @"AWSAccessKeyId": accessKey,
                             @"Operation": @"ItemSearch",
                             @"Keywords": keywordQuery,
                             @"ResponseGroup": @"Offers,ItemAttributes",
                             @"SearchIndex": @"All",
                             @"Sort": @"rank",
                             @"AssociateTag": @"tag"};
    
    // Add time stamp
    NSDateFormatter *UTCFormatter = [[NSDateFormatter alloc] init];
    UTCFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    UTCFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSString *timeStamp = [UTCFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *tmpParams = [params mutableCopy];
    [tmpParams setObject:timeStamp forKey:@"Timestamp"];
    
    NSMutableString *paramString = [NSMutableString string];
    NSArray *sortedKeys = [[tmpParams allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [sortedKeys enumerateObjectsUsingBlock:^(NSString *oneKey, NSUInteger idx, BOOL *stop) {
    
    if (idx)
        {
            [paramString appendString:@"&"];
        }
        
        [paramString appendString:oneKey];
        [paramString appendString:@"="];
        
        NSString *value = [tmpParams objectForKey:oneKey];
        [paramString appendString:[value stringForHTTPRequest]];
    }];
    
    // create canonical string for signing
    NSMutableString *canonicalString = [NSMutableString string];
    
    [canonicalString appendString:verb];
    [canonicalString appendString:@"\n"];
    [canonicalString appendString:hostName];
    [canonicalString appendString:@"\n"];
    [canonicalString appendString:path];
    [canonicalString appendString:@"\n"];
    
    [canonicalString appendString:paramString];
    
    // create HMAC with SHA256
    const char *cKey  = [secretKey cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [canonicalString cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *hashData = [NSData dataWithBytes:cHMAC length:CC_SHA256_DIGEST_LENGTH];
    NSString *signature = [[DTBase64Coding stringByEncodingData:hashData] stringForHTTPRequest];
    
    // create URL String
    NSMutableString *urlString = [NSMutableString string];
    
    [urlString appendString:@"http://"];
    [urlString appendString:hostName];
    [urlString appendString:path];
    [urlString appendString:@"?"];
    [urlString appendString:paramString];
    
    [urlString appendFormat:@"&Signature=%@", signature];
    
    NSLog(@"%@",urlString);
    NSURL *urlCall = [[NSURL alloc] initWithString:urlString];
    return urlCall;
}
                                                    
@end
