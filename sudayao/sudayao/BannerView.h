//
//  BannerView.h
//  sudayao
//
//  Created by yyx on 15/10/15.
//  Copyright © 2015年 saint. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerViewDelegate <NSObject>

- (void)presseImageAtIndex:(NSInteger)index;

@end

@interface BannerView : UIView

@property (assign, nonatomic) id<BannerViewDelegate> delegate;
@property (assign, nonatomic) CGFloat autoScrollTimeInterval;

- (void)bindImageNameArray:(NSArray *)imageNameArray autoSCrollEnable:(BOOL)enable titles:(NSArray *)titles;

@end
