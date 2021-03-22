//
//  ViewController.m
//  iOSTest
//
//  Created by 排骨 on 2020/3/28.
//  Copyright © 2020 排骨. All rights reserved.
//

#import "AboutTweakViewController.h"
#import <objc/objc-runtime.h>

#define QSDefaults [NSUserDefaults standardUserDefaults]
#define origWhiteColor [UIColor colorWithRed:(242/255.0f) green:(242/255.0f)blue:(242/255.0f) alpha:1.0f]

@interface AboutTweakViewController () <UITableViewDataSource,UITableViewDelegate>
@end

@implementation AboutTweakViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.navigationItem.titleView = [objc_getClass("SSNavigationBar") navigationTitleViewWithTitle:@"关于这款插件"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lefterbackicon_titlebar"] style:UIBarButtonItemStylePlain target:self action:@selector(backclick)];

    SSThemedTableView *tableView = [[objc_getClass("SSThemedTableView") alloc] initWithFrame:self.view.bounds style:1];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 10;
    tableView.backgroundColor = [UIColor ttColorWithName:@"Color_grey_9"];
    tableView.enableTTStyledSeparator = YES;
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;

    self.view.backgroundColor = origWhiteColor;
    [self.view addSubview:tableView];
}

- (void)backclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //移除系列
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SettingDetailTextCell *cell = [[objc_getClass("SettingDetailTextCell") alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"qscell3"];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    SSThemedView *bg = [[objc_getClass("SSThemedView") alloc] init];
    bg.backgroundColor = [UIColor ttColorWithName:@"Color_bg_2"];
    cell.backgroundView = bg;
    cell.separatorAtBottom = YES;
    cell.separatorAtTOP = YES;

    cell.tt_titleLabel.font = [UIFont systemFontOfSize:[objc_getClass("SettingView") fontSizeOfCellLeftLabel]];
    cell.tt_DetailLabel.textColorThemeKey = @"Text3";

    if (indexPath.section == 0)
    {//移除系列
        cell.tt_titleLabel.textColor = [UIColor systemBlueColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;

        if (indexPath.row == 0) 
            cell.tt_titleLabel.text = @"请我吃碗泡面";
        
        else if (indexPath.row == 1)
            cell.tt_titleLabel.text = @"插件的源地址";
            
        else if(indexPath.row == 2)
            cell.tt_titleLabel.text = @"项目开源代码";
        
        else if(indexPath.row == 3)
            cell.tt_titleLabel.text = @"关注我的微博";
    }
        
    return cell;
}

// - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
// {
//     if (section == 0)
//         return @"移除系列";
    
//     return nil;
// }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        [self donateViaAlipay];
    
    if (indexPath.row == 1)
        [self myrepo];
    
    if (indexPath.row == 2)
        [self opensource];
    
    if (indexPath.row == 3)
        [self myWeibo];
}


- (void)donateViaAlipay
{
    [[UIApplication sharedApplication] openURL:
        [NSURL URLWithString:@"https://qr.alipay.com/fkx11847cc72d5vzsopdv56"]
        options:@{}
        completionHandler:nil];
}

- (void)myrepo
{
    [[UIApplication sharedApplication] openURL:
        [NSURL URLWithString:@"https://apt.paigu.site"]
        options:@{}
        completionHandler:nil];
}

- (void)opensource
{
    [[UIApplication sharedApplication] openURL:
        [NSURL URLWithString:@"https://github.com/wstclzy2010/PureNewSocial"]
        options:@{}
        completionHandler:nil];
}

- (void)myWeibo
{
    [[UIApplication sharedApplication] openURL:
        [NSURL URLWithString:@"https://weibo.com/u/7321330374/"]
        options:@{}
        completionHandler:nil];
}


@end
