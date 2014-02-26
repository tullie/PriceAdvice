//
//  DetailedAdviceViewController.m
//  Price Advice
//
//  Created by Tullie Murrell on 10/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "DetailedAdviceViewController.h"
#import "KeywordListViewController.h"
#import "ItemDetailViewController.h"


@interface DetailedAdviceViewController ()
@property (strong, nonatomic) IBOutlet UILabel *averagePriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *minPriceLabel;

@property (nonatomic) float maxPrice;
@property (nonatomic) float minPrice;
@property (nonatomic) float averagePrice;

@property (strong, nonatomic) IBOutlet UIView *whiteBoxWrapper;
@property (strong, nonatomic) IBOutlet UILabel *noPriceAvailable;

@end

@implementation DetailedAdviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // White box
    self.whiteBoxWrapper.layer.cornerRadius = 5;
    
    [self updateUI];
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"EbayResultsNotification"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      UIApplication* app = [UIApplication sharedApplication];
                                                      app.networkActivityIndicatorVisible = NO;
                                                      
                                                      if ([(NSNumber *)note.object boolValue]){
                                                          [self dataLoaded];
                                                      }
                                                      else {
                                                          [self dataNotFound];
                                                      }
                                                  }];
}

- (void)dataLoaded
{
    NSArray *subviews = self.whiteBoxWrapper.subviews;
    for (UIView *view in subviews){
        view.hidden = NO;
    }
    [self.activityIndicator stopAnimating];
    self.noPriceAvailable.hidden = YES;
    [self updateUI];
}

- (void)dataNotFound
{
    [self.activityIndicator stopAnimating];
    self.noPriceAvailable.hidden = NO;
}

- (IBAction)backButton:(UIButton *)sender
{
    if (self.splitViewController) {
        UINavigationController *uinc = [self.splitViewController.viewControllers firstObject];
        [uinc popViewControllerAnimated:YES];
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)itemListButton:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"Display Item List" sender:sender];
}

- (void)setMinPrice:(float)minPrice
{
    _minPrice = minPrice;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumber *price = [NSNumber numberWithFloat:minPrice];
    self.minPriceLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:price]];
}

- (void)setMaxPrice:(float)maxPrice
{
    _maxPrice = maxPrice;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumber *price = [NSNumber numberWithFloat:maxPrice];
    self.maxPriceLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:price]];
}

- (void)setAveragePrice:(float)averagePrice
{
    _averagePrice = averagePrice;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumber *price = [NSNumber numberWithFloat:averagePrice];
    self.averagePriceLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:price]];
}

- (void)updateUI
{
    self.maxPrice = [self.priceCalculator maxPrice];
    self.minPrice = [self.priceCalculator minPrice];
    self.averagePrice = [self.priceCalculator averagePrice];
    
    if (self.splitViewController){
        UINavigationController *uinc = [self.splitViewController.viewControllers firstObject];
        KeywordListViewController *klvc = (KeywordListViewController *)uinc.visibleViewController;
        klvc.keyword = self.searchText;
        klvc.priceCalculator = self.priceCalculator;
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[KeywordListViewController class]]) {
        KeywordListViewController *klvc = (KeywordListViewController *)[segue destinationViewController];
        klvc.priceCalculator = self.priceCalculator;
        klvc.keyword = self.searchText;
    }
    if ([[segue destinationViewController] isKindOfClass:[ItemDetailViewController class]]) {
        if ([sender isKindOfClass:[NSIndexPath class] ]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            ItemDetailViewController *idvc = (ItemDetailViewController *)[segue destinationViewController];
            [self prepareItemDetailController:indexPath controller:idvc];
        }
    }
}

- (void)prepareItemDetailController:(NSIndexPath *)indexPath controller:(ItemDetailViewController *)idvc
{
    NSURL *selectedItemURL = [[NSURL alloc] initWithString:self.priceCalculator.itemURL[indexPath.row]];
    idvc.itemURL = selectedItemURL;
    idvc.itemName = self.priceCalculator.itemTitle[indexPath.row];
}


@end
