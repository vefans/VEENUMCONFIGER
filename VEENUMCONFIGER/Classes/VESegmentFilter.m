//
//  VESegmentFilter.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/12/31.
//

#import "VESegmentFilter.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)


NSString*  const kJointBilateralVertexShader = SHADER_STRING
(
 attribute vec4 position;
 attribute vec2 inputTextureCoordinate;
 varying vec2 textureCoordinate;
 
 void main()
 {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate;
 }
 );

NSString* const kJointBilateralFragmentShader = SHADER_STRING
(
 precision highp float;
 varying highp vec2 textureCoordinate;

 
 uniform sampler2D u_RGBTexture;
 uniform sampler2D u_MaskTexture;
 uniform vec2 u_texelSize;
 uniform float u_step;
 uniform float u_radius;
 uniform float u_offset;
 uniform float u_sigmaTexel;
 uniform float u_sigmaColor;
 
 float gaussian(float x, float sigma) {
    float coeff = -0.5 / (sigma * sigma * 4.0 + 1.0e-6);
    return exp((x * x) * coeff);
}
 
 void main() {
    vec2 centerCoord = textureCoordinate;
    vec3 centerColor = texture2D(u_RGBTexture, centerCoord).rgb;
    float newVal = 0.0;
    
    float spaceWeight = 0.0;
    float colorWeight = 0.0;
    float totalWeight = 0.0;

    // Subsample kernel space.
    for (float i = -u_radius + u_offset; i <= u_radius; i += u_step) {
        for (float j = -u_radius + u_offset; j <= u_radius; j += u_step) {
            vec2 shift = vec2(j, i) * u_texelSize;
            vec2 coord = vec2(centerCoord + shift);
            vec3 frameColor = texture2D(u_RGBTexture, coord).rgb;
            float outVal = texture2D(u_MaskTexture, coord).a;
            
            spaceWeight = gaussian(distance(centerCoord, coord), u_sigmaTexel);
            colorWeight = gaussian(distance(centerColor, frameColor), u_sigmaColor);
            totalWeight += spaceWeight * colorWeight;
            
            newVal += spaceWeight * colorWeight * outVal;
        }
    }
    newVal /= totalWeight;
    
    gl_FragColor = vec4(vec3(1.), newVal);
    
}
 );


NSString*  const kLightWrapVertexShader = SHADER_STRING
(
 attribute vec4 position;
 attribute vec2 inputTextureCoordinate;
 varying vec2 textureCoordinate;
 
 void main()
 {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate;
 }
 );

NSString* const kLightWrapFragmentShader = SHADER_STRING
(

 
 precision highp float;
 varying vec2 textureCoordinate;
 
 uniform sampler2D u_RGBTexture;
 uniform sampler2D u_MaskTexture;
 uniform vec2 coverage;
 uniform float lightWrapping;
 uniform float blendMode;
 
 vec3 screen(vec3 a, vec3 b) {
    return 1.0 - (1.0 - a) * (1.0 - b);
}
 
 vec3 linearDodge(vec3 a, vec3 b) {
    return a + b;
}
 
 void main() {
    vec4 frame = texture2D(u_RGBTexture, textureCoordinate);
    vec3 frameColor = frame.rgb;
    vec3 backgroundColor = vec3(1.);
    float maskAlpha = texture2D(u_MaskTexture, textureCoordinate).a;
    float lightWrapMask = 1.0 - max(0.0, maskAlpha - coverage.y) / (1.0 - coverage.y);
    vec3 lightWrap = lightWrapping * lightWrapMask * backgroundColor;
    frameColor = blendMode * linearDodge(frameColor, lightWrap) +
    (1.0 - blendMode) * screen(frameColor, lightWrap);
    maskAlpha = smoothstep(coverage.x, coverage.y, maskAlpha);
    gl_FragColor = vec4(frameColor * maskAlpha + backgroundColor * (1.0 - maskAlpha), frame.a * maskAlpha);
}
 
 );

typedef struct OutputPixelBufferList
{
    CVPixelBufferRef outputPixelBuffer;
    struct OutputPixelBufferList *next;
    
}OutputPixelBufferList;

typedef struct FrameBufferObjectList
{
    int width ;
    int height;
    GLuint fbo;
    int index;
    char name[1024];
    struct FrameBufferObjectList* next;
    
}FrameBufferObjectList;

typedef struct TextureList
{
    int width ;
    int height;
    GLuint texture;
    int index;
    char name[1024];
    struct TextureList* next;

}TextureList;


typedef NS_ENUM(NSInteger, VESegmentStatu) {
    VESegment_Begin,
    VESegment_Finish,

};

