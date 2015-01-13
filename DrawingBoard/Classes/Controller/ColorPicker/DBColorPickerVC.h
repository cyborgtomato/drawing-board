//
//  DBColorPickerVC.h
//  DrawingBoard
//
//  Created by Sergei Smagleev on 07/11/14.
//  Copyright (c) 2014 Sergei Smagleev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBColorPickerVC : UIViewController

@property (nonatomic, copy) UIColor *color;
@property (nonatomic, assign) BOOL saveNewColor;

@end
