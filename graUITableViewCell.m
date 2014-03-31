//
//  graUITableViewCell.m
//  beaconReminderDemo
//
//  Created by li lin on 3/30/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graUITableViewCell.h"
#import "colorForMarker.h"
@implementation graUITableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    CGFloat inset = 5;
    frame.origin.x += inset;
    frame.size.width -= 2* inset;
    self.layer.cornerRadius = 4;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [colorForMarker markerColor].CGColor;
    [self.layer setMasksToBounds:YES];
    [super setFrame:frame];
}

@end
