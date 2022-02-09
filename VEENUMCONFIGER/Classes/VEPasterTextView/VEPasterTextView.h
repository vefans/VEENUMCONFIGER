//
//  VETextView.h
//  VE
//
//  Created by iOS VESDK Team on 16/4/14.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESyncContainerView.h"
#import "VEPasterLabel.h"

@class VEPasterTextView;
@protocol VEPasterTextViewDelegate <NSObject>

-(void)pasterView_PitchUp:( VEPasterTextView * _Nullable ) sticker atHidden:(BOOL) isHidden;

- (void)pasterViewDidClose:(VEPasterTextView *_Nullable)sticker;
- (void)pasterViewDidChangeFrame:(VEPasterTextView *_Nullable)sticker;
- (void)pasterViewMoved:(VEPasterTextView *_Nullable)sticker;
- (void)pasterViewSizeScale:(VEPasterTextView *_Nullable)sticker atValue:( float ) value;
//是否显示字幕文字编辑界面
- (void)pasterViewShowText:(VEPasterTextView *_Nullable)sticker;
//背景 画布 中线显示
//-(void)pasterMidline:(VEPasterTextView * _Nullable) canvas_PasterText isHidden:(bool) ishidden;

//抠图颜色提取返回函数
-(void)paster_CutoutColor:(VEPasterTextView * _Nullable) cutOut_PasterText  atColorRed:(float) colorRed atColorGreen:(float) colorGreen atColorBlue:(float) colorBlue atAlpha:(float) colorApha isRefresh:(BOOL) isRefresh;

-(void)DoubleClick_pasterViewShowText:(VEPasterTextView *_Nullable)sticker;

@end

@interface VEPasterTextView : UIView

@property( nonatomic, assign ) BOOL isPressTouch;

@property(nonatomic, assign)BOOL    isMainPicture;

@property(nonatomic, assign) BOOL   isTextTemplateEdit;

@property(nonatomic, assign)BOOL    isPESDK;

-(UIImageView *_Nullable)getselectImageView;

@property (assign, nonatomic) CGRect contentsCenter_Rect;

@property(assign, nonatomic)BOOL        isFixedCrop;    //是否固定裁剪
@property( assign, nonatomic )CGRect    cropRect;

@property (nonatomic,weak) VESyncContainerView            * _Nullable syncContainer;


@property( nonatomic, assign )BOOL  isSizePrompt;

@property( nonatomic, strong)id _Nullable media;
@property( nonatomic, strong)id _Nullable backgroundMedia;
@property( nonatomic, strong)id _Nullable superposiMedia;


@property (nonatomic, weak) UIButton * _Nullable textEditBtn;
@property (nonatomic, strong) UIButton * _Nullable closeBtn;

@property (nonatomic, strong)UIButton * _Nullable alignBtn;
-(void)addCopyBtn;

@property (nonatomic, weak)UIButton  * _Nullable TextEditBtn;

//@property (nonatomic, strong)Caption * _Nullable caption;
@property (nonatomic, strong)CaptionEx * _Nullable captionSticker;

@property (nonatomic, strong)NSString   * _Nullable captionExCover;
@property (nonatomic, strong)CaptionEx * _Nullable captionSubtitle;
@property (nonatomic, assign)NSInteger   captionTextIndex;
@property (nonatomic, assign)CGRect  tOutRect;

@property (nonatomic, strong)NSMutableArray<UIButton *> * _Nullable textEditBtnArray;
@property (nonatomic, strong)NSMutableArray * _Nullable textEditBtnLayerArrary;
-(void)addTextEditBoxEx:(CGRect) rect;
-(void)textEdit_BtnEx:(UIButton * _Nullable) btn;
-(void)refreshTextEidtFrameEx;

@property (nonatomic,assign)  BOOL          isMirror;
@property (nonatomic, strong) UIButton * _Nullable mirrorBtn;
@property (copy, nonatomic) NSString                      * _Nullable fontName;
@property (copy, nonatomic) NSString                      * _Nullable fontCode;
@property (copy, nonatomic) NSString                      * _Nullable fontPath;
@property (assign, nonatomic) CGFloat                        fontSize;
@property (nonatomic, strong) UIView                        * _Nullable labelBgView;
@property (strong, nonatomic) VEPasterLabel                 * _Nullable contentLabel;
@property (strong, nonatomic) VEPasterLabel                 * _Nullable shadowLbl;
@property (strong, nonatomic) UIImageView                   * _Nullable contentImage;
@property (weak, nonatomic,nullable) id<VEPasterTextViewDelegate>   delegate;
@property (assign, nonatomic) BOOL                           isShowingEditingHandles;
@property (assign, nonatomic) BOOL                           needStretching;
@property (assign, nonatomic) float                          fps;
@property (assign, nonatomic) NSInteger                      typeIndex;
@property (assign, nonatomic) NSInteger                      typeLabelIndex;
@property (assign, nonatomic) BOOL                           isHiddenAlignBtn;
@property (assign, nonatomic) NSTextAlignment                alignment;
@property (copy, nonatomic , nullable ) NSString                       *pText;

@property (nonatomic,assign) BOOL                           isLabelHeight;
@property (nonatomic,assign) CGSize tsize;
@property (nonatomic,assign) float rectW;//配置文件中，初始字幕大小，相对于实际视频size的字幕大小(0.0〜1.0)

@property(nonatomic , assign)BOOL isCanCurrent;

