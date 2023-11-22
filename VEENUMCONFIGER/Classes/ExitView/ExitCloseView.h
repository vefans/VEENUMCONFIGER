//
//  ExitCloseView.h
//  VEENUMCONFIGER
//
//  Created by mac on 2023/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ExitCloseView;

@protocol ExitCloseViewDelegate <NSObject>

- (void)saveChange:(ExitCloseView *)view;

- (void)noSaveChange:(ExitCloseView *)view;

- (void)cancelChange:(ExitCloseView *)view;

@end

@interface ExitCloseView : UIView

@property (nonatomic, strong) UIButton * saveBtn;
@property (nonatomic, strong) UIButton * noSaveBtn;
@property (nonatomic, strong) UIButton * cancelBtn;

@property (nonatomic,weak) id <ExitCloseViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
