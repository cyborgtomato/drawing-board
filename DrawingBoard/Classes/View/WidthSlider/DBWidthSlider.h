//
//  DBWidthSlider.h
//  DrawingBoard
//
//  Created by Sergei Smagleev on 07/11/14.
//  Copyright (c) 2014 Sergei Smagleev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBWidthSlider;

@protocol DBWidthSliderDelegate <NSObject>

- (void)widthSlider:(DBWidthSlider *)slider valueChanged:(CGFloat)value;

@end

@interface DBWidthSlider : UIView

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) id <DBWidthSliderDelegate> delegate;

@end