@property (nonatomic,assign) BOOL                           isCutout;       //是否为抠图
@property (nonatomic,assign) float                          cutout_Height;
@property (nonatomic,assign) float                          cutoutHeight;
@property (assign, nonatomic) NSInteger                      mirrorType;
//设置x放大镜
-(void)setCutoutMagnifier:(bool) isCutout;
//放大镜
@property (nonatomic,strong,nullable) UIView                         *cutout_MagnifierView;
//放大区域
@property (nonatomic,strong) UIImageView                    * _Nullable cutout_ZoomAreaView;
//原始区域
@property (nonatomic,strong) UIImageView                    * _Nullable cutout_RealAreaView;
@property (nonatomic,strong,nullable) UILabel * cutout_label1;
@property (nonatomic,strong,nullable) UILabel * cutout_label2;

/**文字字体加粗，默认为NO*/
@property (nonatomic ,assign) BOOL isBold;
/**文字字体斜体，默认为NO*/
@property (nonatomic ,assign) BOOL isItalic;
/**文字字体阴影，默认为NO*/
@property (nonatomic ,assign) BOOL isShadow;
/**文字阴影颜色，默认黑色*/
@property (nonatomic ,strong) UIColor * _Nullable shadowColor;
/**文字阴影偏移量,默认为CGSizeMake(0, -1)*/
@property (nonatomic ,assign) CGSize shadowOffset;
/** 文字竖排，默认为NO*/
@property (nonatomic ,assign) BOOL isVerticalText;

@property (nonatomic, assign) CGSize                        textLabelSize;

@property (copy, nonatomic, nullable) NSString                       *pname;

- (instancetype _Nullable )initWithFrame:(CGRect)frame
               superViewFrame:(CGRect)superRect
                 contentImage:(UIImageView * _Nullable)contentImageView
            syncContainerRect:(CGRect)syncContainerRect;

- (instancetype _Nullable)initWithFrame:(CGRect)frame
             pasterViewEnbled:(BOOL)pasterViewEnbled
               superViewFrame:(CGRect)superRect
                 contentImage:(UIImageView * _Nullable)contentImageView
                    textLabel:(UILabel * _Nullable)textLabel
                     textRect:(CGRect )textRect
                      ectsize:(CGSize )tsize
                         ect:(CGRect )t
               needStretching:(BOOL)needStretching
                  onlyoneLine:(BOOL)onlyoneLine
                    textColor:(UIColor * _Nullable)textColor
                  strokeColor:(UIColor * _Nullable)strokeColor
                   strokeWidth:(float)strokeWidth
            syncContainerRect:(CGRect)syncContainerRect
                    isRestore:(BOOL)isREstroe;

-(instancetype)initWithFrame:(CGRect)frame
              superViewFrame:(CGRect)superRect
                contentImage:(UIImageView *)contentImageView
           syncContainerRect:(CGRect)syncContainerRect
                   isRestore:(BOOL)isREstroe;

- (void) hideEditingHandles;
- (void) showEditingHandles;
- (void) setFontName:(NSString * _Nullable)fontName;
- (void) setTextString: (NSString * _Nullable) text adjustPosition:(BOOL)adjust;
- (void) setAttributedString:(NSMutableAttributedString * _Nullable)attributedString isBgCaption:(BOOL)isBgCaption adjustPosition:(BOOL)adjust;
- (void) setFramescale:(float)value;
- (float)getFramescale;
- (NSInteger)getTextAlign;
- (void)refreshBounds:(CGRect)bounds;
- (void)setContentImageTransform:(CGAffineTransform)transform;

//+(CGRect)solveUIWidgetFuzzy:(CGRect) oldFrame;

-(float) selfscale;

-(void)getrotateViewHidden;

//背景 画布
-(void)setCanvasPasterText:(BOOL) isCanvas;
//设置最小倍数
-(void)setMinScale:(float) scale;
@property (nonatomic ,assign)float minScale;

//
@property (nonatomic, assign)bool isDrag;
@property (nonatomic, assign)BOOL isDrag_Upated;

@property (nonatomic, assign)BOOL isScale;

@property (nonatomic, assign)float dragaAlpha;

//加水印
-(void)setWatermarkPasterText:(BOOL) isWatermark;
@property (nonatomic,assign)float waterMaxScale;

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer * _Nullable)recognizer;
- (void) moveGesture:(UIGestureRecognizer * _Nullable) recognizer;
//- (void)pinchGestureRecognizer_Rotation:(UIPinchGestureRecognizer * _Nullable)recognizer;
-(void)Rotation_GestureRecognizer:(UIRotationGestureRecognizer * _Nullable)rotation;
-(void)setRotationGestureRecognizer;    //画中画
@property (nonatomic, assign)BOOL  isEditImage;
@property (nonatomic, assign)BOOL  isSubtitleView;
//界面拖拽功能 隐藏后能否 触发手势
@property (nonatomic, assign)BOOL  isViewHidden_GestureRecognizer;

-(UIImageView * _Nullable)getRotateView;

-(float)gettScale;

-(void)setTextEdit;

-(void)remove_Recognizer;

- (void)contentTapped:(UITapGestureRecognizer*)tapGesture;

@property (nonatomic, assign)BOOL   isCoverText;

-(void)addTextEditBox:(CGRect) rect;

-(float)getCropREct_Scale:(float) scale;
-(CGPoint)getCropRect_Center:(CGPoint) center;
@property (nonatomic, strong)CaptionEx * _Nullable old_captionSubtitle;
@property (nonatomic, assign)CGPoint  oldCenter;
@property (nonatomic, assign)CGAffineTransform  oldTransform;
@property (nonatomic, strong)NSDictionary  * _Nullable info;
@property (nonatomic, strong)NSDictionary  * _Nullable old_info;
@property (nonatomic, strong)NSString  * _Nullable old_cover;
@end


