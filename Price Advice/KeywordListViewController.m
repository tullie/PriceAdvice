//
//  KeywordListViewController.m
//  Price Advice
//
//  Created by Tullie Murrell on 23/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "KeywordListViewController.h"
#import "ItemListTableViewController.h"

@interface KeywordListViewController ()
@property (strong, nonatomic) IBOutlet UILabel *keywordLabel;
@property (strong, nonatomic) ItemListTableViewController *itemList;
@end

@implementation KeywordListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self updateUI];
}

- (void)updateUI
{
    self.itemList.priceCalculator = self.priceCalculator;
    self.keywordLabel.text = self.keyword;
}

- (void)setPriceCalculator:(EbayPriceCalculator *)priceCalculator
{
    _priceCalculator = priceCalculator;
    [self updateUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[ItemListTableViewController class]]){
        ItemListTableViewController * iltvc = (ItemListTableViewController *) [segue destinationViewController];
        self.itemList = iltvc;
        iltvc.PriceCalculator = self.priceCalculator;
    }
}

- (IBAction)backButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

@end