@implementation VESegmentFilter
{
    CVOpenGLESTextureCacheRef _videoTextureCache;
    GLuint _vbo;
    EAGLContext* _curContext;
    GLuint _bilateralProgram;
    GLuint _bilateralVert,_bilateralFrag;
    GLuint _bilateralPositionAttribute,_bilateralTextureCoordinateAttribute;
    GLuint _bilateralInputTextureUniform;
    GLuint _bilateralInputMaskTextureUniform,_texelSizeUniform,_stepUniform;
    GLuint _radiusUniform,_offsetUniform,_sigmaTexelUniform,_sigmaColorUniform;
    //GLuint _maskTexture;
    
    
    //
    GLuint _lightWrapProgam;
    GLuint _lightWrapPositionAttribute,_lightWrapTextureCoordinateAttribute;
    GLuint _lightWrapVert,_lightWrapFrag;
    GLuint _lightWrapInputTextureUniform,_lightWrapInputMaskTextureUniform;
    GLuint _coverageUniform,_lightWrappingUniform,_blendModeUniform;
    
    OutputPixelBufferList *_pOutputPixelBufferList;
    FrameBufferObjectList* _pFBOList;
    TextureList* _pMaskTextureList;
    
    VESegmentStatu _statu;
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _curContext = NULL;
        _pOutputPixelBufferList = NULL;
        _videoTextureCache = NULL;
        _pFBOList = NULL;
        _statu = VESegment_Finish;
    }
    return self;
}

-(FrameBufferObjectList*)findTextureFBOFromList:(FrameBufferObjectList*)pTextureFBOList index:(int)index
{
    FrameBufferObjectList* pList = pTextureFBOList;
    FrameBufferObjectList* pNode = nil;
    if (!pList)
        return nil;
    while (pList) {
        if(pList->index == index)
        {
            pNode = pList;
            break;
        }
        pList = pList->next;
    }
    if(pNode)
        return pNode;
    return nil;
}

- (GLuint)textureFromBufferObject:(unsigned char *) image Width:(int )width Height:(int)height
{
    GLuint texture = 0;
    
    glEnable(GL_TEXTURE_2D);
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_BGRA, GL_UNSIGNED_BYTE, (GLvoid*)image);
    /**
     *  纹理过滤函数
     *  图象从纹理图象空间映射到帧缓冲图象空间(映射需要重新构造纹理图像,这样就会造成应用到多边形上的图像失真),
     *  这时就可用glTexParmeteri()函数来确定如何把纹理象素映射成像素.
     *  如何把图像从纹理图像空间映射到帧缓冲图像空间（即如何把纹理像素映射成像素）
     */
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE); // S方向上的贴图模式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE); // T方向上的贴图模式
    // 线性过滤：使用距离当前渲染像素中心最近的4个纹理像素加权平均值
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    
    return texture;
}

-(FrameBufferObjectList*)getTextureFBOListNodeWithWidth:(int)width height:(int)height
{
    FrameBufferObjectList* pList = _pFBOList;
    FrameBufferObjectList* pNode = NULL;
    
    if(width<=0 || height<=0)
        return NULL;
    
    if (!pList)
    {
        _pFBOList = (FrameBufferObjectList*)malloc(sizeof(FrameBufferObjectList));
        memset(_pFBOList, 0, sizeof(FrameBufferObjectList));
        pNode = _pFBOList;
    }
    else
    {
        pList = _pFBOList;
        while (pList) {
            if(pList->width == width && pList->height == height)
                break;
            pList = pList->next;
        }
        if(!pList)
        {
            pList = _pFBOList;
            while (pList && pList->next)
                pList = pList->next;
            pList->next = (FrameBufferObjectList*)malloc(sizeof(FrameBufferObjectList));
            memset(pList->next, 0, sizeof(FrameBufferObjectList));
            pNode = pList->next;
        }
        else
            return pList;
    }

    
    if (pNode->width != width || pNode->height != height) {
        if(pNode->fbo)
            glDeleteFramebuffers(1, &pNode->fbo);
        
        pNode->width = width;
        pNode->height = height;
        glGenFramebuffers(1, &pNode->fbo);

    }
    
    
    return pNode;
}

