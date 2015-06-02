//
//  ViewController.h
//  testTable2
//
//  Created by suez on 15/5/17.
//  Copyright (c) 2015年 suez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "refreshFooterView.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,refreshDelegate>
{
    NSMutableArray *aryItems;
}
@property (weak, nonatomic) IBOutlet UITableView *table;




@end

