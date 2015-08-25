//
//  BUYNavigationController.m
//  Mobile Buy SDK
//
//  Created by Rune Madsen on 2015-07-09.
//  Copyright (c) 2015 Shopify Inc. All rights reserved.
//

#import "BUYNavigationController.h"
#import "BUYImageKit.h"
#import "BUYTheme+Additions.h"

@interface BUYNavigationController ()
@property (nonatomic, strong) BUYTheme *theme;
@end

@implementation BUYNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
	self = [super initWithRootViewController:rootViewController];
	
	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeButton addTarget:self action:@selector(dismissPopover) forControlEvents:UIControlEventTouchUpInside];
	closeButton.frame = CGRectMake(0, 0, 22, 22);
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
	self.topViewController.navigationItem.leftBarButtonItem = barButtonItem;
	[[UINavigationBar appearanceWhenContainedIn:[BUYNavigationController class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
	
	return self;
}

- (void)updateCloseButtonImageWithDarkStyle:(BOOL)darkStyle duration:(CGFloat)duration
{
	UIButton *button = (UIButton*)self.topViewController.navigationItem.leftBarButtonItem.customView;
	UIImage *oldButtonImage = [BUYImageKit imageOfProductViewCloseImageWithFrame:button.bounds color:darkStyle ? [UIColor whiteColor] : self.theme.tintColor hasShadow:darkStyle == NO];
	UIImage *newButtonImage = [BUYImageKit imageOfProductViewCloseImageWithFrame:button.bounds color:darkStyle ? self.theme.tintColor : [UIColor whiteColor] hasShadow:darkStyle == NO];
	if (duration > 0) {
		CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
		crossFade.duration = duration;
		crossFade.fromValue = (id)oldButtonImage.CGImage;
		crossFade.toValue = (id)newButtonImage.CGImage;
		crossFade.removedOnCompletion = YES;
		crossFade.fillMode = kCAFillModeForwards;
		[button.imageView.layer addAnimation:crossFade forKey:@"contents"];
	}
	[button setImage:newButtonImage forState:UIControlStateNormal];
}

- (void)dismissPopover
{
	if ([self.navigationDelegate respondsToSelector:@selector(presentationControllerWillDismiss:)]) {
		[self.navigationDelegate presentationControllerWillDismiss:nil];
	}
	[self dismissViewControllerAnimated:YES completion:^{
		if ([self.navigationDelegate respondsToSelector:@selector(presentationControllerDidDismiss:)]) {
			[self.navigationDelegate presentationControllerDidDismiss:nil];
		}
	}];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (BOOL)shouldAutorotate {
	return self.topViewController.shouldAutorotate;
}

- (void)setTheme:(BUYTheme *)theme
{
	_theme = theme;
	self.navigationBar.barStyle = [theme navigationBarStyle];
	[self updateCloseButtonImageWithDarkStyle:NO duration:0];
	[[UINavigationBar appearanceWhenContainedIn:[BUYNavigationController class], nil] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [theme navigationBarTitleColor] }];
}

-(UIViewController *)childViewControllerForStatusBarStyle {
	return self.visibleViewController;
}

-(UIViewController *)childViewControllerForStatusBarHidden {
	return self.visibleViewController;
}

@end
