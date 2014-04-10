//
//  DownListView.h
//  DownListView
//
//  Created by 佟堃 on 14-4-10.
//  Copyright (c) 2014年 TK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownListView;
@protocol DownListViewDelegate <NSObject>
//Delegate
- (void)downListView:(DownListView *)downListView didSelectRow:(NSInteger)row inSection:(NSInteger)section;

@end

@protocol DownListViewDataSource <NSObject>
@required
//DataSource
- (NSInteger)numberOfSectionInDownListView:(DownListView *)downListView;
- (NSInteger)numberOfRowInSection:(NSInteger)section;
- (NSString *)titleOfRow:(NSInteger)row section:(NSInteger)section;

@optional
- (CGFloat)widthOfDownListView:(DownListView *)downListView ;


@end

@interface DownListView : UIView
{
    
}

@property (assign, nonatomic) CGFloat maxHeight;
@property (assign, nonatomic) id<DownListViewDataSource>dataSource;
@property (assign, nonatomic) id<DownListViewDelegate>delegate;
@property (assign, nonatomic) CGFloat rowHeight;
/**
 showDownListView
 */
- (void)showFromView:(UIView *)fromView animated:(BOOL)animated;
/**
 removeDownListView
 */
- (void)dismissDownListViewAnimated:(BOOL)animated;

- (void)reloadRowsOfSection:(NSInteger)section;

- (void)reloadAllSection;

- (void)selectRow:(NSInteger)row section:(NSInteger)section animated:(BOOL)animated;

@end

@interface DownListTableView : UITableView

@property(assign, nonatomic) NSInteger sectionNum;

@end
