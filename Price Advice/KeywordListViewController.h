//
//  KeywordListViewController.h
//  Price Advice
//
//  Created by Tullie Murrell on 23/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EbayPriceCalculator.h"

@interface KeywordListViewController : UIViewController

@property (nonatomic, strong) EbayPriceCalculator *priceCalculator;
@property (nonatomic, strong) NSString *keyword;

@end
