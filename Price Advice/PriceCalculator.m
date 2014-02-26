//
//  PriceCalculator.m
//  Price Advice
//
//  Created by Tullie Murrell on 10/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "PriceCalculator.h"


@interface PriceCalculator()
@end

@implementation PriceCalculator

- (void)fetchListings:(NSString *)keyword
{
    //Defined in subclass
}

#pragma mark - Price calculations

- (float)averagePrice
{
    float averagePrice = 0.00;
    if (self.priceList){
        float sum = 0;
        for (NSNumber *price in self.priceList){
            sum = sum + [price floatValue];
        }
        
        averagePrice = sum/[self.priceList count];
    }
    return averagePrice;
}

- (float)maxPrice
{
    float maxPrice = 0.00;
    if (self.priceList){
        maxPrice = [[self.priceList firstObject] floatValue];
        for (NSNumber *price in self.priceList){
            if ([price floatValue] > maxPrice){
                maxPrice = [price floatValue];
            }
        }
    }
    return maxPrice;
}

- (float)minPrice
{
    float minPrice = 0.00;
    if (self.priceList){
        minPrice = [[self.priceList firstObject] floatValue];
        for (NSNumber *price in self.priceList){
            if ([price floatValue] < minPrice){
                minPrice = [price floatValue];
            }
        }
    }
    return minPrice;
}

@end
