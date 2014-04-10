//
//  DownListView.m
//  DownListView
//
//  Created by 佟堃 on 14-4-10.
//  Copyright (c) 2014年 TK. All rights reserved.
//

#import "DownListView.h"
#import "UIImage+color.h"

#define TABLEVIEW_KEY(i) [NSString stringWithFormat:@"tableViewNum_%d",i]
#define TAG_DOWNLISTVIEW 1111111
@interface DownListView ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _sectinoCount;
    CGFloat _width;
}
@property (retain, nonatomic) NSMutableDictionary *tableDic;
@end

@implementation DownListView
@synthesize delegate;
@synthesize dataSource;
@synthesize tableDic;
@synthesize rowHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initialize];
        
    }
    return self;
}

- (void)initialize{
    self.maxHeight = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.tableDic = [[NSMutableDictionary alloc]init];
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.tag = TAG_DOWNLISTVIEW;
    self.rowHeight = 40.0f;
}

- (void)showFromView:(UIView *)fromView animated:(BOOL)animated{
    _width = 320;
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(widthOfDownListView:)]) {
            _width = [self.dataSource widthOfDownListView:self];
        }
    }
    
    self.frame = CGRectMake(0, fromView.frame.size.height + fromView.frame.origin.y, _width, self.maxHeight);
    
    _sectinoCount = [self.dataSource numberOfSectionInDownListView:self];
    DownListTableView *tableView = [[DownListTableView alloc]initWithFrame:CGRectMake(0, 0, _width / _sectinoCount, 200) style:UITableViewStylePlain];
    tableView.sectionNum = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    [self.tableDic setObject:tableView forKey:TABLEVIEW_KEY(0)];
    UIView *superView = [fromView superview];
    DownListView *view = (DownListView *)[superView viewWithTag:TAG_DOWNLISTVIEW];
    if (view) {
        [view dismissDownListViewAnimated:NO];
    }
    [superView addSubview:self];
    
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = self.frame;
            frame.size.height = 200.0f;
            self.frame = frame;
        }completion:nil];
    }else{
        CGRect frame = self.frame;
        frame.size.height = 200.0f;
        self.frame = frame;
    }
}

- (void)dismissDownListViewAnimated:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = self.frame;
            frame.size.height = 0.0f;
            self.frame = frame;
        }completion:^(BOOL finished){
            [self removeFromSuperview];
            finished = YES;
        }];
    }else{
        [self removeFromSuperview];
    }
    
}
#pragma -mark
#pragma -mark tableView Delegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource numberOfRowInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }else{
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(15, 0, 320 / _sectinoCount, 40);
    label.font = [UIFont systemFontOfSize:16.0f];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [cell.contentView addSubview:label];
    NSInteger num = ((DownListTableView *)tableView).sectionNum;
    label.text = [self.dataSource titleOfRow:indexPath.row section:num];
    
    return cell;
}

- (void)tableView:(DownListTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(downListView:didSelectRow:inSection:)]) {
        [self.delegate downListView:self didSelectRow:indexPath.row inSection:tableView.sectionNum];
    }
    if (tableView.sectionNum < _sectinoCount - 1) {
        [self reloadRowsOfSection:tableView.sectionNum + 1];
    }else{
        [self dismissDownListViewAnimated:YES];
    }
}

- (void)reloadRowsOfSection:(NSInteger)section{
    DownListTableView *tableView = (DownListTableView *)[self.tableDic objectForKey:TABLEVIEW_KEY((int)section)];
    if (tableView) {
        [tableView reloadData];
    }else{
        tableView = [[DownListTableView alloc]initWithFrame:CGRectMake(_width / _sectinoCount * section + 0.5 * section, 0, _width / _sectinoCount, 200.0f) style:UITableViewStylePlain];
        tableView.sectionNum = section;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        [self.tableDic setObject:tableView forKey:TABLEVIEW_KEY((int)section)];
    }
    
}

- (void)reloadAllSection{
    NSArray *values = [self.tableDic allValues];
    for (DownListTableView *tableView in values) {
        [tableView reloadData];
    }
}

- (void)selectRow:(NSInteger)row section:(NSInteger)section animated:(BOOL)animated{
    DownListTableView *tableView = [self.tableDic objectForKey:TABLEVIEW_KEY((int)section)];
    if (tableView) {
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:animated scrollPosition:UITableViewScrollPositionMiddle];
        [self reloadRowsOfSection:section + 1];
    }
}

@end

@implementation DownListTableView
@synthesize sectionNum;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
