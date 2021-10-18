//
//  VESyncContainerView.m
//  VE
//
//  Created by apple on 2020/1/13.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VESyncContainerView.h"
#import "VEPasterTextView.h"


@interface VESyncContainerView()<UIGestureRecognizerDelegate>
{
    BOOL isRecognizer;
}
@end

@implementation VESyncContainerView

- (void)contentTapped:(UITapGestureRecognizer*)tapGesture
{
    if( _currentPasterTextView )
    {
        VEPasterTextView * PasterText = (VEPasterTextView *)_currentPasterTextView;
        [PasterText contentTapped:tapGesture];
    }
}

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer
{
    if( _currentPasterTextView )
    {
        VEPasterTextView * PasterText = (VEPasterTextView *)_currentPasterTextView;
        [PasterText pinchGestureRecognizer:recognizer];
    }
}

-(void)moveGesture:(UIGestureRecognizer *) recognizer
{
    if( _currentPasterTextView )
    {
        VEPasterTextView * PasterText = (VEPasterTextView *)_currentPasterTextView;
        [PasterText moveGesture:recognizer];
    }
}

-(void)imageViewroRotation:(UIRotationGestureRecognizer *)rotation
{
    if( _currentPasterTextView )
    {
        VEPasterTextView * PasterText = (VEPasterTextView *)_currentPasterTextView;
        [PasterText Rotation_GestureRecognizer:rotation];
    }
}

-(void)pasterMidline:(UIView *) PasterTextView isHidden:(bool) ishidden
{
    VEPasterTextView * PasterText = (VEPasterTextView *)PasterTextView;
    
    float interval = 2;
    
    float width = 30;
    float height = 3;
    
    if( !ishidden && self )
    {
        float x = self.frame.size.width/2.0;
        float y = self.frame.size.height/2.0;
        
        CGPoint center = PasterText.center;
        
        if( ( center.x >= ( x - interval ) ) && ( center.x <= ( x + interval ) )  )
        {
            
            if( !_syncContainer_X_Left )
            {
                UIImageView*syncContainer_X_Left = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - height)/2.0, 0, height, width)];
                _syncContainer_X_Left = syncContainer_X_Left;
                _syncContainer_X_Left.backgroundColor = UIColorFromRGB(0xffffff);
                _syncContainer_X_Left.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
                _syncContainer_X_Left.layer.borderWidth = 0.5;
                [self addSubview:_syncContainer_X_Left];
                
                UIImageView *syncContainer_X_Right = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - height)/2.0, self.frame.size.height - width, height, width)];
                _syncContainer_X_Right = syncContainer_X_Right;
                _syncContainer_X_Right.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
                _syncContainer_X_Right.layer.borderWidth = 0.5;
                _syncContainer_X_Right.backgroundColor = UIColorFromRGB(0xffffff);
                [self addSubview:_syncContainer_X_Right];
            }
            
            _syncContainer_X_Right.hidden = NO;
            _syncContainer_X_Left.hidden = NO;
        }
        else
        {
            _syncContainer_X_Right.hidden = YES;
            _syncContainer_X_Left.hidden = YES;
        }
        
        if( ( center.y >= ( y - interval ) ) && ( center.y <= ( y + interval ) )  )
        {
            if( !_syncContainer_Y_Left )
            {
                UIImageView *syncContainer_Y_Left = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - height)/2.0, width, height)];
                _syncContainer_Y_Left = syncContainer_Y_Left;
                _syncContainer_Y_Left.backgroundColor = UIColorFromRGB(0xffffff);
                _syncContainer_Y_Left.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
                _syncContainer_Y_Left.layer.borderWidth = 0.5;
                [self addSubview:_syncContainer_Y_Left];
                
                UIImageView *syncContainer_Y_Right = [[UIImageView alloc] initWithFrame:CGRectMake( self.frame.size.width - width,  (self.frame.size.height - height)/2.0, width, height)];
                _syncContainer_Y_Right = syncContainer_Y_Right;
                _syncContainer_Y_Right.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
                _syncContainer_Y_Right.layer.borderWidth = 0.5;
                _syncContainer_Y_Right.backgroundColor = UIColorFromRGB(0xffffff);
                [self addSubview:_syncContainer_Y_Right];
            }
            
            _syncContainer_Y_Right.hidden = NO;
            _syncContainer_Y_Left.hidden = NO;
        }
        else{
            _syncContainer_Y_Right.hidden = YES;
            _syncContainer_Y_Left.hidden = YES;
        }
    }
    else{
        if( _syncContainer_Y_Right )
        {
            _syncContainer_Y_Right.hidden = YES;
            _syncContainer_Y_Left.hidden = YES;
        }
        if( _syncContainer_X_Right )
        {
            _syncContainer_X_Right.hidden = YES;
            _syncContainer_X_Left.hidden = YES;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if( [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ||
        [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
       )
        return  false;
    else
        return true;
}

-(void)setMark
{
    if( _syncContainer_X_Left )
    {
        [self addSubview:_syncContainer_Y_Left];
        [self addSubview:_syncContainer_Y_Right];
        
        [self addSubview:_syncContainer_X_Left];
        [self addSubview:_syncContainer_X_Right];
    }
    
    if( !isRecognizer )
    {
        isRecognizer = true;
        
        UIPinchGestureRecognizer *GestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
        GestureRecognizer.delegate = self;
        
        UIPanGestureRecognizer* moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
        [self addGestureRecognizer:moveGesture];
        
        [self addGestureRecognizer:GestureRecognizer];
        
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewroRotation:)];
        rotation.delegate = self;
        //手势View 对象 添加给UIImageView
        [self addGestureRecognizer:rotation];
        
        UITapGestureRecognizer *singleTapShowHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)];
        [self addGestureRecognizer:singleTapShowHide];
    }
}

- (void)dealloc{

    if( _syncContainer_Y_Right )
    {
        [_syncContainer_Y_Right removeFromSuperview];
        _syncContainer_Y_Right = nil;
        [_syncContainer_Y_Left removeFromSuperview];
        _syncContainer_Y_Left = nil;
        [_syncContainer_X_Right removeFromSuperview];
        _syncContainer_X_Right = nil;
        [_syncContainer_X_Left removeFromSuperview];
        _syncContainer_X_Left = nil;
    }
}
@end
