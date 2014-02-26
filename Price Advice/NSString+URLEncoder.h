//
//  NSString+URLEncoder.h
//  Price Advice
//
//  Created by Tullie Murrell on 10/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoder)

- (NSString *)stringForHTTPRequest;

@end
