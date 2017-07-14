//
//  DetailViewController.m
//  ShareDemo
//
//  Created by wyy on 2017/7/7.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "DetailViewController.h"
#import "LMShareSDK.h"

#define DVCCellID @"UITableViewCell"
#define TestImageData [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"girl" ofType:@"jpg"]]
#define TestGifData [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gif_200k" ofType:@"gif"]]
@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contentTypes;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.title = @"分享类型";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - Private Method
- (NSString *)transformFromContentType:(LMSSDKContentType)contentType {
    switch (contentType) {
        case LMSSDKContentTypeText:
            return @"文字";
            break;
        case LMSSDKContentTypeImage:
            return @"图片";
            break;
        case LMSSDKContentTypeWebPage:
            return @"链接";
            break;
        case LMSSDKContentTypeEmotion:
            return @"emotion";
            break;
        case LMSSDKContentTypeMovie:
            return @"视频";
            break;
        default:
            break;
    }
    return nil;
}

- (LMShareRequestParameters *)packageParametersFromContentType:(LMSSDKContentType)contentType {
    NSString *shareText = [NSString stringWithFormat:@"%@分享类型",[self transformFromContentType:contentType]];
    NSURL *url = (contentType == LMSSDKContentTypeWebPage)?[NSURL URLWithString:@"http://www.bqtalk.com/"]:nil;
    if (contentType == LMSSDKContentTypeWebPage) {
        url = [NSURL URLWithString:@"http://www.bqtalk.com/"];
    }else if (contentType == LMSSDKContentTypeMovie) {
        url = [NSURL URLWithString:@"http://v.youku.com/v_show/id_XNTUxNDY1NDY4.html"];
    }
    //images在SSDKContentTypeImage和SSDKContentTypeWebPage类型时不能为空
    NSArray *fileDatas;
    if (contentType == LMSSDKContentTypeImage || contentType == LMSSDKContentTypeWebPage) {
        fileDatas = @[TestImageData];
    }else if (contentType == LMSSDKContentTypeEmotion) {
        fileDatas = @[TestGifData];
    }else if (contentType == LMSSDKContentTypeMovie){
        fileDatas = @[TestImageData];
    }
    
    return [LMShareRequestParameters ParametersWithText:shareText description:@"i am a description" webUrl:url imageData:fileDatas thumbnails:[UIImage imageNamed:@"girl.jpg"] contentType:contentType platformType:self.platformType];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    
}
#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DVCCellID forIndexPath:indexPath];
    LMSSDKContentType type = [self.contentTypes[indexPath.row] integerValue];
    cell.textLabel.text = [self transformFromContentType:type];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LMSSDKContentType type = [self.contentTypes[indexPath.row] integerValue];
    [LMShareSDK sendLinkWithParameters:[self packageParametersFromContentType:type] onStateChanged:^(LMSSDKResponseState state, NSDictionary *userData, NSError *error) {
        NSString *titel = @"";
        NSString *typeStr = @"";
        UIColor *typeColor = [UIColor grayColor];
        switch (state) {
            case LMSSDKResponseStateSuccess: {
                titel = @"分享成功";
                typeStr = @"成功";
                typeColor = [UIColor blueColor];
                break;
            }
            case LMSSDKResponseStateFail: {
                NSLog(@"error :%@",error);
                titel = @"分享失败";
                typeStr = [NSString stringWithFormat:@"%@",error.localizedDescription];
                typeColor = [UIColor redColor];
                break;
            }
            case LMSSDKResponseStateCancel: {
                titel = @"分享已取消";
                typeStr = @"取消";
                break;
            }
            default:
                break;
        }
        [self showAlertViewWithTitle:titel message:typeStr cancelButtonTitle:@"确定"];
    }];

}

#pragma mark - get
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:DVCCellID];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSArray *)contentTypes {
    if (_contentTypes == nil) {
        NSMutableArray *mutableArray = [@[
                                          @(LMSSDKContentTypeText),
                                          @(LMSSDKContentTypeImage),
                                          @(LMSSDKContentTypeWebPage),
                                          @(LMSSDKContentTypeMovie),
                                         ] mutableCopy];
        switch (self.platformType) {
            case LMSSDKPlatformTypeSinaWeibo:
                [mutableArray addObject:@(LMSSDKContentTypeEmotion)];
                
                break;
            case LMSSDKPlatformSubTypeQQFriend:
                [mutableArray addObject:@(LMSSDKContentTypeEmotion)];
                
                break;
            case LMSSDKPlatformSubTypeQZone:
                [mutableArray addObject:@(LMSSDKContentTypeEmotion)];
                
                break;
            case LMSSDKPlatformSubTypeWechatSession:
                [mutableArray addObject:@(LMSSDKContentTypeEmotion)];
                
                break;
            case LMSSDKPlatformSubTypeWechatTimeline:
                
                break;
                
            default:
                break;
        }
        
        _contentTypes = [mutableArray copy];
    }
    return _contentTypes;
}

@end
