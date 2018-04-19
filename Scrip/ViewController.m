//
//  ViewController.m
//  note
//
//  Created by SeacenLiu on 2018/4/18.
//  Copyright © 2018年 成. All rights reserved.
//

#import "ViewController.h"
#import "SCScripView.h"

@interface ViewController ()

@property (nonatomic, strong) SCScripView *scrollView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ViewController

- (IBAction)sliderValueChange:(UISlider *)sender {
    [self.scrollView testChangeFont:[UIFont systemFontOfSize:sender.value]];
}

- (void)setupSlider {
    self.slider.minimumValue = 30;
    self.slider.maximumValue = 120;
    self.slider.value = 30;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: self.scrollView];
    
    [self setupSlider];
}

#pragma mark - lazy
- (SCScripView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[SCScripView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 49)];
    }
    return _scrollView;
}

@end
