//
//  UIView+UIViewScrip.h
//  note
//
//  Created by SeacenLiu on 2018/4/18.
//  Copyright © 2018年 成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewScrip)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;

@property (nonatomic, assign, readonly) CGRect screenB;
@property (nonatomic, assign, readonly) CGFloat screenW;
@property (nonatomic, assign, readonly) CGFloat screenH;

@end
