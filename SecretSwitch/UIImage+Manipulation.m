//
//  UIImage+Manipulation.m
//  SecretSwitch
//
//  Created by Edwin Veger on 18-07-14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import "UIImage+Manipulation.h"

#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Manipulation)

+ (UIImage *)combineRoot:(UIImage *)root modal:(UIImage *)modal {
	UIImage * combined;
	
	root = [root colorizeWithColor:[UIColor grayColor]];
	
	CGRect modalRect;
	modalRect.size = modal.size;
  modalRect.origin.x = root.size.width / 2 - modal.size.width/2;
  modalRect.origin.y = 10 + root.size.height / 2 - modal.size.height/2;
	
	UIGraphicsBeginImageContext(root.size);
	[root drawInRect:CGRectMake(0, 0, root.size.width, root.size.height)];
	[modal drawInRect:modalRect];
	combined = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return combined;
}

- (UIImage *)blurWithFactor:(CGFloat)factor {
	CIImage *imageToBlur = [CIImage imageWithCGImage:self.CGImage];
	CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[gaussianBlurFilter setValue:imageToBlur forKey:@"inputImage"];
	[gaussianBlurFilter setValue:[NSNumber numberWithFloat:factor] forKey:@"inputRadius"];
	CIImage *resultImage = [gaussianBlurFilter valueForKey:@"outputImage"];

	//create UIImage from filtered image
	UIImage *blurredImage = [[UIImage alloc] initWithCIImage:resultImage];
	return blurredImage;
}


- (UIImage *)colorizeWithColor:(UIColor *)color {
	UIGraphicsBeginImageContext(self.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
	
	CGContextScaleCTM(context, 1, -1);
	CGContextTranslateCTM(context, 0, -area.size.height);
	
	CGContextSaveGState(context);
	CGContextClipToMask(context, area, self.CGImage);
	
	[color set];
	CGContextFillRect(context, area);
	
	CGContextRestoreGState(context);
	
	CGContextSetBlendMode(context, kCGBlendModeMultiply);
	
	CGContextDrawImage(context, area, self.CGImage);
	
	UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return colorizedImage;
}

@end
