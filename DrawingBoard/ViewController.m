//
//  ViewController.m
//  DrawingBoard
//
//  Created by Sergei Smagleev on 07/11/14.
//  Copyright (c) 2014 Sergei Smagleev. All rights reserved.
//

#import "ViewController.h"
#import "DBBoardView.h"
#import "DBToolBarView.h"
#import "DBWidthSlider.h"
#import "DBColorPickerVC.h"

#define kSliderHeight 40
#define kToolBarHeight 40

typedef enum _DBActionSheetMode {
    DBActionSheetShape,
    DBActionSheetLayer
} DBActionSheetMode;

@interface ViewController () <DBWidthSliderDelegate, DBToolBarViewDelegate, UIActionSheetDelegate> {
    DBBoardView     *mBoardView;
    DBWidthSlider   *mSlider;
    DBToolBarView   *mToolBar;
    UIColor         *mColor;
    
    DBActionSheetMode actionSheetMode;
    
    DBColorPickerVC *colorPickerVC;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    mColor = [[UIColor redColor] copy];

    CGRect boardFrame = self.view.bounds;
    boardFrame.size.height = self.view.bounds.size.height - kSliderHeight - kToolBarHeight;
    mBoardView = [[DBBoardView alloc] initWithFrame:boardFrame];
    mBoardView.width = 6.0f;
    mBoardView.color = mColor;
    [self.view addSubview:mBoardView];
    
    CGRect sliderFrame = CGRectMake(0, boardFrame.size.height, self.view.bounds.size.width, kSliderHeight);
    mSlider = [[DBWidthSlider alloc] initWithFrame:sliderFrame];
    mSlider.delegate = self;
    mSlider.width = 6.0f;
    [self.view addSubview:mSlider];
    
    CGRect toolBarFrame = CGRectMake(0, CGRectGetMaxY(sliderFrame), self.view.bounds.size.width, kToolBarHeight);
    mToolBar = [[DBToolBarView alloc] initWithFrame:toolBarFrame];
    [mToolBar setButtonsWithNames:@[@"Brush", @"Eraser", @"Shape", @"Layer", @"Color", @"Reset"]];
    mToolBar.delegate = self;
    [self.view addSubview:mToolBar];

    colorPickerVC = [DBColorPickerVC new];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    if (colorPickerVC.saveNewColor) {
        [mColor release];
        mColor = [colorPickerVC.color copy];
        mBoardView.color = mColor;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - DBWidthSliderDelegate methods
- (void)widthSlider:(DBWidthSlider *)slider valueChanged:(CGFloat)value {
    mBoardView.width = slider.width;
}

#pragma mark - DBToolBarViewDelegate methods
- (void)toolBar:(DBToolBarView *)toolBar buttonPressedWithIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            mBoardView.state = DBBoardStateBrush;
            break;
        case 1:
            mBoardView.state = DBBoardStateEraser;
            break;
        case 2:
            [self showShapePicker];
            break;
        case 3:
            [self showLayerPicker];
            break;
        case 4:{
            colorPickerVC.color = [[mColor copy] autorelease];
            [self.navigationController pushViewController:colorPickerVC animated:YES];
            
            break;
        }
        case 5:
            [mBoardView reset];
            break;
    }
}

- (void)showLayerPicker {
    actionSheetMode = DBActionSheetLayer;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    
    NSUInteger layerCount = [mBoardView.layers count];
    for (int i = 0; i < layerCount; i++) {
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"Layer %d", i + 1]];
    }
    if (layerCount < 5) {
        [actionSheet addButtonWithTitle:@"Add Layer"];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)showShapePicker {
    actionSheetMode = DBActionSheetShape;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:@"Ellipse"];
    [actionSheet addButtonWithTitle:@"Rectangle"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheetMode == DBActionSheetLayer) {
        NSUInteger layerCount = [mBoardView.layers count];
        if (buttonIndex < layerCount) {
            mBoardView.currentLayer = buttonIndex;
        } else if (buttonIndex != actionSheet.cancelButtonIndex) {
            [mBoardView addNewLayer];
        }
    } else {
        switch (buttonIndex) {
            case 0:
                mBoardView.state = DBBoardStateCircle;
                break;
            case 1:
                mBoardView.state = DBBoardStateRectangle;
                break;
        }
    }
}

- (void)dealloc {
    [mColor release]; mColor = nil;
    [mBoardView release]; mBoardView = nil;
    [mSlider release]; mSlider = nil;
    [mToolBar release]; mToolBar = nil;
    [colorPickerVC release]; colorPickerVC = nil;
    [super dealloc];
}

@end
