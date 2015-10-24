//
//  BannerView.m
//  sudayao
//
//  Created by yyx on 15/10/15.
//  Copyright © 2015年 saint. All rights reserved.
//

#define IMAGE_TAG_BASE 10000
#define PAGECONTROL_WIDTH 100
#define PAGECONTROL_HEIGHT 40

#import "BannerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BannerView() <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *imageNameArray;
@property (strong, nonatomic) NSMutableArray *imageViewArray;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) BOOL autoScrollEnable;
@property (strong, nonatomic) NSTimer *autoScrollTimer;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation BannerView

- (BannerView *)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:({
            UIScrollView *s = [[UIScrollView alloc] initWithFrame:frame];
            s.delegate = self;
            s.pagingEnabled = YES;
            s.showsHorizontalScrollIndicator = NO;
            s.contentOffset = CGPointZero;
            self.scrollView = s;
            self.scrollView;
        })];
    }
    return self;
}

- (void)bindImageNameArray:(NSArray *)imageNameArray autoSCrollEnable:(BOOL)enable titles:(NSArray *)titles {
    [self bindImages:imageNameArray titles:titles];
    
    self.currentPage = 0;
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    if (enable) {
        if (self.autoScrollTimer) {
            [self.autoScrollTimer invalidate];
            self.autoScrollTimer = nil;
        }
        self.autoScrollEnable = enable;
        self.autoScrollTimeInterval = 3.0;
        self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(runScroll) userInfo:nil repeats:YES];
    }
}

- (void)runScroll {
    CGPoint nextOrigin = CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width,
                                     self.scrollView.contentOffset.y);
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:nextOrigin animated:NO];
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

- (void)bindImages:(NSArray *)arr titles:(NSArray *)titles {
    //1 + (2 to n-1) + n
    NSString *oldLast = [arr lastObject];
    NSString *oldFirst = [arr firstObject];
    NSString *newFirst = [NSString stringWithString:oldLast];
    NSString *newLast = [NSString stringWithString:oldFirst];
    //n(add) + 1 + (2 to n-1) + n + 1(add)
    self.imageNameArray = [NSMutableArray arrayWithArray:arr];
    [self.imageNameArray insertObject:newFirst atIndex:0];
    [self.imageNameArray addObject:newLast];
    
    NSMutableArray *newTitles;
    if (titles) {
        newTitles = [NSMutableArray arrayWithArray:titles];
        [newTitles insertObject:[titles lastObject] atIndex:0];
        [newTitles addObject:[titles firstObject]];
    }else{
        newTitles = nil;
    }
    
    
    NSUInteger imgViewCount = self.imageNameArray.count;
    self.imageViewArray = [NSMutableArray arrayWithCapacity:imgViewCount];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * imgViewCount,
                                             self.scrollView.frame.size.height);
    for (int i = 0; i < imgViewCount; i++) {
        if ([self.imageNameArray[i] hasPrefix:@"https://"] || [self.imageNameArray[i] hasPrefix:@"http://"]) {
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.imageNameArray[i]]];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            [self.imageViewArray insertObject:imgView atIndex:i];
        }
        else {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageNameArray[i]]];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            [self.imageViewArray insertObject:imgView atIndex:i];
        }
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * i;
        [self.imageViewArray[i] setFrame:frame];
        [self.imageViewArray[i] setUserInteractionEnabled:YES];
        [self.imageViewArray[i] setTag:IMAGE_TAG_BASE + i - 1];
        [self.scrollView addSubview:self.imageViewArray[i]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presseImageAtIndex:)];
        [self.imageViewArray[i] addGestureRecognizer:tap];
        
        if (newTitles) {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, self.frame.size.height - 26, frame.size.width, 26)];
            title.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
            title.font = [UIFont systemFontOfSize:13];
            title.text = [NSString stringWithFormat:@"   %@", newTitles[i]];
            title.textColor = [UIColor blackColor];
            [self.scrollView addSubview:title];
        }
        
    }
    [self.imageViewArray[0] setTag:IMAGE_TAG_BASE + self.imageViewArray.count - 3];
    [[self.imageViewArray lastObject] setTag:IMAGE_TAG_BASE];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - PAGECONTROL_WIDTH)/2, self.scrollView.bounds.size.height - PAGECONTROL_HEIGHT, PAGECONTROL_WIDTH, PAGECONTROL_HEIGHT)];
    self.pageControl.numberOfPages = self.imageViewArray.count - 2;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    [self changePageControlImage:self.pageControl];
}

#pragma mark - image pressed method
- (void)presseImageAtIndex:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(presseImageAtIndex:)]) {
        [self.delegate presseImageAtIndex:sender.view.tag - IMAGE_TAG_BASE];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //imageViews:n(add) + 1 + (2 to n-1) + n + 1(add)
    //if scroll to the n(add), goto the n
    if (self.scrollView.contentOffset.x == 0) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * (self.imageViewArray.count-2), 0);
    }
    //if scroll to the 1(add), goto the 1
    else if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width * (self.imageViewArray.count-1)) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
    self.pageControl.currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width - 1;
    [self changePageControlImage:self.pageControl];
}

- (void)changePageControlImage:(UIPageControl *)pageControl
{
    static UIImage *imgCurrent = nil;
    static UIImage *imgOther = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        imgCurrent = [UIImage imageNamed:@"dots"];
        imgOther = [UIImage imageNamed:@"dotn"];
    });
    
    
    if (iOS7) {
        [pageControl setValue:imgCurrent forKey:@"_currentPageImage"];
        [pageControl setValue:imgOther forKey:@"_pageImage"];
    } else {
        for (int i = 0;i < pageControl.numberOfPages; i++) {
            UIImageView *imgv = [pageControl.subviews objectAtIndex:i];
            imgv.frame = CGRectMake(imgv.frame.origin.x, imgv.frame.origin.y, 20, 20);
            imgv.image = pageControl.currentPage == i ? imgCurrent : imgOther;
        }
    }
}

@end
