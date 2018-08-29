//
//  UIView+Additions.m
//  Couture
//
//  Created by Apple on 14-11-16.
//  Copyright (c) 2014年 Kaymin. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

#pragma mark - setter

- (void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}

- (void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}

- (void)setTop:(CGFloat)top {
	CGRect frame = self.frame;
	frame.origin.y = top;
	self.frame = frame;
}

- (void)setLeft:(CGFloat)left {
	CGRect frame = self.frame;
	frame.origin.x = left;
	self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}

- (void)setSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

#pragma mark - getter

- (CGFloat)centerX {
	return self.center.x;
}

- (CGFloat)centerY {
	return self.center.y;
}

- (CGFloat)top {
	return CGRectGetMinY(self.frame);
}

- (CGFloat)left {
	return CGRectGetMinX(self.frame);
}

- (CGFloat)bottom {
	return CGRectGetMaxY(self.frame);
}

- (CGFloat)right {
	return CGRectGetMaxX(self.frame);
}

- (CGFloat)width {
	return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
	return CGRectGetHeight(self.frame);
}

- (CGPoint)origin {
	return self.frame.origin;
}

- (CGSize)size {
	return self.frame.size;
}

- (void)removeAllSubviews {
	for (UIView *subview in self.subviews) {
		[subview removeFromSuperview];
	}
}

@end
