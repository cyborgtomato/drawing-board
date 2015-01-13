//
//  DBWidthSlider.m
//  DrawingBoard
//
//  Created by Sergei Smagleev on 07/11/14.
//  Copyright (c) 2014 Sergei Smagleev. All rights reserved.
//

#import "DBWidthSlider.h"

#define kLabelWidth 70

@interface DBWidthSlider () {
    UISlider *slider;
    UILabel *titleLabel;
    UILabel *widthLabel;
    CGFloat m_width;
}

@end

@implementation DBWidthSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kLabelWidth, self.bounds.size.height)];
        [titleLabel setText:@"Width"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        slider = [[UISlider alloc] initWithFrame:CGRectMake(kLabelWidth, 0,
                                                            self.bounds.size.width - kLabelWidth * 2.0f,
                                                            self.bounds.size.height)];
        slider.minimumValue = 1.0f;
        slider.maximumValue = 40.0f;
        slider.value = 6.0f;
        [slider addTarget:self action:@selector(widthChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        
        widthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(slider.frame), 0,
                                                               kLabelWidth, self.bounds.size.height)];
        widthLabel.textAlignment = NSTextAlignmentCenter;
        [widthLabel setText:@"0"];
        [self addSubview:widthLabel];
    }
    return self;
}

- (void)setWidth:(CGFloat)width {
    m_width = width;
    [widthLabel setText:[NSString stringWithFormat:@"%.1f", width]];
}

- (CGFloat)width {
    return m_width;
}

- (void)widthChanged:(UISlider *)sender {
    self.width = sender.value;
    [self.delegate widthSlider:self valueChanged:sender.value];
}

@end
