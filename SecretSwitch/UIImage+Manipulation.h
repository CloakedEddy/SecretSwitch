//
//  UIImage+Manipulation.h
//  SecretSwitch
//
//  Created by Edwin Veger on 18-07-14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Manipulation)

+ (UIImage *)combineRoot:(UIImage *)root modal:(UIImage *)modal;
- (UIImage *)blurWithFactor:(CGFloat)factor;
- (UIImage *)colorizeWithColor:(UIColor *)color;


@end
