//
//  DBToolBarView.m
//  DrawingBoard
//
//  Created by Sergei Smagleev on 07/11/14.
//  Copyright (c) 2014 Sergei Smagleev. All rights reserved.
//

#import "DBToolBarView.h"

@interface DBToolBarView () {
    NSArray *m_buttons;
}

@end

@implementation DBToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = ceilf(self.bounds.size.width / [m_buttons count]);
    [m_buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        CGRect buttonFrame = CGRectMake(idx * width, 0, width, self.bounds.size.height);
        button.frame = buttonFrame;
    }];
}

- (void)setButtonsWithNames:(NSArray *)names {
    NSMutableArray *array = [NSMutableArray new];
    [names enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        UIButton *button = [[UIButton new] autorelease];
        [button setTitle:name forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor orangeColor]];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
        [self addSubview:button];
        [array addObject:button];
    }];
    [m_buttons release];
    m_buttons = array;
    [self setNeedsLayout];
}

- (void)buttonTapped:(UIButton *)sender {
    [self.delegate toolBar:self buttonPressedWithIndex:[m_buttons indexOfObject:sender]];
}

@end
