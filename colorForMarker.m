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
    return [UIColor colorWithRed:FBTweakValue(@"Window", @"ToolBarColor", @"Red", 0.0, 0.0, 1.0)
                           green:FBTweakValue(@"Window", @"ToolBarColor", @"Green", 0.5, 0.0, 1.0)
                            blue:FBTweakValue(@"Window", @"ToolBarColor", @"Blue", 0.8, 0.0, 1.0)
                           alpha:1.0];
}
+(UIColor *)navBarBackGroundColor
{
    return [UIColor colorWithRed:FBTweakValue(@"Window", @"NavColor", @"Red", 0.9, 0.0, 1.0)
                           green:FBTweakValue(@"Window", @"NavColor", @"Green", 0.9, 0.0, 1.0)
                            blue:FBTweakValue(@"Window", @"NavColor", @"Blue", 0.9, 0.0, 1.0)
                           alpha:1.0];
}

@end
