//
//  AmazonPriceCalculator.m
//  Price Advice
//
//  Created by Tullie Murrell on 20/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "AmazonPriceCalculator.h"
#import "AmazonHelper.h"
#import "XMLDictionary.h"

@implementation AmazonPriceCalculator

#pragma mark - fetching Amazon items

- (void)fetchListings:(NSString *)keyword;
{
    dispatch_queue_t otherQ = dispatch_queue_create("otherQueue", NULL);
    dispatch_async(otherQ, ^{
        
        //Parse XML to NSDictionaries
        NSData *XML = [NSData dataWithContentsOfURL:[AmazonHelper getAmazonItemsURL:keyword]];
        NSError *error = nil;
        NSDictionary *searchDetails = [NSDictionary dictionaryWithXMLData:XML];
        if (error){
            NSLog(@"Error parsing XML");
        }
        
        NSDictionary *searchResults = searchDetails[@"Items"];
        NSDictionary *itemList = searchResults[@"Item"];
        
        BOOL itemsFound;
        if (![itemList count]){
            itemList = nil;
            itemsFound = NO;
            NSLog(@"No items found");
        }
        else {
            itemsFound = YES;
        }
        
        NSArray *priceList = [self convertAmazonItemListToPriceList:itemList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.priceList = priceList;
        });
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotification:[NSNotification notificationWithName:@"EbayResultsNotification" object:[NSNumber numberWithBool:itemsFound]]];
        
    });
}

- (NSArray *)convertAmazonItemListToPriceList:(NSDictionary *)itemList
{
    NSMutableArray *amazonPriceList = [[NSMutableArray alloc] init];
    NSMutableArray *amazonItemNameList = [[NSMutableArray alloc] init];
    
    
    if (itemList){
        for (NSDictionary *item in itemList){
            NSDictionary *itemAttributes = item[@"ItemAttributes"];
            
            if (itemAttributes[@"Title"]){
                [amazonItemNameList addObject:itemAttributes[@"Title"]];
            }
            
            NSDictionary *listPrice = itemAttributes[@"ListPrice"];
            NSDictionary *convertedPrice = listPrice[@"FormattedPrice"];
            if (convertedPrice){
                [amazonPriceList addObject:convertedPrice];
            }
        }
        NSLog (@"Item Price: %@", amazonPriceList);
        NSLog (@"Item title: %@", amazonItemNameList);
        
    }
    else {
        return nil;
    }
    
    return amazonPriceList;
}

@end
