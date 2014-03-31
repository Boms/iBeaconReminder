//
//  colorForMarker.m
//  beaconReminderDemo
//
//  Created by li lin on 3/25/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "colorForMarker.h"
#import "FBTweak.h"
#import "FBTweakShakeWindow.h"
#import "FBTweakInline.h"
#import "FBTweakViewController.h"
@implementation colorForMarker
+(UIColor *)markerColor
{
    return [UIColor colorWithRed:0 green:0.6 blue:1 alpha:1];
}

+(UIColor *)buttonColor
{
    return [UIColor colorWithRed:FBTweakValue(@"Window", @"Button", @"Red", 0.9, 0.0, 1.0)
                    green:FBTweakValue(@"Window", @"Button", @"Green", 0.9, 0.0, 1.0)
                     blue:FBTweakValue(@"Window", @"Button", @"Blue", 0.9, 0.0, 1.0)
                    alpha:1.0];
}
+(UIColor *)toolBarBackGroundColor
{
    return [UIColor colorWithRed:FBTweakValue(@"Window", @"Color", @"Red", 0.9, 0.0, 1.0)
                           green:FBTweakValue(@"Window", @"Color", @"Green", 0.9, 0.0, 1.0)
                            blue:FBTweakValue(@"Window", @"Color", @"Blue", 0.9, 0.0, 1.0)
                           alpha:1.0];
}
@end