-(CVPixelBufferRef)getOutPutPixelBufferFromWidth:(int)width height:(int)height clearDate:(BOOL)clearDate
{
    OutputPixelBufferList *pNode = nil;
    if(width <= 0 || height <=0 )
        return nil;
    if (!_pOutputPixelBufferList) {
        _pOutputPixelBufferList = (OutputPixelBufferList*)malloc(sizeof(OutputPixelBufferList));
        memset(_pOutputPixelBufferList, 0, sizeof(OutputPixelBufferList));
        pNode = _pOutputPixelBufferList;
    }
    else
    {
        pNode = _pOutputPixelBufferList;
        while (pNode) {
            int w = (int)CVPixelBufferGetWidth(pNode->outputPixelBuffer);
            int h = (int)CVPixelBufferGetHeight(pNode->outputPixelBuffer);
            if(w == width && h == height)
                break;
            pNode = pNode->next;
        }
        if(!pNode)
        {
            pNode = _pOutputPixelBufferList;
            while (pNode && pNode->next)
                pNode = pNode->next;
            pNode->next = (OutputPixelBufferList*)malloc(sizeof(OutputPixelBufferList));
            memset(pNode->next, 0, sizeof(OutputPixelBufferList));
            pNode = pNode->next;
        }
    }
  
    if(!pNode->outputPixelBuffer || width != CVPixelBufferGetWidth(pNode->outputPixelBuffer) || height != CVPixelBufferGetHeight(pNode->outputPixelBuffer))
    {
        //如果 outputPixelBuffer 作为临时局部变量不停的alloc/release，导出4k视频内存会暴涨崩溃，1080p却正常
        if(pNode->outputPixelBuffer)
        {
            CVPixelBufferRelease(pNode->outputPixelBuffer);
            pNode->outputPixelBuffer = nil;
        }
        NSDictionary *pixelAttributes = [NSDictionary dictionaryWithObject:@{} forKey:(NSString *)kCVPixelBufferIOSurfacePropertiesKey];
        CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
                                              width,
                                              height,
                                              kCVPixelFormatType_32BGRA,
                                              (__bridge CFDictionaryRef)pixelAttributes,
                                              &pNode->outputPixelBuffer);

        
        if (result != kCVReturnSuccess){
            NSLog(@"Unable to create cvpixelbuffer %d", result);
            return 0;
        }
    }
    
    if(clearDate)
    {
        CVPixelBufferLockBaseAddress(pNode->outputPixelBuffer, 0);
        size_t w = CVPixelBufferGetWidth(pNode->outputPixelBuffer);
        size_t h = CVPixelBufferGetHeight(pNode->outputPixelBuffer);
        size_t bytePerRow = CVPixelBufferGetBytesPerRow(pNode->outputPixelBuffer);
        uint8_t *pAddress = (uint8_t *)CVPixelBufferGetBaseAddress(pNode->outputPixelBuffer);
        memset(pAddress, 0, bytePerRow*h);
        CVPixelBufferUnlockBaseAddress(pNode->outputPixelBuffer, 0);
    }
    
    
    return pNode->outputPixelBuffer;
}
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(NSString *)sourceString
{
    if (sourceString == nil) {
        NSLog(@"Failed to load vertex shader: Empty source string");
        return NO;
    }
    
    GLint status;
    const GLchar *source;
    source = (GLchar *)[sourceString UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}
- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)loadShaders
{
    
    _bilateralProgram = glCreateProgram();
    _lightWrapProgam = glCreateProgram();

    if (![self compileShader:&_bilateralVert type:GL_VERTEX_SHADER source:kJointBilateralVertexShader]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    
    if (![self compileShader:&_bilateralFrag type:GL_FRAGMENT_SHADER source:kJointBilateralFragmentShader]) {
        NSLog(@"Failed to compile cust fragment shader");
        return NO;
    }
    
    if (![self compileShader:&_lightWrapVert type:GL_VERTEX_SHADER source:kLightWrapVertexShader]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    
    if (![self compileShader:&_lightWrapFrag type:GL_FRAGMENT_SHADER source:kLightWrapFragmentShader]) {
        NSLog(@"Failed to compile cust fragment shader");
        return NO;
    }
    
    glAttachShader(_bilateralProgram, _bilateralVert);
    glAttachShader(_bilateralProgram, _bilateralFrag);
    glAttachShader(_lightWrapProgam, _lightWrapVert);
    glAttachShader(_lightWrapProgam, _lightWrapFrag);
    
    
    if (![self linkProgram:_bilateralProgram] ||
        ![self linkProgram:_lightWrapProgam]) {
        
        if (_bilateralVert) {
            glDetachShader(_bilateralProgram, _bilateralVert);
            glDeleteShader(_bilateralVert);
            _bilateralVert = 0;
        }
        if (_bilateralFrag) {
            glDetachShader(_bilateralProgram, _bilateralFrag);
            glDeleteShader(_bilateralFrag);
            _bilateralFrag = 0;
        }
        if (_lightWrapVert) {
            glDetachShader(_lightWrapProgam, _lightWrapVert);
            glDeleteShader(_lightWrapVert);
            _lightWrapVert = 0;
        }
        if (_lightWrapFrag) {
            glDetachShader(_lightWrapProgam, _lightWrapFrag);
            glDeleteShader(_lightWrapFrag);
            _lightWrapFrag = 0;
        }
        
        return NO;
    }
    
    
    _bilateralPositionAttribute = glGetAttribLocation(_bilateralProgram, "position");
    _bilateralTextureCoordinateAttribute = glGetAttribLocation(_bilateralProgram, "inputTextureCoordinate");
    _bilateralInputTextureUniform = glGetUniformLocation(_bilateralProgram, "u_RGBTexture");
    _bilateralInputMaskTextureUniform = glGetUniformLocation(_bilateralProgram, "u_MaskTexture");
    _texelSizeUniform = glGetUniformLocation(_bilateralProgram, "u_texelSize");
    _stepUniform = glGetUniformLocation(_bilateralProgram, "u_step");
    _radiusUniform = glGetUniformLocation(_bilateralProgram, "u_radius");
    _offsetUniform = glGetUniformLocation(_bilateralProgram, "u_offset");
    _sigmaTexelUniform = glGetUniformLocation(_bilateralProgram, "u_sigmaTexel");
    _sigmaColorUniform = glGetUniformLocation(_bilateralProgram, "u_sigmaColor");
    
    
    _lightWrapPositionAttribute = glGetAttribLocation(_lightWrapProgam, "position");
    _lightWrapTextureCoordinateAttribute = glGetAttribLocation(_lightWrapProgam, "inputTextureCoordinate");
    _lightWrapInputTextureUniform = glGetUniformLocation(_lightWrapProgam, "u_RGBTexture");
    _lightWrapInputMaskTextureUniform = glGetUniformLocation(_lightWrapProgam, "u_MaskTexture");
    _sigmaColorUniform = glGetUniformLocation(_lightWrapProgam, "coverage");
    _lightWrappingUniform = glGetUniformLocation(_lightWrapProgam, "lightWrapping");
    _blendModeUniform = glGetUniformLocation(_lightWrapProgam, "blendMode");
    
    
    // Release vertex and fragment shaders.
    if (_bilateralVert) {
        glDetachShader(_bilateralProgram, _bilateralVert);
        glDeleteShader(_bilateralVert);
        _bilateralVert = 0;
    }
    if (_bilateralFrag) {
        glDetachShader(_bilateralProgram, _bilateralFrag);
        glDeleteShader(_bilateralFrag);
        _bilateralFrag = 0;
    }
    
    if (_lightWrapVert) {
        glDetachShader(_lightWrapProgam, _lightWrapVert);
        glDeleteShader(_lightWrapVert);
        _lightWrapVert = 0;
    }
    if (_lightWrapFrag) {
        glDetachShader(_lightWrapProgam, _lightWrapFrag);
        glDeleteShader(_lightWrapFrag);
        _lightWrapFrag = 0;
    }
    
    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _curContext, NULL, &_videoTextureCache);
    if (err != noErr) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
    }
    
    return YES;
}

