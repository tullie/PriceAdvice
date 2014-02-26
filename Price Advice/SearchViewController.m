//
//  SearchViewController.m
//  Price Advice
//
//  Created by Tullie Murrell on 10/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "SearchViewController.h"
#import "PriceViewController.h"
#import "Colours.h"
#import "InfomationViewController.h"
#import "SettingsTVC.h"
#import "KeywordListViewController.h"

@interface SearchViewController () <UITextFieldDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic) BOOL hideMaster;
@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup
    self.minPrice = 0;
    self.maxPrice = 10000;
    [self setupUI];
}

- (void)setupUI
{
    // Search Button
    self.searchButton.layer.cornerRadius = 5;
    
    // Search field
    self.searchTextField.adjustsFontSizeToFitWidth = YES;
    self.searchTextField.minimumFontSize = 8;
    self.searchTextField.delegate = self;
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    //Toolbar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];

}

- (IBAction)searchButton:(UIButton *)sender
{
    if (self.splitViewController){
        UINavigationController *uinc = [self.splitViewController.viewControllers firstObject];
        InfomationViewController *ivc = (InfomationViewController *)uinc.topViewController;
        self.minPrice = ivc.minPrice;
        self.maxPrice = ivc.maxPrice;
        [self performSegueWithIdentifier:@"Replace Master With Keyword List" sender:sender];
    }
    [self performSegueWithIdentifier:@"Display Detailed Results" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[PriceViewController class]]){
        PriceViewController *pvc = (PriceViewController *)[segue destinationViewController];
        pvc.maxPriceSetting = self.maxPrice; // MaxPriceSetting and minPrice setting Must be set before searchText
        pvc.minPriceSetting = self.minPrice;
        pvc.searchText = self.searchTextField.text;
    }
    if ([[segue destinationViewController] isKindOfClass:[InfomationViewController class]]){
        InfomationViewController *ivc = (InfomationViewController *)[segue destinationViewController];
        ivc.maxPrice = self.maxPrice;
        ivc.minPrice = self.minPrice;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchTextField) {
        [textField resignFirstResponder];
        //[self performSegueWithIdentifier:@"Display Detailed Results" sender:textField];
        return YES;
    }
    return YES;
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[InfomationViewController class]]){
        InfomationViewController *ivc = (InfomationViewController *)segue.sourceViewController;
        self.maxPrice = ivc.maxPrice;
        self.minPrice = ivc.minPrice;
    }
}

#pragma mark - Split view

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    UINavigationController* slaveNavigationViewController = svc.viewControllers[1];
    UIViewController* slaveViewController = slaveNavigationViewController.viewControllers[0];
    [barButtonItem setTitle:@"Settings"];
    barButtonItem.tintColor = [UIColor whiteColor];
    slaveViewController.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
}

@end
