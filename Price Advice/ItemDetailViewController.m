//
//  ItemDetailViewController.m
//  Price Advice
//
//  Created by Tullie Murrell on 22/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "ItemDetailViewController.h"

@interface ItemDetailViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIBarButtonItem *buttonItem;
@end

@implementation ItemDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemNameLabel.text = self.itemName;
    [self setUpBackButton];
    [self fetchPage];
}

- (void)setUpBackButton
{
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)fetchPage
{
    if (self.itemURL){
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        dispatch_queue_t q = dispatch_queue_create("webPage download queue", 0);
        dispatch_async(q, ^{
            NSURLRequest *pageRequest = [NSURLRequest requestWithURL:self.itemURL];
            [self.webView loadRequest:pageRequest];
        });
    }
    else {
        [self webViewDidFinishLoad:self.webView];
    }
}

- (void)setItemName:(NSString *)itemName
{
    _itemName = itemName;
    self.itemNameLabel.text = itemName;
}

- (void)setItemURL:(NSURL *)itemURL
{
    _itemURL = itemURL;
    [self fetchPage];
}

- (IBAction)backButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}

@end
