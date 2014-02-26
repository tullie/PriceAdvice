//
//  ItemTableViewCell.h
//  Price Advice
//
//  Created by Tullie Murrell on 23/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
