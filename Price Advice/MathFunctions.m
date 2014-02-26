//
//  MathFunctions.m
//  Price Advice
//
//  Created by Tullie Murrell on 23/02/2014.
//  Copyright (c) 2014 Tullie Murrell. All rights reserved.
//

#import "MathFunctions.h"

@implementation MathFunctions

+ (double)logToBase:(double)base value:(double)value
{
    return log(value)/log(base);
}

@end
