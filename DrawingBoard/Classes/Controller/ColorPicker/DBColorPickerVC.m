//
//  DBColorPickerVC.m
//  DrawingBoard
//
//  Created by Sergei Smagleev on 07/11/14.
//  Copyright (c) 2014 Sergei Smagleev. All rights reserved.
//

#import "DBColorPickerVC.h"

#define kColorViewSize  160
#define kTitleWidth     60
#define kValueWidth     40
#define kToolsHeight    40
#define kGapWidth       10

@interface DBColorPickerVC () {
    UIView      *colorView;
//---------
    UILabel     *redTitleLabel;
    UILabel     *greenTitleLabel;
    UILabel     *blueTitleLabel;
//---------
    UILabel     *redValueLabel;
    UILabel     *greenValueLabel;
    UILabel     *blueValueLabel;
//---------
    UISlider    *redSlider;
    UISlider    *greenSlider;
    UISlider    *blueSlider;
}

@end

@implementation DBColorPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Color picker"];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *newThread = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = newThread;
    
    colorView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - kColorViewSize)/2.0f, 80,
                                                        kColorViewSize, kColorViewSize)];
    colorView.layer.cornerRadius = kColorViewSize/2.0f;
    colorView.layer.masksToBounds = YES;
    colorView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    colorView.layer.borderWidth = 1.0f;
    [self.view addSubview:colorView];
    [colorView release];
    
    redTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(colorView.frame) + 10.0f,
                                                              kTitleWidth, kToolsHeight)];
    [redTitleLabel setText:@"Red"];
    redTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:redTitleLabel];
    [redTitleLabel release];
    
    greenTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(redTitleLabel.frame),
                                                                kTitleWidth, kToolsHeight)];
    [greenTitleLabel setText:@"Green"];
    greenTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:greenTitleLabel];
    [greenTitleLabel release];
    
    blueTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(greenTitleLabel.frame),
                                                               kTitleWidth, kToolsHeight)];
    [blueTitleLabel setText:@"Blue"];
    blueTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:blueTitleLabel];
    [blueTitleLabel release];
    
    redSlider = [[UISlider alloc] initWithFrame:CGRectMake(kTitleWidth + kGapWidth, redTitleLabel.frame.origin.y,
                                                           self.view.bounds.size.width - kGapWidth * 2 - kTitleWidth - kValueWidth,
                                                           kToolsHeight)];
    redSlider.minimumValue = 0;
    redSlider.maximumValue = 255;
    [redSlider addTarget:self action:@selector(redValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:redSlider];
    [redSlider release];
    
    greenSlider = [[UISlider alloc] initWithFrame:CGRectMake(kTitleWidth + kGapWidth, greenTitleLabel.frame.origin.y,
                                                           self.view.bounds.size.width - kGapWidth * 2 - kTitleWidth - kValueWidth,
                                                           kToolsHeight)];
    greenSlider.minimumValue = 0;
    greenSlider.maximumValue = 255;
    [greenSlider addTarget:self action:@selector(greenValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:greenSlider];
    [greenSlider release];
    
    blueSlider = [[UISlider alloc] initWithFrame:CGRectMake(kTitleWidth + kGapWidth, blueTitleLabel.frame.origin.y,
                                                           self.view.bounds.size.width - kGapWidth * 2 - kTitleWidth - kValueWidth,
                                                           kToolsHeight)];
    blueSlider.minimumValue = 0;
    blueSlider.maximumValue = 255;
    [blueSlider addTarget:self action:@selector(blueValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:blueSlider];
    [blueSlider release];
    
    redValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(redSlider.frame),
                                                             redSlider.frame.origin.y,
                                                              kValueWidth, kToolsHeight)];
    redValueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:redValueLabel];
    [redValueLabel release];
    
    greenValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(greenSlider.frame),
                                                                greenSlider.frame.origin.y,
                                                                kValueWidth, kToolsHeight)];
    greenValueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:greenValueLabel];
    [greenValueLabel release];
    
    blueValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(blueSlider.frame),
                                                               blueSlider.frame.origin.y,
                                                               kValueWidth, kToolsHeight)];
    blueValueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:blueValueLabel];
    [blueValueLabel release];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.saveNewColor = NO;
    CGColorRef colorRef = [self.color CGColor];
    const CGFloat *colorComponents = CGColorGetComponents(colorRef);
    redSlider.value     = colorComponents[0] * 255.0f;
    greenSlider.value   = colorComponents[1] * 255.0f;
    blueSlider.value    = colorComponents[2] * 255.0f;
    colorView.backgroundColor = self.color;
    [self.view setNeedsLayout];
}

- (void)redValueChanged:(UISlider *)sender {
    CGColorRef colorRef = [self.color CGColor];
    const CGFloat *colorComponents = CGColorGetComponents(colorRef);
    self.color = [UIColor colorWithRed:sender.value/255.0f
                              green:colorComponents[1]
                               blue:colorComponents[2]
                              alpha:1.0f];
    colorView.backgroundColor = self.color;
}

- (void)greenValueChanged:(UISlider *)sender {
    CGColorRef colorRef = [self.color CGColor];
    const CGFloat *colorComponents = CGColorGetComponents(colorRef);
    self.color = [UIColor colorWithRed:colorComponents[0]
                              green:sender.value/255.0f
                               blue:colorComponents[2]
                              alpha:1.0f];
    colorView.backgroundColor = self.color;
}

- (void)blueValueChanged:(UISlider *)sender {
    CGColorRef colorRef = [self.color CGColor];
    const CGFloat *colorComponents = CGColorGetComponents(colorRef);
    self.color = [UIColor colorWithRed:colorComponents[0]
                              green:colorComponents[1]
                               blue:sender.value/255.0f
                              alpha:1.0f];
    colorView.backgroundColor = self.color;
}

- (void)done:(id)sender {
    self.saveNewColor = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