- (CVOpenGLESTextureRef)customTextureForPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    CVOpenGLESTextureRef bgraTexture = NULL;
    CVReturn err;
    
    if (!_videoTextureCache ) {
        NSLog(@"No video texture cache");
        goto bail;
    }
    
    {
        CVOpenGLESTextureCacheFlush(_videoTextureCache, 0);
        
        err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                           _videoTextureCache,
                                                           pixelBuffer,
                                                           NULL,
                                                           GL_TEXTURE_2D,
                                                           GL_RGBA,
                                                           (int)CVPixelBufferGetWidth(pixelBuffer),
                                                           (int)CVPixelBufferGetHeight(pixelBuffer),
                                                           GL_BGRA,
                                                           GL_UNSIGNED_BYTE,
                                                           0,
                                                           &bgraTexture);
        
        if (!bgraTexture || err) {
            NSLog(@"Error creating BGRA texture using CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
        }
    }
bail:
    return bgraTexture;
}
-(UIImage*)getImageFromRGBA:(GLubyte*)pixel width:(int)w height:(int)h
{
    int perPix = 4;
    int width = w;
    int height = h;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(pixel, width, height, 8,width * perPix,colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef frame = CGBitmapContextCreateImage(newContext);
    UIImage* image = [UIImage imageWithCGImage:frame];
    
    CGImageRelease(frame);
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    return image;
    
}
-(TextureList*)getTextureFromWidth:(int)width height:(int)height
{
    TextureList* pList = _pMaskTextureList;
    TextureList* pNode = NULL;
    
    if(width<=0 || height<=0)
        return NULL;
    
    if (!pList)
    {
        _pMaskTextureList = (TextureList*)malloc(sizeof(TextureList));
        memset(_pMaskTextureList, 0, sizeof(TextureList));
        pNode = _pMaskTextureList;
    }
    else
    {
        pList = _pMaskTextureList;
        while (pList) {
            if(pList->width == width && pList->height == height)
                break;
            pList = pList->next;
        }
        if(!pList)
        {
            pList = _pMaskTextureList;
            while (pList && pList->next)
                pList = pList->next;
            pList->next = (TextureList*)malloc(sizeof(TextureList));
            memset(pList->next, 0, sizeof(TextureList));
            pNode = pList->next;
        }
        else
            return pList;
    }

    
    if (pNode->width != width || pNode->height != height) {
        
       
        if(pNode->texture)
            glDeleteTextures(1, &pNode->texture);
        
        pNode->width = width;
        pNode->height = height;
        pNode->texture = 0;
        
        
    }
    return pNode;
    
}
-(GLuint)updateTextureFromPixelBuffer:(CVPixelBufferRef)mask isBGRA:(BOOL)isBGRA
{
    int ww = (int)CVPixelBufferGetWidth(mask);
    int hh = (int)CVPixelBufferGetHeight(mask);
    int bytesPerRow = (int)CVPixelBufferGetBytesPerRow(mask);
    unsigned char* pp = (unsigned char*)malloc(ww*hh*4);
    CVPixelBufferLockBaseAddress(mask, 0);
    
    if(isBGRA)
    {
        unsigned char * maskAddress = (unsigned char *)CVPixelBufferGetBaseAddress(mask);
        if(ww*4 == bytesPerRow)
            memcpy(pp, maskAddress, ww*hh*4);
        else
        {
            
            for (int i = 0; i < hh; i++)
                memcpy(pp + i * (int)ww * 4, maskAddress + i * bytesPerRow, ww * 4);
        }
        
        
    }
    else
    {
        float *maskAddress = (float *)CVPixelBufferGetBaseAddress(mask);
        int dstWidth = bytesPerRow/4.0;
        for (int i = 0; i < hh; i++) {
            for (int j = 0; j<ww; j++) {
                pp[i*ww*4+j*4+0] = maskAddress[i*dstWidth+j]*255;
                pp[i*ww*4+j*4+1] = maskAddress[i*dstWidth+j]*255;
                pp[i*ww*4+j*4+2] = maskAddress[i*dstWidth+j]*255;
                pp[i*ww*4+j*4+3] = maskAddress[i*dstWidth+j]*255;
            }
        }
    }
    
    CVPixelBufferUnlockBaseAddress(mask, 0);
    
    TextureList* pList = [self getTextureFromWidth:ww height:hh];
    
    glEnable(GL_TEXTURE_2D);
    if(!pList->texture)
        glGenTextures(1, &pList->texture);
    glBindTexture(GL_TEXTURE_2D, pList->texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)ww, (int)hh, 0, GL_BGRA, GL_UNSIGNED_BYTE, (GLvoid*)pp);
    /**
     *  纹理过滤函数
     *  图象从纹理图象空间映射到帧缓冲图象空间(映射需要重新构造纹理图像,这样就会造成应用到多边形上的图像失真),
     *  这时就可用glTexParmeteri()函数来确定如何把纹理象素映射成像素.
     *  如何把图像从纹理图像空间映射到帧缓冲图像空间（即如何把纹理像素映射成像素）
     */
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE); // S方向上的贴图模式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE); // T方向上的贴图模式
    // 线性过滤：使用距离当前渲染像素中心最近的4个纹理像素加权平均值
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    free(pp);
    return pList->texture;
}
    
