//
//  MHAlertView.m
//  DragonForiOS
//
//  Created by symbio on 8/14/14.
//  Copyright (c) 2014 symbio. All rights reserved.
//

#import "MHAlertView.h"
//#import "NoLocationServiceView.h"


@interface MHAlertView ()
{
    UIView *_bg;
    UIView *_contentBG;
    UILabel *_text;
    UIActivityIndicatorView *_indicator;
    
    int _alertType;
}

@end


static MHAlertView *gAlert;
@implementation MHAlertView

+(MHAlertView*) _instance
{
    if (nil == gAlert) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (nil == window) {
            window = [UIApplication sharedApplication].delegate.window;
        }
        CGRect frame=window.frame;
        gAlert = [[MHAlertView alloc]initWithFrame:frame];
        [window addSubview:gAlert];
    }
    [gAlert.superview bringSubviewToFront:gAlert];
    
    return gAlert;
}

+(void) remove
{
    if (gAlert) {
        [gAlert removeFromSuperview];
        gAlert = nil;
    }
}

+(void) showZoomIn:(NSString*)text duration:(float)duration
{
    [[MHAlertView _instance] _showZoomIn:text duration:duration];
}
+(void) showFadeIn:(NSString*)text duration:(float)duration
{
    [[MHAlertView _instance] _showFadeIn:text duration:duration];
}
+(void) showFadeIn:(NSString*)text
         withFrame:(CGRect)frame
          duration:(float)duration{
    [[MHAlertView _instance] _showFadeIn:text duration:duration];
    [[MHAlertView _instance] showFadeIn:frame];
}

#pragma mrak -键盘遮挡修正
- (void)showFadeIn:(CGRect)frame{
    float maxBgY = CGRectGetMaxY(_contentBG.frame);
    float deltaY = maxBgY - frame.origin.y;
    if(deltaY < 0){
        return;
    }
    _contentBG.frame = CGRectMake(_contentBG.frame.origin.x, _contentBG.frame.origin.y - deltaY - 5, _contentBG.frame.size.width, _contentBG.frame.size.height);
}

+(void) cancelZoomOut
{
    [[MHAlertView _instance] _cancelZoomOut];
}
+(void) cancelFadeOut
{
    [[MHAlertView _instance] _cancelFadeOut];
}

-(void) _showZoomIn:(NSString*)text duration:(float)duration
{
    [self _prepareForShow:kAlertType_zoom text:text];
    
    [UIView animateWithDuration:0.3 animations:^(void){
        _bg.alpha = 1.0;
        _contentBG.alpha = 1.0;
        _contentBG.transform = CGAffineTransformIdentity;
    }completion:^(BOOL f){
        if (duration > 0.1) {
            [self performSelector:@selector(_cancelZoomOut) withObject:nil afterDelay:duration];
        }
    }];
}
-(void) _showFadeIn:(NSString*)text duration:(float)duration
{
    [self _prepareForShow:kAlertType_fade text:text];
    
    [UIView animateWithDuration:0.3 animations:^(void){

    }completion:^(BOOL f){
        if (duration>0.1) {
            [self performSelector:@selector(_cancelFadeOut) withObject:nil afterDelay:duration];
        }
    }];
    
}

-(void) _cancelZoomOut
{
    [UIView animateWithDuration:0.3 animations:^(void){
        _bg.alpha = 0.0;
        _contentBG.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }completion:^(BOOL f){
        self.alpha = 0.0;
        [self _didDisappear];
    }];
}
-(void) _cancelFadeOut
{
    [UIView animateWithDuration:0.3 animations:^(void){

        self.alpha = 0.0;
    }completion:^(BOOL f){

        [self _didDisappear];
    }];
}

-(void) _prepareForShow:(int)type text:(NSString*)text
{
    _alertType = type;
    _text.text = text;

    self.alpha = 1.0;
    _indicator.alpha = 0.0;
    
    switch (type) {
        case kAlertType_zoom:
            _contentBG.transform = CGAffineTransformMakeScale(0.01, 0.01);
            break;
        case kAlertType_fade:
            _contentBG.transform = CGAffineTransformIdentity;
            break;
            
        default:
            break;
    }
}

-(void) _didDisappear
{
//    if (_locationServiceMode) {
//        CGRect frame = _contentBG.frame;
//        frame.size.height -= 50;
//        frame.size.width -= 50;
//        _contentBG.frame = frame;
//        _contentBG.center = CGPointMake(SCREEN_WIDTH / 2, _contentBG.center.y);
//        
//        _locationServiceMode = NO;
//    }
    if (gAlert) {
        [gAlert removeFromSuperview];
        gAlert = nil;
    }
}

-(void) _showForDebug:(NSNotification*)noty
{
#ifdef FOR_TESTFLIGHT
    return;
#endif
    
    NSString *content = [noty object];
    
    [self.superview bringSubviewToFront:self];
    [MHAlertView showFadeIn:content duration:-1.0];
}

-(void) dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShowInfoForDebug object:nil];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_showForDebug:) name:kShowInfoForDebug object:nil];

        // Initialization code
        frame.origin = CGPointMake(0, 0);
        _bg = [[UIView alloc]initWithFrame:frame];
        _bg.backgroundColor = [UIColor clearColor];
        [self addSubview:_bg];
        
        frame.size = CGSizeMake(150, 100);
        _contentBG = [[UIView alloc]initWithFrame:frame];
        _contentBG.center = _bg.center;
        _contentBG.layer.cornerRadius = 6.0;
        _contentBG.layer.masksToBounds= YES;
        _contentBG.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        [self addSubview:_contentBG];
        
//        _text = createLabel(frame, nil, [UIColor whiteColor], theFont(15),NSTextAlignmentCenter);
        _text = [[UILabel alloc]initWithFrame:frame];
        _text.backgroundColor = [UIColor clearColor];
        _text.textColor = [UIColor whiteColor];
        _text.textAlignment = NSTextAlignmentCenter;
        _text.font = [UIFont systemFontOfSize:14];
        _text.numberOfLines = 0;
        [_contentBG addSubview:_text];
        
//        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_cancelFadeOut)] ];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(void) locationServiceUnvalaible
{
//    [NoLocationServiceView show:NSLocalizedString(@"Please enable location service for Kankan", nil)];

}


@end
