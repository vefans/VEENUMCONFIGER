//
//  Adjust_CurveView.h
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/4/24.
//

#import <UIKit/UIKit.h>

@class Adjust_CurveGraphView;

@protocol Adjust_CurveGraphViewDelegate <NSObject>

- (void)addPoint:(CGPoint)point index:(NSInteger)index graphView:(Adjust_CurveGraphView *)graphView;

@end

@interface Adjust_CurveGraphView : UIView

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) NSMutableArray *points;

@property (nonatomic, strong) NSMutableArray *rgbPoints;

@property (nonatomic, weak) id<Adjust_CurveGraphViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame points:(NSMutableArray *)points lineColor:(UIColor *)color;

- (void)drawRect:(CGRect)rect;

@end

@class Adjust_CurveView;

@protocol Adjust_CurveViewDelegate <NSObject>

- (void)changingAdjustCurve;

- (void)resetAdjustCurve:(Adjust_CurveView *)view;

- (void)completionAdjustCurve:(Adjust_CurveView *)view;

@end

@interface Adjust_CurveView : UIView

@property (nonatomic, strong) NSMutableArray <NSMutableArray *>*points;

@property (nonatomic, weak) id<Adjust_CurveViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame points:(NSMutableArray *)points;

@end