-(CVPixelBufferRef)processJointBilateralFromPixelBuffer:(CVPixelBufferRef)pixel maskPixelBuffer:(CVPixelBufferRef)mask
{
    GLfloat verticesCoordinates[8]  = {
        
        -1.0,-1.0,
        1.0,-1.0,
        -1.0,1.0,
        1.0,1.0,
    };
    
    GLfloat textureCoordinates[8]  = {
        0.0,0.0,
        1.0,0.0,
        0.0,1.0,
        1.0,1.0,
    };
    CVOpenGLESTextureRef dstTextureRef = 0;
    CVOpenGLESTextureRef textureRef = [self customTextureForPixelBuffer:pixel];
    if (!textureRef) {
        return NULL;
    }
    
    int segmentWidth = (int)CVPixelBufferGetWidth(mask);
    int segmentHeight = (int)CVPixelBufferGetHeight(mask);
    int w = (int)CVPixelBufferGetWidth(pixel);
    int h = (int)CVPixelBufferGetHeight(pixel);
    
   
    CVPixelBufferRef jointBilateralPixel = [self getOutPutPixelBufferFromWidth:w height:h clearDate:YES];
    if (!jointBilateralPixel)
        return NULL;
    
    FrameBufferObjectList* pFbo = [self getTextureFBOListNodeWithWidth:w height:h];
    if (!pFbo)
        return NULL;
    
    //todo：需要获取mask大小判断是否删除纹理
    GLuint maskTexture = [self updateTextureFromPixelBuffer:mask isBGRA:NO];
    
    glBindFramebuffer(GL_FRAMEBUFFER, pFbo->fbo);
    //裁剪之后的宽高，也是输出纹理的大小
    glViewport(0, 0, (int)w, (int)h);
    
    dstTextureRef = [self customTextureForPixelBuffer:jointBilateralPixel];
    // Attach the destination texture as a color attachment to the off screen frame buffer
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(dstTextureRef), 0);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_bilateralProgram);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, CVOpenGLESTextureGetName(textureRef));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glUniform1i(_bilateralInputTextureUniform, 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, maskTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glUniform1i(_bilateralInputMaskTextureUniform, 1);
    
    
    float sigmaColor = 0.1;
    float sigmaSpace = 2.5f;
    sigmaColor = fmax(0, fmin(1.0, sigmaColor)); //限制0-1
    sigmaSpace = sigmaSpace * fmax(w, h) / fmax(segmentWidth,segmentHeight);
    float sizeNormalize[] = {1.0f / (float) w, 1.0f / (float) h};
    
    const double kSparsityFactor = 0.66; // Higher is more sparse.
    const double step = fmax(1, sqrt(sigmaSpace) * kSparsityFactor);//1.0435
    const double offset = step > 1 ? step * 0.5 : 0;//0.5217
    const double sigmaTexel = fmax(sizeNormalize[0], sizeNormalize[1]) * sigmaSpace;//0.00348
    
    glUniform2f(_texelSizeUniform, 1.0/(float)w, 1.0/(float)h);
    glUniform1f(_stepUniform, step);
    glUniform1f(_radiusUniform, sigmaSpace);
    glUniform1f(_offsetUniform, offset);
    glUniform1f(_sigmaTexelUniform, sigmaTexel);
    glUniform1f(_sigmaColorUniform, sigmaColor);
    
   
    
    //每个顶点由xy组成，一共4个顶点，所以顶点坐标和纹理坐标都是32
    if(!_vbo)
        [self createVBO:&_vbo positionAttribute:_bilateralPositionAttribute textureAttribute:_bilateralTextureCoordinateAttribute verticeCoordinates:(float*)verticesCoordinates verticeCoordinatesLen:32 textureCoordinates:(float*)textureCoordinates textureCoordinatesLen:32];
    
    [self useVBO:_vbo positionAttribute:_bilateralPositionAttribute textureAttribute:_bilateralTextureCoordinateAttribute verticeCoordinates:(float*)verticesCoordinates verticeCoordinatesLen:32 textureCoordinates:(float*)textureCoordinates textureCoordinatesLen:32];

    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glFlush();
    
    CFRelease(dstTextureRef);
    CFRelease(textureRef);
    
    return jointBilateralPixel;;
}


