//
//  VESyncContainerView.h
//  VE
//
//  Created by iOS VESDK Team on 2020/1/13.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VESyncContainerView;
@protocol VESyncContainerViewDelegate <NSObject>
-(void)selectePasterTextView:( UITapGestureRecognizer * ) tapGesture atView:( VESyncContainerView * ) view;
-(void)cancel_selectePasterTextView:( VESyncContainerView * ) view;
-(void)oldSelectePasterTextView:( UIView * ) oldPasterTextView;
@end

@interface VESyncContainerView : UIView

@property(nonatomic, weak)UIImageView      *picturePreImageView;
-(CGRect)getPreImageViewFrame;
-(CGRect)getPreImageViewBounds;

@property(nonatomic,weak)UIImageView       *syncContainer_X_Left;
@property(nonatomic,weak)UIImageView       *syncContainer_X_Right;

@property(nonatomic,weak)UIImageView       *syncContainer_Y_Left;
@property(nonatomic,weak)UIImageView       *syncContainer_Y_Right;

@property(nonatomic, assign)BOOL               isNoPasterMidline;

@property(nonatomic,weak)UIView *currentPasterTextView;

@property(nonatomic, assign)BOOL               isCalculateSelected;

@property (weak, nonatomic) id<VESyncContainerViewDelegate>   delegate;

-(void)pasterMidline:(UIView *) PasterTextView isHidden:(bool) ishidden;
-(void)setMark;

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer;

- (void)contentTapped:(UITapGestureRecognizer*)tapGesture;

-(void)Cancel_selectePasterTextView;
-(CGRect)getFrame;
@property(nonatomic, assign)BOOL isMask;
@end
