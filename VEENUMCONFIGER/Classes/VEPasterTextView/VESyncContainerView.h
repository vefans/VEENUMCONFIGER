//
//  VESyncContainerView.h
//  VE
//
//  Created by iOS VESDK Team on 2020/1/13.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VEDrawLineView : UIView

@property(nonatomic, assign) CGPoint topLeft;
@property(nonatomic, assign) CGPoint topRight;
@property(nonatomic, assign) CGPoint bottomLeft;
@property(nonatomic, assign) CGPoint bottomRight;

@end


@class VESyncContainerView;
@protocol VESyncContainerViewDelegate <NSObject>
-(void)selectePasterTextView:( UITapGestureRecognizer * ) tapGesture atView:( VESyncContainerView * ) view;
-(void)cancel_selectePasterTextView:( VESyncContainerView * ) view;
-(void)oldSelectePasterTextView:( UIView * ) oldPasterTextView;

-(void)magnifyingGlassTrack_Move:( UIPanGestureRecognizer * ) recognizer;
-(void)magnifyingGlassTrack_Angle:( UIRotationGestureRecognizer * ) recognizer;
-(void)magnifyingGlassTrack_Scale:( UIPinchGestureRecognizer * ) recognizer;
-(void)magnifyingGlassTrack_Click:( UITapGestureRecognizer * ) tapGesture;
@end

@interface VESyncContainerView : UIView

@property(nonatomic, weak) UIImageView *trackAreaImageView;

@property(nonatomic, assign)BOOL isMagnifyingGlassTrack;

@property(nonatomic,strong)UIPanGestureRecognizer* moveGesture;
@property(nonatomic,strong)UIPinchGestureRecognizer *gestureRecognizer;
@property(nonatomic,strong)UIRotationGestureRecognizer *rotationGesture;
@property(nonatomic, weak)UIImageView      *picturePreImageView;
@property(nonatomic, weak)VEDrawLineView      *lineView;
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
@property(nonatomic, assign)BOOL               isSplice;

-(void)releaseTrackArea;

#pragma mark- 放大镜
@property(nonatomic, weak) UIView *magnifyingGlassCenterView;
@property(nonatomic, weak) UIView *magnifyingGlassMaskCenterView;

- (void)releaseLineView;

@end
