//
//  RootViewController.m
//  DownListView
//
//  Created by 佟堃 on 14-4-10.
//  Copyright (c) 2014年 TK. All rights reserved.
//

#import "RootViewController.h"
#import "DownListView.h"
@interface RootViewController ()<DownListViewDataSource, DownListViewDelegate>

{
    UILabel *_label;
    NSInteger _selectNum;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectNum = -1;
    for (int i = 0; i< 4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(80 * i, 64, 80, 60);
        [button setTitle:[NSString stringWithFormat:@"%d组",i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = i + 100;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (i == 3) {
            [button setTitle:@"selected" forState:UIControlStateNormal];
        }
    }
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(40, 350, 240, 40)];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:15.0f];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"show selected message";
    [self.view addSubview:_label];
}

- (void)buttonClick:(UIButton *)button{
    if (button.tag == 100 ) {
        _selectNum = 0;
    }else if (button.tag == 101) {
        _selectNum = 1;
    }else if (button.tag == 102){
        _selectNum = 2;
    }else{
        _selectNum = 3;
    }
    DownListView *listView = [[DownListView alloc]init];
    listView.delegate = self;
    listView.dataSource = self;
    [listView showFromView:button animated:YES];
    if (_selectNum == 1) {
        [listView selectRow:0 section:0 animated:NO];
        [listView selectRow:2 section:1 animated:YES];
        [listView selectRow:10 section:2 animated:NO];
    }
    
}
- (NSInteger)numberOfSectionInDownListView:(DownListView *)downListView{
    if (_selectNum == 0) {
        return 1;
    }else if (_selectNum == 1) {
        return 2;
    }else{
        return 3;
    }
}
- (NSInteger)numberOfRowInSection:(NSInteger)section{
    switch (_selectNum) {
        case 0:
        {
            return 20;
        }
            break;
        case 1:
        {
            return 15;
        }
            break;
        case 2:
        {
            return 25;
        }
            break;
        case 3:
        {
            return 30;
        }
        default:
            break;
    }
    return 0;
}

- (NSString *)titleOfRow:(NSInteger)row section:(NSInteger)section{
    return [NSString stringWithFormat:@"s: %ld, r: %ld",section, row];
}

- (void)downListView:(DownListView *)downListView didSelectRow:(NSInteger)row inSection:(NSInteger)section{
    _label.text = [NSString stringWithFormat:@"selected section: %ld, row:%ld",section, row];
}



@end
