//
//  EbayPriceCalculator.m
//  Price Advice
//
//  Created by Tullie Murrell on 20/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "EbayPriceCalculator.h"
#import "EbayHelper.h"
#import "XMLDictionary.h"

@interface EbayPriceCalculator()

@end

@implementation EbayPriceCalculator

#pragma mark - Fetching Ebay Items

- (void)fetchListings:(NSString *)keyword;
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    dispatch_queue_t otherQ = dispatch_queue_create("otherQueue", NULL);
    dispatch_async(otherQ, ^{
        
        //Parse XML to NSDictionaries
        NSData *XML = [NSData dataWithContentsOfURL:[EbayHelper getEbayFetchURL:keyword maxPrice:self.maxPriceSetting minPrice:self.minPriceSetting]];
        NSError *error = nil;
        NSDictionary *searchDetails = [NSDictionary dictionaryWithXMLData:XML];
        if (error){
            NSLog(@"Error parsing XML");
        }
        NSDictionary *searchResult = searchDetails[@"searchResult"];
        NSDictionary *itemList = searchResult[@"item"];
        
        BOOL itemsFound;
        if (![itemList count]){
            itemList = nil;
            itemsFound = NO;
        }
        else {
            itemsFound = YES;
        }
        
        NSArray *priceList = [self convertEbayItemListToPriceList:itemList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.priceList = priceList;
        });
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotification:[NSNotification notificationWithName:@"EbayResultsNotification" object:[NSNumber numberWithBool:itemsFound]]];
        
    });
}

- (NSArray *)convertEbayItemListToPriceList:(NSDictionary *)ebayItemList
{
    NSMutableArray *ebayPriceList = [[NSMutableArray alloc] init];
    NSMutableArray *ebayItemNameList = [[NSMutableArray alloc] init];
    NSMutableArray *ebayItemThumbnail = [[NSMutableArray alloc] init];
    NSMutableArray *ebayItemSubtitle = [[NSMutableArray alloc] init];
    NSMutableArray *ebayItemURL = [[NSMutableArray alloc] init];
    
    if (ebayItemList){
        for (NSDictionary *item in ebayItemList){
            item[@"title"] ? [ebayItemNameList addObject:item[@"title"]] : [ebayItemNameList addObject:@"unknown"]; // Title
            item[@"subtitle"] ? [ebayItemSubtitle addObject:item[@"subtitle"]] : [ebayItemSubtitle addObject:@""]; // Subtitle
            item[@"galleryURL"] ? [ebayItemThumbnail addObject:item[@"galleryURL"]] : [ebayItemThumbnail addObject:@""]; // Thumbnail
            item[@"viewItemURL"] ? [ebayItemURL addObject:item[@"viewItemURL"]] : [ebayItemURL addObject:@""]; // Item URL
            
            //Price
            NSDictionary *sellingStatus = item[@"sellingStatus"];
            NSDictionary *convertedPrice = sellingStatus[@"convertedCurrentPrice"];
            NSNumber *priceFloat = [[NSNumber alloc] initWithFloat:[convertedPrice[@"__text"] floatValue]];
            [ebayPriceList addObject:priceFloat];
            
            //NSLog (@"Item Price: %f, Item title: %@", [priceFloat floatValue], item[@"title"]);
        }
        
        self.itemSubtitle = ebayItemSubtitle;
        self.itemTitle = ebayItemNameList;
        self.itemThumbnail = ebayItemThumbnail;
        self.itemURL = ebayItemURL;
    }
    else {
        return nil;
    }
    
    return ebayPriceList;
}

@end