-(CVPixelBufferRef)processLightWrapFromPixelBuffer:(CVPixelBufferRef)pixel maskPixelBuffer:(CVPixelBufferRef)mask
{
    GLfloat verticesCoordinates[8]  = {
        
        -1.0,-1.0,
        1.0,-1.0,
        -1.0,1.0,
        1.0,1.0,
    };
    
    GLfloat textureCoordinates[8]  = {
        0.0,0.0,
        1.0,0.0,
        0.0,1.0,
        1.0,1.0,
    };
    
    if(!pixel || !mask)
        return NULL;
    
    CVOpenGLESTextureRef dstTextureRef = 0;
    CVOpenGLESTextureRef textureRef = [self customTextureForPixelBuffer:pixel];
    if (!textureRef) {
        return NULL;
    }
    
 
    int w = (int)CVPixelBufferGetWidth(pixel);
    int h = (int)CVPixelBufferGetHeight(pixel);
    CVPixelBufferRef lightWrapPixel = [self getOutPutPixelBufferFromWidth:w height:h clearDate:NO];
    if (!lightWrapPixel)
        return NULL;
    
    FrameBufferObjectList* pFbo = [self getTextureFBOListNodeWithWidth:w height:h];
    if (!pFbo)
        return NULL;
    
    GLuint maskTexture = [self updateTextureFromPixelBuffer:mask isBGRA:YES];
    
    glBindFramebuffer(GL_FRAMEBUFFER, pFbo->fbo);
    //裁剪之后的宽高，也是输出纹理的大小
    glViewport(0, 0, (int)w, (int)h);
    
    dstTextureRef = [self customTextureForPixelBuffer:lightWrapPixel];
    // Attach the destination texture as a color attachment to the off screen frame buffer
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(dstTextureRef), 0);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_lightWrapProgam);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, CVOpenGLESTextureGetName(textureRef));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glUniform1i(_lightWrapInputTextureUniform, 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, maskTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glUniform1i(_lightWrapInputMaskTextureUniform, 1);
    
    
    glUniform2f(_coverageUniform, 0.5f, 0.75f);
    glUniform1f(_lightWrappingUniform, 0);
    glUniform1f(_blendModeUniform, 0);
    
    //每个顶点由xy组成，一共4个顶点，所以顶点坐标和纹理坐标都是32
    if(!_vbo)
        [self createVBO:&_vbo positionAttribute:_lightWrapPositionAttribute textureAttribute:_lightWrapTextureCoordinateAttribute verticeCoordinates:(float*)verticesCoordinates verticeCoordinatesLen:32 textureCoordinates:(float*)textureCoordinates textureCoordinatesLen:32];
    
    [self useVBO:_vbo positionAttribute:_lightWrapPositionAttribute textureAttribute:_lightWrapTextureCoordinateAttribute verticeCoordinates:(float*)verticesCoordinates verticeCoordinatesLen:32 textureCoordinates:(float*)textureCoordinates textureCoordinatesLen:32];

    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glFlush();
    
    CFRelease(dstTextureRef);
    CFRelease(textureRef);
    
    return lightWrapPixel;
}

