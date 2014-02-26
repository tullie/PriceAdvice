//
//  itemListTableViewController.m
//  Price Advice
//
//  Created by Tullie Murrell on 13/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "ItemListTableViewController.h"
#import "ItemTableViewCell.h"
#import "ItemDetailViewController.h"
#import "DetailedAdviceViewController.h"

@interface ItemListTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray *savedThumbnails;

@end

@implementation ItemListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setPriceCalculator:(EbayPriceCalculator *)priceCalculator
{
    _priceCalculator = priceCalculator;
    [self.tableView reloadData];
}

- (NSMutableArray *)savedThumbnails
{
    if (!_savedThumbnails){
        _savedThumbnails = [[NSMutableArray alloc] initWithArray:self.priceCalculator.itemThumbnail];
    }
    return _savedThumbnails;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.priceCalculator.itemTitle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Item Cell";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    // Configure the cell...
    NSString *title = [self.priceCalculator.itemTitle objectAtIndex:indexPath.row];
    title ? cell.titleLabel.text = title : @"Unknown";
    
    NSNumber *itemPrice = [self.priceCalculator.priceList objectAtIndex:indexPath.row];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    cell.priceLabel.text = [formatter stringFromNumber:itemPrice];
    
    // Thumnail
    NSURL *thumbnailURL =  [NSURL URLWithString:[self.priceCalculator.itemThumbnail objectAtIndex:indexPath.row]];
    if (![self.savedThumbnails[indexPath.row] isKindOfClass:[UIImage class]]){
        dispatch_queue_t q = dispatch_queue_create("thumbnail download queue", 0);
        dispatch_async(q, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:thumbnailURL];
            UIImage *thumbnail = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.savedThumbnails[indexPath.row] = thumbnail;
                cell.thumbnail.image = thumbnail;
                [cell setNeedsLayout];
            });
        });
    } else {
        cell.thumbnail.image = self.savedThumbnails[indexPath.row];
        [cell setNeedsDisplay];
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.splitViewController){
        UINavigationController *uinc = [self.splitViewController.viewControllers lastObject];
        if ([uinc.visibleViewController isKindOfClass:[DetailedAdviceViewController class]]) {
            DetailedAdviceViewController *davc = (DetailedAdviceViewController *)uinc.visibleViewController;
            [davc performSegueWithIdentifier:@"Display Item Details" sender:indexPath]; // Send row number
        }
        else if ([uinc.visibleViewController isKindOfClass:[ItemDetailViewController class]]) {
            ItemDetailViewController *idvc = (ItemDetailViewController *)uinc.visibleViewController;
            [self prepareItemDetailController:indexPath controller:idvc];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[ItemDetailViewController class]]){
        ItemDetailViewController *idvc = (ItemDetailViewController *)[segue destinationViewController];
        UITableViewCell *selectedCell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
        [self prepareItemDetailController:indexPath controller:idvc];
    }
}

- (void)prepareItemDetailController:(NSIndexPath *)indexPath controller:(ItemDetailViewController *)idvc
{
    NSURL *selectedItemURL = [[NSURL alloc] initWithString:self.priceCalculator.itemURL[indexPath.row]];
    idvc.itemURL = selectedItemURL;
    idvc.itemName = self.priceCalculator.itemTitle[indexPath.row];
}


@end
