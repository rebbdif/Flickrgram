//
//  UIColor+SLVColor.m
//  lection14
//
//  Created by 1 on 30.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "UIColor+SLVColor.h"

@implementation UIColor (SLVColor)

+ (UIColor *)myGray {
    UIColor *myGray = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.9];
    return myGray;
}

+ (UIColor *)myOpaqueGray {
    UIColor *myGray = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    return myGray;
}

+ (UIColor *)separatorColor {
    return [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
}

@end
