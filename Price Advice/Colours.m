//
//  Colours.m
//  Price Advice
//
//  Created by Tullie Murrell on 14/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "Colours.h"

@implementation Colours


+ (UIColor *)skyCrayonColor
{
    return [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
}

+ (UIColor *)cantalopeCrayonColor
{
    return [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
}

+ (UIColor *)spindriftCrayonColor
{
    return [UIColor colorWithRed:0.4 green:1.0 blue:0.8 alpha:1.0];
}

+ (UIColor *)gradientSpindDriftColor
{
    return [self colorWithHexString:@"52edc7"];
}

+ (UIColor *)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}



@end