-(void)stop
{
    while (_statu == VESegment_Begin) {
//        NSLog(@"VESegmentFilter stop ~~~~");
        usleep(20);
    }
    return;
}

-(int)segmentPixelBuffer:(CVPixelBufferRef)pixel maskPixelBuffer:(CVPixelBufferRef)mask
{
    _statu = VESegment_Begin;
    if(!pixel || !mask)
    {
        _statu = VESegment_Finish;
        return 0;
    }
    //创建新的上下文
    if (!_curContext &&  [EAGLContext currentContext])
        _curContext = [EAGLContext currentContext];
    if(!_curContext)
    {
        _statu = VESegment_Finish;
        return 0;
    }

//    if(!_newContext)
//        _newContext = [[EAGLContext alloc] initWithAPI:[_oldContext API] sharegroup: [_oldContext sharegroup]];
//
//    if(!_newContext)
//        return 0;
//    else
//        [EAGLContext setCurrentContext:_newContext];
    
    [EAGLContext setCurrentContext:_curContext];
    
    if((_bilateralProgram <= 0) && (![self loadShaders]))
    {
        _statu = VESegment_Finish;
        NSLog(@"error:segmentPixelBuffer load shader error ,line:%d",__LINE__);
        return 0;
    }
    
    
    //1.处理双边滤波
    CVPixelBufferRef jointBilateralPixel = [self processJointBilateralFromPixelBuffer:pixel maskPixelBuffer:mask];
    if(!jointBilateralPixel)
    {
        _statu = VESegment_Finish;
        NSLog(@"error:processJointBilateralFromPixelBuffer error ,line:%d",__LINE__);
        return 0;
    }
    
    //2.锯齿
    CVPixelBufferRef lightWrapPixel = [self processLightWrapFromPixelBuffer:pixel maskPixelBuffer:jointBilateralPixel];
    if(!lightWrapPixel)
    {
        _statu = VESegment_Finish;
        NSLog(@"error:processJointBilateralFromPixelBuffer error ,line:%d",__LINE__);
        return 0;
    }
    
    
    
    //3.更新到目标pixelbuffer
    CVPixelBufferLockBaseAddress(pixel, 0);
    CVPixelBufferLockBaseAddress(lightWrapPixel, 0);
    size_t w = CVPixelBufferGetWidth(lightWrapPixel);
    size_t h = CVPixelBufferGetHeight(lightWrapPixel);
    size_t srcBytePerRow = CVPixelBufferGetBytesPerRow(lightWrapPixel);
    size_t dstBytePerRow = CVPixelBufferGetBytesPerRow(pixel);
    uint8_t *pSrcAddress = (uint8_t *)CVPixelBufferGetBaseAddress(lightWrapPixel);
    uint8_t *pDstAddress = (uint8_t *)CVPixelBufferGetBaseAddress(pixel);
    
    memset(pDstAddress, 0, dstBytePerRow*h);
    if(srcBytePerRow == dstBytePerRow)
        memcpy(pDstAddress, pSrcAddress, h * srcBytePerRow);
    else
    {
        for (int i = 0; i < h; i++)
            memcpy(pDstAddress + i * dstBytePerRow, pSrcAddress + i * srcBytePerRow, dstBytePerRow);
    }
    
    CVPixelBufferUnlockBaseAddress(lightWrapPixel, 0);
    CVPixelBufferUnlockBaseAddress(pixel, 0);
    
    
    [EAGLContext setCurrentContext:_curContext];
    _statu = VESegment_Finish;
    return 1;
}


