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

#define origWhiteColor [UIColor colorWithRed:(242/255.0f) green:(242/255.0f)blue:(242/255.0f) alpha:1.0f]
#define tweakVersion @"清爽今日头条 v3.6.10"


@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.navigationItem.titleView = [objc_getClass("SSNavigationBar") navigationTitleViewWithTitle:@"清爽今日头条"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lefterbackicon_titlebar"] style:UIBarButtonItemStylePlain target:self action:@selector(backclick)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"干掉" style:UIBarButtonItemStylePlain target:self action:@selector(alertExit)];

    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor redColor]];

    SSThemedTableView *tableView = [[objc_getClass("SSThemedTableView") alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 0.0001f;
    tableView.backgroundColor = [UIColor ttColorWithName:@"Color_grey_9"];
    tableView.enableTTStyledSeparator = YES;
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;

    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    SSThemedLabel *aboutLabel = [[objc_getClass("SSThemedLabel") alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
    aboutLabel.numberOfLines = 0;
    aboutLabel.backgroundColor = [UIColor clearColor];
    aboutLabel.text = @"All Rights Reserved By 糖醋丶炒排骨";
    aboutLabel.textAlignment = NSTextAlignmentCenter;
    aboutLabel.textColorThemeKey = @"Text3";
    aboutLabel.font = [UIFont systemFontOfSize:12];

    SSThemedLabel *aboutLabel2 = [[objc_getClass("SSThemedLabel") alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    aboutLabel2.numberOfLines = 0;
    aboutLabel2.backgroundColor = [UIColor clearColor];

    // NSDictionary *prefs;
    // if (@available(iOS 11, *)) 
    //     prefs = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.artikus.neonboardprefs.plist"] error:nil];
    // else 
    //     prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.artikus.neonboardprefs.plist"];
     

    aboutLabel2.text = tweakVersion;
    aboutLabel2.textAlignment = NSTextAlignmentCenter;
    aboutLabel2.textColorThemeKey = @"Text3";
    aboutLabel2.font = [UIFont systemFontOfSize:12];
    
    footer.autoresizingMask = UIViewAutoresizingNone;
    [footer addSubview:aboutLabel];
    [footer addSubview:aboutLabel2];
    tableView.tableFooterView = footer;

    self.view.backgroundColor = origWhiteColor;
    [self.view addSubview:tableView];
}

- (void)alertExit
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"干掉应用" message:@"大部分开关都无需关闭应用即可生效，若是发现有的选项没有生效，可以关闭应用以生效" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"干掉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) 
    {
        [self exitApplication];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
// - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
// {
//     if (section == 0) {
//         return 0.001;//把高度设置为0.001就解决了（为0的时候，他会使用默认值））
//     }
//     return 43;
// }

// - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
// {
//     if (section == 3) {
//         return 0.001;//把高度设置为0.001就解决了（为0的时候，他会使用默认值））
//     }
//     return 0;
// }

- (void)backclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    //移除系列
    if(section == 0)
        count = 1;

    //其他
    else if(section == 1)
        count = 4;
    //首选项
    else
        count = 1;

    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;

    if(indexPath.section == 1 && indexPath.row == 2)
        cellHeight = 97;

    else if(indexPath.section == 1 && indexPath.row == 3)
        cellHeight = 115;

    else if(indexPath.section == 1 && indexPath.row == 1)
        cellHeight = 77;
    
    else
        cellHeight = 47;

    return cellHeight;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SettingDetailTextCell *cell = [[objc_getClass("SettingDetailTextCell") alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"qscell2"];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
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
            cell.tt_titleLabel.text = @"缩小视频分享区";   
            [switchView setOn:[QSOptions sharedConfig].shareView animated:YES];
            [switchView addTarget:self
                action:@selector(qs_ShareView:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 1)
        {
            cell.tt_titleLabel.text = @"头条小视频下载";
            cell.tt_DetailLabel.text = @"播放页面长按即可下载小视频";     
            [switchView setOn:[QSOptions sharedConfig].videoDownload animated:YES];
            [switchView addTarget:self
                action:@selector(qs_videoDownload:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView; 
        }

        else if (indexPath.row == 2)
        {
            cell.tt_titleLabel.text = @"去除头条的广告";
            cell.tt_DetailLabel.text = @"包括首页推荐/悬浮、文章内、西瓜视频页、相关视频、放映厅、小说等等一切广告";     
            [switchView setOn:[QSOptions sharedConfig].normalAd animated:YES];
            [switchView addTarget:self
                action:@selector(qs_normalAd:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 3)
        {
            cell.tt_titleLabel.text = @"跳转视频评论页";
            cell.tt_DetailLabel.text = @"针对专业版，当在“头条”页面点击视频时，自动跳转至播放界面的评论界面，不再切换到视频推荐流页。建议使用左上角返回图标返回。此为测试功能";     
            [switchView setOn:[QSOptions sharedConfig].autoOnComment animated:YES];
            [switchView addTarget:self
                action:@selector(qs_autoOnComment:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
    }
    
    // else if (indexPath.section == 2)
    // {
    //     cell.tt_titleLabel.text = @"干掉头条应用";
    //     cell.tt_DetailLabel.text = @"大部分开关都无需关闭应用即可生效，若是发现有的选项没有生效，可以点击此按钮";
    //     cell.tt_titleLabel.textColor = [UIColor redColor];
    //     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //     cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    // }
    else if (indexPath.section == 2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.tt_titleLabel.text = @"关于这款插件";
    }
        
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerLabel;

    if (section == 0)
        headerLabel = @"移除";
    
    else if (section == 1)
        headerLabel = @"其他";

    else if(section == 2)
        headerLabel = @"关于";
    
    return headerLabel;
}

// - (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
// {
//     if (section == 2)
//     {
//         return @"大部分开关都无需关闭应用即可生效，若是发现有的选项没有生效，可以点击此按钮";
//     }
//     // else if (section == 3){
//     //     NSString *copyright = @"© 2020 Copyright 糖醋丶炒排骨. All rights reserved.";
//     //     return copyright;
//     // }
        
    
//     return nil;
// }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        RemoverViewController *rvc = [[RemoverViewController alloc] init];
	    [self.navigationController pushViewController:rvc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    } 

    // if(indexPath.section == 1)
    //     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // if (indexPath.section == 2) {
    //     [self exitApplication];
    // }
    if (indexPath.section == 2)
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
    [[QSOptions sharedConfig] setShareView:switchView.isOn];
}

- (void)qs_normalAd:(TTSettingSwitch *)switchView
{
    [[QSOptions sharedConfig] setNormalAd:switchView.isOn];
}

- (void)qs_videoDownload:(TTSettingSwitch *)switchView
{
    [[QSOptions sharedConfig] setVideoDownload:switchView.isOn];
}

- (void)qs_autoOnComment:(TTSettingSwitch *)switchView
{
    [[QSOptions sharedConfig] setAutoOnComment:switchView.isOn];
}

@end
