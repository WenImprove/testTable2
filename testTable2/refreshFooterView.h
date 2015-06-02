//
//  refreshFooterView.h
//  testTable
//
//  Created by suez on 15/5/18.
//  Copyright (c) 2015年 suez. All rights reserved.
//
/*

使用说明： 
1: .h文件import .h
2: 添加refreshDelegate协议
3: 完成refreshMethod添加数据方法
4: 添加refreshFooterView：
   refreshFooterView *r = [refreshFooterView new];
   r.delegate = self;
   [r initFooterViewTo:_table];
*/
typedef enum {
    normol,
    pulling,
    loading,
}refreshState;

#import <UIKit/UIKit.h>
@protocol refreshDelegate;
@interface refreshFooterView : UIView
{
    UITableView *thetable;
    UIImageView *arrowImage;
    UILabel *time,*hint;
    UIActivityIndicatorView *activityView;
    BOOL isloading;
    refreshState _state;
}

@property(nonatomic,strong) id <refreshDelegate>delegate;
-(void)initFooterViewTo:(UITableView *)_table;

@end


@protocol refreshDelegate <NSObject>

-(void)refreshMethod;

@end