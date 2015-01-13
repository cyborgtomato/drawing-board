//
//  DBBoardView.m
//  DrawingBoard
//
//  Created by Sergei Smagleev on 07/11/14.
//  Copyright (c) 2014 Sergei Smagleev. All rights reserved.
//

#import "DBBoardView.h"

@interface DBBoardView () {
    NSMutableArray *drawViews;
    UIImage *tempImage;
    CGPoint currentPoint;
    CGPoint lastPoint;
    
    NSUInteger m_currentLayer;
}

@end

@implementation DBBoardView

@synthesize currentLayer = m_currentLayer, layers = drawViews;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        drawViews = [NSMutableArray new];
        UIImageView *layer = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        [self addSubview:layer];
        [drawViews addObject:layer];

        self.state = DBBoardStateBrush;
        m_currentLayer = 0;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    lastPoint = [[touches anyObject] locationInView:self];
    currentPoint = [[touches anyObject] locationInView:self];
    [tempImage release];
    tempImage = [((UIImageView *)drawViews[m_currentLayer]).image retain];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    currentPoint = [[touches anyObject] locationInView:self];
    switch(self.state) {
        case DBBoardStateBrush:
            [self drawBrush];
            break;
        case DBBoardStateEraser:
            [self drawEraser];
            break;
        case DBBoardStateCircle:
            [self drawCircle];
            break;
        case DBBoardStateRectangle:
            [self drawRectangle];
            break;
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)drawRectangle {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    [tempImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                blendMode:kCGBlendModeNormal
                    alpha:1.0];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.width );
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.color.CGColor);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    CGContextStrokeRect(UIGraphicsGetCurrentContext(),
                        CGRectMake(MIN(lastPoint.x, currentPoint.x),
                                   MIN(lastPoint.y, currentPoint.y),
                                   fabs(currentPoint.x - lastPoint.x),
                                   fabs(currentPoint.y - lastPoint.y)));
    ((UIImageView *)drawViews[m_currentLayer]).image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)drawCircle {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    [tempImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                blendMode:kCGBlendModeNormal
                    alpha:1.0];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.width );
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.color.CGColor);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    CGContextStrokeEllipseInRect(UIGraphicsGetCurrentContext(),
                                 CGRectMake(MIN(lastPoint.x, currentPoint.x),
                                            MIN(lastPoint.y, currentPoint.y),
                                            fabs(currentPoint.x - lastPoint.x),
                                            fabs(currentPoint.y - lastPoint.y)));
    ((UIImageView *)drawViews[m_currentLayer]).image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)drawBrush {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);

    [((UIImageView *)drawViews[m_currentLayer]).image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.width );
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.color.CGColor);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    ((UIImageView *)drawViews[m_currentLayer]).image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    lastPoint = currentPoint;
}

- (void)drawEraser {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    [((UIImageView *)drawViews[m_currentLayer]).image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.width );
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeDestinationOut);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    ((UIImageView *)drawViews[m_currentLayer]).image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    lastPoint = currentPoint;
}

- (void)addNewLayer {
    UIImageView *layer = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
    [self addSubview:layer];
    [drawViews addObject:layer];
    m_currentLayer = [drawViews indexOfObject:layer];
}

- (void)reset {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [((UIImageView *)drawViews[m_currentLayer]).image drawInRect:CGRectMake(0, 0,
                                                                            self.frame.size.width,
                                                                            self.frame.size.height)
                                                       blendMode:kCGBlendModeNormal
                                                           alpha:1.0];
    CGFloat white[]={1., 1.};
    CGContextSetFillColor(UIGraphicsGetCurrentContext(), white);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeDestinationOut);
    CGContextFillRect(UIGraphicsGetCurrentContext(), self.bounds);
    [drawViews enumerateObjectsUsingBlock:^(UIImageView *img, NSUInteger idx, BOOL *stop) {
        img.image = UIGraphicsGetImageFromCurrentImageContext();
    }];
    UIGraphicsEndImageContext();
}

- (void)dealloc {
    [tempImage release]; tempImage = nil;
    [drawViews release]; drawViews = nil;
    [super dealloc];
}

@end