#pragma mark - 使用VBO
-(bool)useVBO:(GLuint)vbo
    positionAttribute:(int)positionAttribute
    textureAttribute:(int)textureAttribute
    verticeCoordinates:(float*)verticeCoordinates
    verticeCoordinatesLen:(int)verticeCoordinatesLen
    textureCoordinates:(float*)textureCoordinates
    textureCoordinatesLen:(int)textureCoordinatesLen
{
    if(positionAttribute < 0 ||
       textureAttribute < 0 ||
       !verticeCoordinates ||
       !textureCoordinates ||
       verticeCoordinatesLen <= 0 ||
       textureCoordinatesLen <= 0)
        return false;
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, verticeCoordinatesLen+textureCoordinatesLen, NULL, GL_STATIC_DRAW);

    glBufferSubData(GL_ARRAY_BUFFER, 0, verticeCoordinatesLen, verticeCoordinates);
    glBufferSubData(GL_ARRAY_BUFFER, verticeCoordinatesLen, textureCoordinatesLen, textureCoordinates);
    
    glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, (void*)0);
    glEnableVertexAttribArray(positionAttribute);
    
    glVertexAttribPointer(textureAttribute, 2, GL_FLOAT, GL_FALSE, 0, (void*)(verticeCoordinatesLen));
    glEnableVertexAttribArray(textureAttribute);
    
    return true;
}
#pragma mark - 创建VBO
-(bool)createVBO:(GLuint*)vbo
    positionAttribute:(int)positionAttribute
    textureAttribute:(int)textureAttribute
    verticeCoordinates:(float*)verticeCoordinates
    verticeCoordinatesLen:(int)verticeCoordinatesLen
    textureCoordinates:(float*)textureCoordinates
    textureCoordinatesLen:(int)textureCoordinatesLen
{
    
    if(positionAttribute < 0 ||
       textureAttribute < 0 ||
       !verticeCoordinates ||
       !textureCoordinates ||
       verticeCoordinatesLen <= 0 ||
       textureCoordinatesLen <= 0)
        return false;
    
    glGenBuffers(1, vbo);
    glBindBuffer(GL_ARRAY_BUFFER, *vbo);
    glBufferData(GL_ARRAY_BUFFER, verticeCoordinatesLen+textureCoordinatesLen, NULL, GL_STATIC_DRAW);
    
    glBufferSubData(GL_ARRAY_BUFFER, 0, verticeCoordinatesLen, verticeCoordinates);
    glBufferSubData(GL_ARRAY_BUFFER, verticeCoordinatesLen, textureCoordinatesLen, textureCoordinates);
    
    glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, (void*)0);
    glEnableVertexAttribArray(positionAttribute);
    
    glVertexAttribPointer(textureAttribute, 2, GL_FLOAT, GL_FALSE, 0, (void*)(verticeCoordinatesLen));
    glEnableVertexAttribArray(textureAttribute);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    return true;
}


- (void)dealloc
{
    if(_statu != VESegment_Finish)
        [self stop];

    [EAGLContext setCurrentContext:_curContext];
    if (_bilateralVert) {
        glDetachShader(_bilateralProgram, _bilateralVert);
        glDeleteShader(_bilateralVert);
        _bilateralVert = 0;
    }
    if (_bilateralFrag) {
        glDetachShader(_bilateralProgram, _bilateralFrag);
        glDeleteShader(_bilateralFrag);
        _bilateralFrag = 0;
    }
    if (_lightWrapVert) {
        glDetachShader(_lightWrapProgam, _lightWrapVert);
        glDeleteShader(_lightWrapVert);
        _lightWrapVert = 0;
    }
    if (_lightWrapFrag) {
        glDetachShader(_lightWrapProgam, _lightWrapFrag);
        glDeleteShader(_lightWrapFrag);
        _lightWrapFrag = 0;
    }

    if (_bilateralProgram) {
        glDeleteProgram(_bilateralProgram);
        _bilateralProgram = 0;
    }
    if (_lightWrapProgam) {
        glDeleteProgram(_lightWrapProgam);
        _lightWrapProgam = 0;
    }
    if (_videoTextureCache) {
        CVOpenGLESTextureCacheFlush(_videoTextureCache, 0);
        CFRelease(_videoTextureCache);
    }
    while(_pFBOList)
    {
        struct  FrameBufferObjectList* pList = _pFBOList->next;
        if(_pFBOList && _pFBOList->fbo)
            glDeleteFramebuffers(1, &_pFBOList->fbo);
        free(_pFBOList);
        _pFBOList = pList;
    }
    while(_pMaskTextureList)
    {
        struct  TextureList* pList = _pMaskTextureList->next;
        if(_pMaskTextureList && _pMaskTextureList->texture)
            glDeleteTextures(1, &_pMaskTextureList->texture);
        free(_pMaskTextureList);
        _pMaskTextureList = pList;
    }
    while(_pOutputPixelBufferList)
    {
        struct OutputPixelBufferList * pList = _pOutputPixelBufferList->next;
        if(_pOutputPixelBufferList && _pOutputPixelBufferList->outputPixelBuffer)
            CFRelease(_pOutputPixelBufferList->outputPixelBuffer);
        _pOutputPixelBufferList->outputPixelBuffer = nil;
        free(_pOutputPixelBufferList);
        _pOutputPixelBufferList = pList;
    }
    [EAGLContext setCurrentContext:_curContext];
    
    NSLog(@"VESegmentFilter dealloc ~~");
}

@end
