//
//  DBToolBarView.h
//  DrawingBoard
//
//  Created by Sergei Smagleev on 07/11/14.
//  Copyright (c) 2014 Sergei Smagleev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBToolBarView;

@protocol DBToolBarViewDelegate <NSObject>

- (void)toolBar:(DBToolBarView *)toolBar buttonPressedWithIndex:(NSUInteger)index;

@end

@interface DBToolBarView : UIView

@property (nonatomic, assign) id <DBToolBarViewDelegate> delegate;

- (void)setButtonsWithNames:(NSArray *)names;

@end
