//
//  ViewController.m
//  LMCustomShareModule
//
//  Created by wyy on 2017/7/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#define VCCellID @"UITableViewCell"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSNumber *>*platformArray;
@end

@implementation ViewController
#pragma mark -life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark - Private Method
- (NSString *)transformFromPlatformType:(LMSSDKPlatformType)platformType {
    switch (platformType) {
        case LMSSDKPlatformTypeSinaWeibo:
            return @"新浪微博";
            break;
        case LMSSDKPlatformSubTypeQQFriend:
            return @"QQ好友";
            break;
        case LMSSDKPlatformSubTypeQZone:
            return @"QQ朋友圈";
            break;
        case LMSSDKPlatformSubTypeWechatSession:
            return @"微信好友";
            break;
        case LMSSDKPlatformSubTypeWechatTimeline:
            return @"微信朋友圈";
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.platformArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VCCellID forIndexPath:indexPath];
    LMSSDKPlatformType type = [self.platformArray[indexPath.row] integerValue];
    cell.textLabel.text = [self transformFromPlatformType:type];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.platformType = [self.platformArray[indexPath.row] integerValue];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - get
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:VCCellID];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSArray *)platformArray {
    if (_platformArray == nil) {
        _platformArray = @[@(LMSSDKPlatformTypeSinaWeibo),
                           @(LMSSDKPlatformSubTypeQQFriend),
                           @(LMSSDKPlatformSubTypeQZone),
                           @(LMSSDKPlatformSubTypeWechatSession),
                           @(LMSSDKPlatformSubTypeWechatTimeline),
                           ];
    }
    return _platformArray;
}

@end
