//
//  itemListTableViewController.h
//  Price Advice
//
//  Created by Tullie Murrell on 13/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EbayPriceCalculator.h"

@interface ItemListTableViewController : UITableViewController

@property (nonatomic, strong) EbayPriceCalculator *priceCalculator;

@end
