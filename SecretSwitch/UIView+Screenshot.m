//
//  UIView+Screenshot.m
//  SecretSwitch
//
//  Created by Edwin Veger on 18-07-14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage *) screenshot {
	UIGraphicsBeginImageContext(self.bounds.size);
	
	if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
		[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
	} else {
		[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	}
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	// hack, helps w/ our colors when blurring
	NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
	image = [UIImage imageWithData:imageData];

	return image;
}

@end
