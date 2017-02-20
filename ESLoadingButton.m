//
//  ESLoadingButton.m
//  EduSoho
//
//  Created by LiweiWang on 2016/11/24.
//  Copyright © 2016年 Kuozhi Network Technology. All rights reserved.
//

#import "ESLoadingButton.h"

@interface ESLoadingButton ()

@property (assign, nonatomic) CGFloat defaultR;
@property (assign, nonatomic) CGFloat defaultH;
@property (assign, nonatomic) CGFloat defaultW;
@property (assign, nonatomic) CGFloat miniWith;
@property (assign, nonatomic) CGFloat scale;
@property (strong, nonatomic) UIImageView *loadingView;
@property (strong, nonatomic) UIView *bgView;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *color;

@end

@implementation ESLoadingButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
    }
    return self;
}

- (void)initValues {
    _defaultR = self.layer.cornerRadius;
    _defaultH = self.frame.size.height;
    _defaultW = self.frame.size.width;
    _color = self.backgroundColor;
    _miniWith = _defaultH > _defaultW? _defaultW:_defaultH;
    _scale = 1.05;
    
    
    _loadingView = [[UIImageView alloc] init];
    _loadingView.frame = CGRectMake(0,0,_defaultH,_defaultH);
    _loadingView.backgroundColor = [UIColor clearColor];
    _loadingView.layer.cornerRadius = _defaultH/2;
    _loadingView.layer.masksToBounds = YES;
    _loadingView.backgroundColor = self.backgroundColor;
    _loadingView.image = [UIImage imageNamed:@"loading"];
    
    _bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(0, 0, _defaultW, _defaultH);
    _bgView.backgroundColor = self.backgroundColor;
}

- (void)startAnimation {
    [_bgView addSubview:_loadingView];
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = NSIntegerMax;
    rotationAnimation.removedOnCompletion = NO;
    [_loadingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation {
    [_loadingView.layer removeAllAnimations];
    [_loadingView removeFromSuperview];
}


- (void)showLoadingBlock:(void (^)())block {
    self.userInteractionEnabled = NO;
    [self addSubview:_bgView];
    self.backgroundColor = [UIColor clearColor];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = @(_defaultR);
    animation.toValue = @(_miniWith*_scale*0.5);
    animation.duration = 0.3;
    [_bgView.layer addAnimation:animation forKey:@"cornerRadius"];
    [_bgView.layer setCornerRadius:_miniWith*_scale*0.5];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _bgView.layer.bounds = CGRectMake(0, 0, _defaultW * _scale, _defaultH * _scale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _bgView.layer.bounds = CGRectMake(0, 0, _miniWith, _miniWith);
        } completion:^(BOOL finished) {
            [self startAnimation];
            if (block) {
                block();
            }
        }];
    }];
}

- (void)dismissLoadingBlock:(void (^)())block {
    [self stopAnimation];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _bgView.layer.bounds = CGRectMake(0, 0, _miniWith, _miniWith);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _bgView.layer.bounds = CGRectMake(0, 0, _defaultW, _defaultH);
            [_bgView.layer setCornerRadius:_defaultR];
        } completion:^(BOOL finished) {
            self.backgroundColor = _color;
            self.userInteractionEnabled = YES;
            [_bgView removeFromSuperview];
            if (block) {
                block();
            }
        }];
    }];
}

@end
