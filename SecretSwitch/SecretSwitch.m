//
//  SerectSwitch.m
//  SecretSwitch
//
//  Created by croath on 1/22/14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import "SecretSwitch.h"
#import <Accelerate/Accelerate.h>

#import "UIImage+Manipulation.h"
#import "UIView+Screenshot.h"

@interface SecretSwitch ()

+ (void)applicationWillResignActive;
+ (void)applicationDidBecomeActive;

@end

@implementation SecretSwitch

static UIImageView *imageView;
static CGFloat blurFactor = 5;

#define PI 3.141592653589793238462643383279

+ (void)protectSecret
{
  if (imageView == nil) {
    imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [imageView.layer setBorderWidth:2.f];
    [imageView.layer setMasksToBounds:YES];
    [imageView setContentMode:UIViewContentModeScaleToFill];
  }
	
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(applicationWillResignActive)
                                               name:UIApplicationWillResignActiveNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(applicationDidBecomeActive)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
}

+ (void)applicationWillResignActive
{
  UIWindow *window = [[UIApplication sharedApplication].delegate window];
  UIView *view = window.rootViewController.view;
	UIImage *image = [view screenshot];
	
	if (window.rootViewController.presentedViewController) {
		UIImage* modal = [window.rootViewController.presentedViewController.view screenshot];
		image = [UIImage combineRoot:image modal:modal];
	}
	
	image = [image blurWithFactor:blurFactor];
	
  CGRect fullScreenRect = [UIScreen mainScreen].bounds;
  /// Calculate bounds based on orientation.
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  //implicitly in Portrait orientation.
  if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
      CGRect temp = CGRectZero;
      temp.size.width = fullScreenRect.size.height;
      temp.size.height = fullScreenRect.size.width;
      fullScreenRect = temp;
  }

  [imageView setImage:image];
	imageView.backgroundColor = [UIColor purpleColor];
  imageView.transform = CGAffineTransformIdentity;
  imageView.frame = fullScreenRect;
	NSLog(@"imageView has frame %@",NSStringFromCGRect(imageView.frame));
  
  if (orientation == UIInterfaceOrientationLandscapeRight) {
      imageView.transform = CGAffineTransformConcat(imageView.transform, CGAffineTransformMakeRotation(PI / 2));
      imageView.transform = CGAffineTransformConcat(imageView.transform, CGAffineTransformMakeTranslation(-128, 128));
  } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
      imageView.transform = CGAffineTransformConcat(imageView.transform, CGAffineTransformMakeRotation(-PI / 2));
      imageView.transform = CGAffineTransformConcat(imageView.transform, CGAffineTransformMakeTranslation(-128, 128));
  } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
      imageView.transform = CGAffineTransformConcat(imageView.transform, CGAffineTransformMakeRotation(PI));
  }

  [window addSubview:imageView];
	NSLog(@"Added overlay.");
}

+ (void)applicationDidBecomeActive
{
	[imageView removeFromSuperview];
	NSLog(@"Removed overlay.");
	imageView.image = nil;
}

#pragma mark - Properties

+ (void)setBlurFactor:(CGFloat)factor {
  factor = MIN(32, MAX(1, factor));
  blurFactor = factor;
}

@end
