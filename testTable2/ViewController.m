//
//  ViewController.m
//  testTable2
//
//  Created by suez on 15/5/17.
//  Copyright (c) 2015年 suez. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)refreshMethod{
    for (int i = 0; i < 3; i++) {
        NSString *str = [NSString stringWithFormat:@"item--%d",i];
        [aryItems addObject:str];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    aryItems = [NSMutableArray new];
    for (int i = 0; i < 15; i++) {
        NSString *item = [NSString stringWithFormat:@"item%d",i];
        [aryItems addObject:item];
    }
    
    refreshFooterView *r = [refreshFooterView new];
    r.delegate = self;
    [r initFooterViewTo:_table];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    cell.textLabel.text = [aryItems objectAtIndex:indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
