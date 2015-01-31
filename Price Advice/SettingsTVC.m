//
//  SettingsTVC.m
//  Price Advice
//
//  Created by Tullie Murrell on 22/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "SettingsTVC.h"
#import "EbayHelper.h"
#import "NMRangeSlider.h"
#import "MathFunctions.h"


@interface SettingsTVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableViewCell *sliderCell;

@property (weak, nonatomic) IBOutlet NMRangeSlider *standardSlider;
@property (strong, nonatomic) IBOutlet UILabel *minPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxPriceLabel;

@end

#define SLIDE_SCALE 10
#define MAXIMUM_VALUE 10000

@implementation SettingsTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureSlider];
    [self updateSliderLabels];

}

#pragma mark - Range Slider

- (void)configureSlider
{
    self.standardSlider.minimumValue = 0;
    self.standardSlider.maximumValue = (float)[MathFunctions logToBase:SLIDE_SCALE value:MAXIMUM_VALUE];
    self.standardSlider.lowerValue = (float)[MathFunctions logToBase:SLIDE_SCALE value:self.minPrice];
    self.standardSlider.upperValue = (float)[MathFunctions logToBase:SLIDE_SCALE value:self.maxPrice];
}

- (IBAction)sliderUpdate:(NMRangeSlider *)sender
{
    [self updateSliderLabels];
}

- (void)updateSliderLabels
{
    if (!self.standardSlider.lowerValue) {
     self.minPrice = 0;
    }
    else {
        self.minPrice = powf(SLIDE_SCALE,self.standardSlider.lowerValue);
    }
    self.maxPrice = powf(SLIDE_SCALE,self.standardSlider.upperValue);
}

- (void)setMinPrice:(NSInteger)minPrice
{
    _minPrice = minPrice;
    self.minPriceLabel.text = [NSString stringWithFormat:@"$%ld", (long)minPrice];
}

- (void)setMaxPrice:(NSInteger)maxPrice
{
    _maxPrice = maxPrice;
    self.maxPriceLabel.text = [NSString stringWithFormat:@"$%ld",(long)maxPrice];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell *cell;
    switch (section) {
        case 0:
            cell = self.sliderCell;
            break;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 25, 320, 20);
    myLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

@end
