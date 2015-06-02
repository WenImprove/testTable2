//
//  refreshFooterView.m
//  testTable
//
//  Created by suez on 15/5/18.
//  Copyright (c) 2015年 suez. All rights reserved.
//

#import "refreshFooterView.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define sizeToChange 60
@implementation refreshFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)initFooterViewTo:(UITableView*)_table{
    
    thetable = _table;
    [thetable addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    
    arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
    arrowImage.frame = CGRectMake(screenWidth/2-35, 2, 10, 35);
    arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    [self addSubview:arrowImage];
     
    
    
    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = arrowImage.center;
    activityView.color = [UIColor blackColor];
    [self addSubview:activityView];
    
    
    hint = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-15, 8, screenWidth/2, 20)];
    hint.font = [UIFont systemFontOfSize:12.0f];
    hint.textAlignment = NSTextAlignmentLeft;
    hint.text = @"上拉刷新";
    [self addSubview:hint];
    
    time = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, screenWidth, 20)];
    time.font = [UIFont systemFontOfSize:12.0f];
    time.textAlignment = NSTextAlignmentCenter;
    time.text = [self getTime];
    [self addSubview:time];
    

    [thetable addSubview:self];
}

-(void)layoutSubviews{
    
    if (thetable.contentSize.height<screenHeight) {
        self.frame = CGRectMake(0, thetable.frame.size.height, screenWidth, screenHeight);
    }else{
        self.frame = CGRectMake(0, thetable.contentSize.height, screenWidth, screenHeight);
    }
}

-(NSString*)getTime{

    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSDate *date = [NSDate date];
    [[NSUserDefaults standardUserDefaults]setObject:@"time" forKey:[NSString stringWithFormat:@"更新于:%@",[dateFormatter stringFromDate:date]]];
    return [NSString stringWithFormat:@"更新于:%@",[dateFormatter stringFromDate:date]];
}


-(void)PutFooterAtEnd{
    if (thetable.contentSize.height<thetable.frame.size.height) {
        self.frame = CGRectMake(0, thetable.frame.size.height, screenWidth, thetable.bounds.size.height);
    }else{
        self.frame = CGRectMake(0, thetable.contentSize.height, screenWidth, thetable.bounds.size.height);
    }
    [self scrollViewBack:thetable];
}

-(void)FinishedLoadMoreFooterData{
    [thetable reloadData];
    [self PutFooterAtEnd];
    
    time.text = [self getTime];
    [self setState:normol];
    isloading = NO;
    
}

-(void)setState:(refreshState)theState{
    switch (theState) {
        case normol:
            hint.text = @"上拉刷新";
            [activityView stopAnimating];
            arrowImage.hidden = NO;
            break;
            
        case pulling:{
            hint.text = @"释放更新";
            [UIView animateWithDuration:0.3 animations:^{
                arrowImage.transform = CGAffineTransformMakeRotation(0);
            }];
            break;
        }
        case loading:
            hint.text = @"正在刷新...";
            [activityView startAnimating];
            arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
            arrowImage.hidden = YES;
        default:
            break;
    }
    
    _state = theState;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([@"contentOffset" isEqualToString:keyPath]) {
        if (thetable.isDragging) {
            
            if ((thetable.contentSize.height > thetable.frame.size.height && thetable.contentOffset.y + thetable.frame.size.height < thetable.contentSize.height + sizeToChange && !isloading)||(thetable.contentSize.height < thetable.frame.size.height && thetable.contentOffset.y < sizeToChange && !isloading)) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                }];
                [self setState:normol];
                
            }else if ((thetable.contentSize.height > thetable.frame.size.height && thetable.contentOffset.y + thetable.frame.size.height > thetable.contentSize.height + sizeToChange && !isloading)||(thetable.contentSize.height < thetable.frame.size.height && thetable.contentOffset.y > sizeToChange && !isloading)){
                
                [self setState:pulling];
                
            }
        }else{
            if (_state == pulling) {
                
                [self setState:loading];
                [self startRefresh];
                [self scrollViewOut:thetable];
                
            }
        }
    }
}

-(void)scrollViewOut:(UIScrollView*)scrollView{
    if (thetable.contentSize.height<thetable.frame.size.height) {
        [UIView animateWithDuration:0.3 animations:^{

        self.frame = CGRectMake(0, thetable.frame.size.height-60, screenWidth, thetable.frame.size.height);
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60, 0.0f);

        }];
    }
}

-(void)scrollViewBack:(UIScrollView*)scrollView{
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}



-(void)startRefresh{
    isloading = YES;

    dispatch_async(dispatch_get_global_queue(2, 0), ^{
        [NSThread sleepForTimeInterval:2];
        
        [_delegate refreshMethod];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self FinishedLoadMoreFooterData];
        });
        
    });
}








@end
