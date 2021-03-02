//
//  ViewController.m
//  iOSTest
//
//  Created by 排骨 on 2020/3/28.
//  Copyright © 2020 排骨. All rights reserved.
//

#import "RemoverViewController.h"
#import <objc/objc-runtime.h>

#define QSDefaults [NSUserDefaults standardUserDefaults]
#define origWhiteColor [UIColor colorWithRed:(242/255.0f) green:(242/255.0f)blue:(242/255.0f) alpha:1.0f]

@interface RemoverViewController () <UITableViewDataSource,UITableViewDelegate>
@end

@implementation RemoverViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.navigationItem.titleView = [objc_getClass("SSNavigationBar") navigationTitleViewWithTitle:@"可选的移除项目"];
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
    return 3;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //文章相关
    if(section == 0)
        return 3;

    //首页相关
    else if(section == 1)
        return 4;
    //其他项
    else
        return 7;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.section == 0 && indexPath.row == 10))
        return 78;

    return 49;
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
    TTSettingSwitch *switchView = [[objc_getClass("TTSettingSwitch") alloc] init];

    if (indexPath.section == 0)
    {//移除系列
        if (indexPath.row == 0)
        {
            cell.tt_titleLabel.text = @"文章下相关文章";
            switchView.on = [QSDefaults boolForKey:@"RelateRead"];
            [switchView addTarget:self
                action:@selector(qs_RelateRead:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 1)
        {
            cell.tt_titleLabel.text = @"文章下相关圈子";    
            switchView.on = [QSDefaults boolForKey:@"PaidCircle"];
            [switchView addTarget:self
                action:@selector(qs_PaidCircle:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 2)
        {
            cell.tt_titleLabel.text = @"文章下相关搜索";          
            switchView.on = [QSDefaults boolForKey:@"ArticleURL"];
            [switchView addTarget:self
                action:@selector(qs_ArticleURL:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
    }


    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.tt_titleLabel.text = @"首页的置顶新闻";
            switchView.on = [QSDefaults boolForKey:@"topnews"];
            [switchView addTarget:self
                action:@selector(qs_topnews:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 1)
        {
            cell.tt_titleLabel.text = @"首页推荐小程序";  
            switchView.on = [QSDefaults boolForKey:@"miniApp"];
            [switchView addTarget:self
                action:@selector(qs_miniApp:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 2)
        {
            cell.tt_titleLabel.text = @"首页的推荐问答";          
            switchView.on = [QSDefaults boolForKey:@"questionsAndAnswers"];
            [switchView addTarget:self
                action:@selector(qs_questionsAndAnswers:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 3)
        {
            cell.tt_titleLabel.text = @"首页的推荐专栏";        
            switchView.on = [QSDefaults boolForKey:@"column"];
            [switchView addTarget:self
                action:@selector(qs_column:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
    }


    else if(indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            cell.tt_titleLabel.text = @"视频下相关视频";
            switchView.on = [QSDefaults boolForKey:@"RelatedVideo"];
            [switchView addTarget:self
                action:@selector(qs_RelatedVideo:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 1)
        {
            cell.tt_titleLabel.text = @"新版本热榜热点";
            switchView.on = [QSDefaults boolForKey:@"HotBoard"];
            [switchView addTarget:self action:@selector(qs_HotBoard:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 2)
        {
            cell.tt_titleLabel.text = @"关注区推荐关注";
            switchView.on = [QSDefaults boolForKey:@"RecommendUser"];
            [switchView addTarget:self
                action:@selector(qs_RecommendUser:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 3)
        {
            cell.tt_titleLabel.text = @"节日和活动横幅";
            switchView.on = [QSDefaults boolForKey:@"topBarLOT"];
            [switchView addTarget:self
                action:@selector(qs_topBarLOT:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 4)
        {
            cell.tt_titleLabel.text = @"头条的直播推荐";
            cell.tt_DetailLabel.text = @"包括首页和西瓜视频页的正在直播和直播回放的推荐";     
            switchView.on = [QSDefaults boolForKey:@"Xigualive"];
            [switchView addTarget:self
                action:@selector(qs_Xigualive:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 5)
        {
            cell.tt_titleLabel.text = @"视频的流量提醒";
            [switchView setOn:[QSDefaults boolForKey:@"Indicator"] animated:YES];
            [switchView addTarget:self
                action:@selector(qs_Indicator:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
        else if (indexPath.row == 6)
        {
            cell.tt_titleLabel.text = @"顶部的热搜文字";
            cell.tt_DetailLabel.text = @"此选项的生效要求干掉应用";
            [switchView setOn:[QSDefaults boolForKey:@"hotsearch"] animated:YES];
            [switchView addTarget:self
                action:@selector(qs_hotsearch:)
                forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }
    }
        
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     if (section == 1)
        return @"这一组选项的生效要求上下滑动列表";

    return nil;
}



- (void)qs_Indicator:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"Indicator"];
    [QSDefaults synchronize];
}
- (void)qs_RelateRead:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"RelateRead"];
    [QSDefaults synchronize];
}
- (void)qs_PaidCircle:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"PaidCircle"];
    [QSDefaults synchronize];
}
- (void)qs_RelatedVideo:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"RelatedVideo"];
    [QSDefaults synchronize];
}
- (void)qs_topnews:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"topnews"];
    [QSDefaults synchronize];
}
- (void)qs_ArticleURL:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"ArticleURL"];
    [QSDefaults synchronize];
}
- (void)qs_HotBoard:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"HotBoard"];
    [QSDefaults synchronize];
}
- (void)qs_RecommendUser:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"RecommendUser"];
    [QSDefaults synchronize];
}
- (void)qs_hotsearch:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"hotsearch"];
    [QSDefaults synchronize];
}
- (void)qs_topBarLOT:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"topBarLOT"];
    [QSDefaults synchronize];
}

- (void)qs_Xigualive:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"Xigualive"];
    [QSDefaults synchronize];
}
- (void)qs_miniApp:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"miniApp"];
    [QSDefaults synchronize];
}
- (void)qs_questionsAndAnswers:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"questionsAndAnswers"];
    [QSDefaults synchronize];
}
- (void)qs_column:(TTSettingSwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"column"];
    [QSDefaults synchronize];
}


@end
