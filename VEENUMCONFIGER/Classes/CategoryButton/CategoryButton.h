//
//  CategoryButton.h
//  VEENUMCONFIGER
//
//  Created by emmet-mac on 2023/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryButton : UIButton
@property (nonatomic,strong)UIView *lineView;
@end

@interface EMButton : UIButton
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)UILabel *desLabel;

@end
NS_ASSUME_NONNULL_END
