//
//  DBBoardView.h
//  DrawingBoard
//
//  Created by Sergei Smagleev on 07/11/14.
//  Copyright (c) 2014 Sergei Smagleev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _DBBoardState {
    DBBoardStateBrush,
    DBBoardStateEraser,
    DBBoardStateCircle,
    DBBoardStateRectangle
} DBBoardState;

@interface DBBoardView : UIView

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) DBBoardState state;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) NSUInteger currentLayer;
@property (nonatomic, retain) NSMutableArray *layers;

- (void)addNewLayer;
- (void)reset;

@end
