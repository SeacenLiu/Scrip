//
//  SCTextView.h
//  note
//
//  Created by SeacenLiu on 2018/4/18.
//  Copyright © 2018年 成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTextView : UITextView

- (instancetype)initWithFrame:(CGRect)frame;

/** 占位字符串 */
@property (nonatomic, copy) NSString *holderString;

@end
