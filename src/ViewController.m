//
//  ViewController.m
//  iOSTest
//
//  Created by 排骨 on 2020/3/28.
//  Copyright © 2020 排骨. All rights reserved.
//

#import "ViewController.h"
#import "RemoverViewController.h"
#import "AboutTweakViewController.h"
#import <objc/objc-runtime.h>

#define QSDefaults [NSUserDefaults standardUserDefaults]
#define origWhiteColor [UIColor colorWithRed:(242/255.0f) green:(242/255.0f)blue:(242/255.0f) alpha:1.0f]

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.navigationItem.titleView = [objc_getClass("SSNavigationBar") navigationTitleViewWithTitle:@"清爽今日头条"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lefterbackicon_titlebar"] style:UIBarButtonItemStylePlain target:self action:@selector(backclick)];

    SSThemedTableView *tableView = [[objc_getClass("SSThemedTableView") alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 10;
    tableView.backgroundColor = [UIColor ttColorWithName:@"Color_grey_9"];
    tableView.enableTTStyledSeparator = YES;
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;

    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    SSThemedLabel *aboutLabel = [[objc_getClass("SSThemedLabel") alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    aboutLabel.numberOfLines = 0;
    aboutLabel.backgroundColor = [UIColor clearColor];
    aboutLabel.text = @"All Rights Reserved By 糖醋丶炒排骨";
    aboutLabel.textAlignment = NSTextAlignmentCenter;
    aboutLabel.textColorThemeKey = @"Text3";
    aboutLabel.font = [UIFont systemFontOfSize:12];
    
    footer.autoresizingMask = UIViewAutoresizingNone;
    [footer addSubview:aboutLabel];
    
    tableView.tableFooterView = footer;

    self.view.backgroundColor = origWhiteColor;
    [self.view addSubview:tableView];
}


- (void)backclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //移除系列
    if(section == 0)
        return 1;

    //其他
    else if(section == 1)
        return 3;
    //首选项
    else if(section == 2)
        return 1;
    //关于
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.section == 1 && indexPath.row == 0)
        || (indexPath.section == 0 && indexPath.row == 10)
        || (indexPath.section == 2 && indexPath.row == 0))
        return 78;
    else
        return 49;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SettingDetailTextCell *cell = [[objc_getClass("SettingDetailTextCell") alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"qscell2"];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    SSThemedView *bg = [[objc_getClass("SSThemedView") alloc] init];
    bg.backgroundColor = [UIColor ttColorWithName:@"Color_bg_2"];
    cell.backgroundView = bg;
    cell.separatorAtBottom = YES;
    cell.separatorAtTOP = YES;
    cell.tt_titleLabel.font = [UIFont systemFontOfSize:[objc_getClass("SettingView") fontSizeOfCellLeftLabel]];
    cell.tt_DetailLabel.textColorThemeKey = @"Text3";
    TTSettingSwitch *switchView = [[objc_getClass("TTSettingSwitch") alloc] init];

    if (indexPath.section == 0)
    {//移除系列
        cell.tt_titleLabel.text = @"可选的移除项目";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.tt_titleLabel.text = @"去除头条的广告";
            cell.tt_DetailLabel.text = @"包括首页推荐/悬浮、文章内、西瓜视频页、相关视频、放映厅、小说等等一切广告";     
            switchView.on = [QSDefaults boolForKey:@"normalAd"];
            [switchView addTarget:self
                action:@selector(qs_normalAd:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 1)
        {
            cell.tt_titleLabel.text = @"缩小视频分享区";   
            switchView.on = [QSDefaults boolForKey:@"ShareView"];
            [switchView addTarget:self
                action:@selector(qs_ShareView:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }

        else
        {
            cell.tt_titleLabel.text = @"头条小视频下载";
            cell.tt_DetailLabel.text = @"播放页面长按即可下载小视频";     
            switchView.on = [QSDefaults boolForKey:@"videoDownload"];
            [switchView addTarget:self
                action:@selector(qs_videoDownload:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
    }
    
    else if (indexPath.section == 2)
    {
        cell.tt_titleLabel.text = @"干掉头条应用";
        cell.tt_DetailLabel.text = @"大部分开关都无需关闭应用即可生效，若是发现有的选项没有生效，可以点击此按钮";
        cell.tt_titleLabel.textColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else if (indexPath.section == 3)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.tt_titleLabel.text = @"关于这款插件";
    }
        
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"移除系列";
    
    else if (section == 1)
        return @"其他";

    else if(section == 2)
        return @"首选项";
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        RemoverViewController *rvc = [[RemoverViewController alloc] init];
	    [self.navigationController pushViewController:rvc animated:YES];
        self.hidesBottomBarWhenPushed=YES;
    } 

    if(indexPath.section == 1)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        [self exitApplication];
    }
    else if (indexPath.section == 3)
    {
        AboutTweakViewController *aboutVC = [[AboutTweakViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

- (void)exitApplication 
{
    //来 加个动画，给用户一个友好的退出界面
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight  forView:self.view.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}


- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

- (void)qs_ShareView:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"ShareView"];
    [QSDefaults synchronize];
}

- (void)qs_normalAd:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"normalAd"];
    [QSDefaults synchronize];
}

- (void)qs_videoDownload:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"videoDownload"];
    [QSDefaults synchronize];
}



@end
