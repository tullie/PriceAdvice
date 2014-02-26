//
//  AmazonHelper.h
//  Price Advice
//
//  Created by Tullie Murrell on 13/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmazonHelper : NSObject

+ (NSURL *)getAmazonItemsURL:(NSString *)keyword;

@end
