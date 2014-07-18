//
//  SecretSwitch.h
//  SecretSwitch
//
//  Created by croath on 1/22/14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class provides methodology for masking sensitive content in the snapshots that iOS7 takes when an app becomes inactive.
*/
@interface SecretSwitch : NSObject

/** Sets up the singleton SecretSwitch object and hooks it up to willResignActive and didBecomeActive notifications. All you need to get going!
 */
+ (void)protectSecret;

/**
 Sets the degree to which the screen is blurred.
 @param factor The value will be clipped between 1 and 100.
 */
+ (void)setBlurFactor:(CGFloat)factor;

@end
