//
//  InfomationViewController.m
//  Price Advice
//
//  Created by Tullie Murrell on 14/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "InfomationViewController.h"
#import "SearchViewController.h"
#import "SettingsTVC.h"

@interface InfomationViewController ()
@property (strong, nonatomic) IBOutlet UIView *whiteBoxWrapper;
@property (strong, nonatomic) SettingsTVC *settingsTVC;

@end

@implementation InfomationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.whiteBoxWrapper.layer.cornerRadius = 5;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.minPrice = self.settingsTVC.minPrice;
    self.maxPrice = self.settingsTVC.maxPrice;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[SearchViewController class]]){
        self.minPrice = self.settingsTVC.minPrice;
        self.maxPrice = self.settingsTVC.maxPrice;
    }
    if ([[segue destinationViewController] isKindOfClass:[SettingsTVC class]]){
        
        if (self.splitViewController) {
            self.minPrice = 0;
            self.maxPrice = 10000;
        }
        
        SettingsTVC * stvc = (SettingsTVC *) [segue destinationViewController];
        self.settingsTVC = stvc;
        stvc.minPrice = self.minPrice;
        stvc.maxPrice = self.maxPrice;
    }
}

@end
