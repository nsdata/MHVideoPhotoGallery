//
//  MHAlertView.h
//  DragonForiOS
//
//  Created by symbio on 8/14/14.
//  Copyright (c) 2014 symbio. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    kAlertType_zoom,
    kAlertType_fade,
};


@interface MHAlertView : UIView

+(id) _instance;

+(void) showZoomIn:(NSString*)text duration:(float)duration;
+(void) showFadeIn:(NSString*)text duration:(float)duration;
/*
 !@brief 传入alert的frame位置
 */
+(void) showFadeIn:(NSString*)text
         withFrame:(CGRect)frame
          duration:(float)duration;

+(void) cancelZoomOut;
+(void) cancelFadeOut;

+(void) remove;

+(void) locationServiceUnvalaible;

@end
