//
//  VEVideoCropView.m
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import "VEVideoCropView.h"

@implementation VEVideoCropView

#pragma mark - 1.Life Cycle

-(instancetype)initWithFrame:(CGRect)frame withVideoCropType:(VEVideoCropType)videoCropType{
    self = [super initWithFrame:frame];
    if (self) {
        self.videoCropType = videoCropType;
        [self setupViews];
        if( [VEConfigManager sharedManager].isPictureEditing )
        {
            self.backgroundColor = [UIColor whiteColor];
        }
    }
    return self;
}
-(void)setVideoSize:(CGSize)videoSize{
    _videoSize = videoSize;
    _cropView.videoSize = _videoSize;
    if (_videoSize.width >= _videoSize.height) {
        float videoSizeWidth = _videoRect.size.width;
        float videoSizeHeight = videoSizeWidth*(_videoSize.height/_videoSize.width);
        self.cropView.videoFrame = CGRectMake(_videoRect.origin.x, (self.frame.size.height - videoSizeHeight)/2, videoSizeWidth, videoSizeHeight);
        if(self.frame.size.height < videoSizeHeight){
            float videoSizeHeight = _videoRect.size.height;
            float videoSizeWidth = videoSizeHeight * (_videoSize.width/_videoSize.height);
            self.cropView.videoFrame = CGRectMake((self.frame.size.width - videoSizeWidth)/2.0, (self.frame.size.height - videoSizeHeight)/2, videoSizeWidth, videoSizeHeight);

        }
        
    }else if(_videoSize.width < _videoSize.height){
        float videoSizeHeight = _videoRect.size.height;
        float videoSizeWidth = videoSizeHeight*(_videoSize.width/_videoSize.height);
        self.cropView.videoFrame = CGRectMake((self.frame.size.width -videoSizeWidth)/2 , _videoRect.origin.y, videoSizeWidth, videoSizeHeight);
        
    }
}

-(void)setVideoRect:(CGRect)videoRect{
    _videoRect = videoRect;
}
//-(CGSize)videoFrameSize{
//    self.videoFrameSize
//}

#pragma mark - 2.Setting View and Style

- (void)setupViews{
    if ( self.videoCropType == VEVideoCropType_Crop) {
        [self addSubview:self.videoView];
        [self addSubview:self.cropView];
    }else if( self.videoCropType == VEVideoCropType_Dewatermark){
        [self addSubview:self.cropView];
    }
    else if( self.videoCropType == VEVideoCropType_FixedCrop)
    {
        [self addSubview:self.videoView];
        [self addSubview:self.cropView];
        [self.cropView setEnabled:NO];
    }
}

- (VECropView *)cropView{
    if (_cropView == nil) {
        if( self.videoCropType == VEVideoCropType_Dewatermark){
            _cropView = [[VECropView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)withVideoCropType:self.videoCropType];
       }
        else if( (self.videoCropType == VEVideoCropType_Crop)
                || (  self.videoCropType == VEVideoCropType_FixedCrop  )) {
            _cropView = [[VECropView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)withVideoCropType:self.videoCropType];
        }
    }
    return _cropView;
}

-(UIView *)videoView{
    if (_videoView == nil) {
        if( (self.videoCropType == VEVideoCropType_Crop)
            || (  self.videoCropType == VEVideoCropType_FixedCrop  )) {
            _videoView = [[UIView alloc] initWithFrame:CGRectMake(3, 3, self.frame.size.width-6, self.frame.size.height-6)];
            _videoRect = _videoView.frame;
        }else{
            _videoView = [[UIView alloc] initWithFrame:CGRectMake(11, 11, self.frame.size.width-22, self.frame.size.height-22)];
        }
        
    }
    return _videoView;
}




#pragma mark - 3 Data


#pragma mark - 4.Custom Methods


#pragma mark - 5.DataSource and Delegate


#pragma mark - 6.Set & Get

@end
