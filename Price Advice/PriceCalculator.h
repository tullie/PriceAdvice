//
//  PriceCalculator.h
//  Price Advice
//
//  Created by Tullie Murrell on 10/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceCalculator : NSObject

- (void)fetchListings:(NSString *)keyword;

- (float)averagePrice;
- (float)maxPrice;
- (float)minPrice;

@property (strong, nonatomic) NSArray *priceList;

@property (nonatomic) NSInteger maxPriceSetting;
@property (nonatomic) NSInteger minPriceSetting;

@end
