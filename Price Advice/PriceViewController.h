//
//  PriceViewController.h
//  Price Advice
//
//  Created by Tullie Murrell on 10/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EbayPriceCalculator.h"
#import "AmazonPriceCalculator.h"

@interface PriceViewController : UIViewController

@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) EbayPriceCalculator *priceCalculator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic) NSInteger maxPriceSetting;
@property (nonatomic) NSInteger minPriceSetting;

@end
