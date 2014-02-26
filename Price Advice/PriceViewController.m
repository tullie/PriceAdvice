//
//  PriceViewController.m
//  Price Advice
//
//  Created by Tullie Murrell on 10/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "PriceViewController.h"
#import "KeywordListViewController.h"

@interface PriceViewController ()
@property (strong, nonatomic) IBOutlet UILabel *itemLabel;

@end

@implementation PriceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateLabel];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.splitViewController setPresentsWithGesture:NO];

}

- (void)updateLabel
{
    self.itemLabel.text = [NSString stringWithFormat:@"%@",self.searchText];
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    [self.priceCalculator fetchListings:self.searchText];
    [self updateLabel];
}

- (EbayPriceCalculator *)priceCalculator
{
    if (!_priceCalculator){
        _priceCalculator = [[EbayPriceCalculator alloc] init];
        _priceCalculator.maxPriceSetting = self.maxPriceSetting;
        _priceCalculator.minPriceSetting = self.minPriceSetting;
    }
    return _priceCalculator;
}
@end
