//
//  QSOptions.m
//  QSSettingUI
//
//  Created by 排骨 on 2020/8/4.
//  Copyright © 2020 排骨. All rights reserved.
//

#import "QSOptions.h"
#define QSDefaults [NSUserDefaults standardUserDefaults]

static NSString * const qsindicator = @"indicator";
static NSString * const qstopnews = @"topnews";
static NSString * const qsrelateRead = @"relateRead";
static NSString * const qspaidCircle = @"paidCircle";
static NSString * const qsrelatedVideo = @"relatedVideo";
static NSString * const qsshareView = @"shareView";
static NSString * const qsarticleURL = @"articleURL";
static NSString * const qshotBoard = @"hotBoard";
static NSString * const qsrecommendUser = @"recommendUser";
static NSString * const qshotsearch = @"hotsearch";
static NSString * const qstopBarLOT = @"topBarLOT";
static NSString * const qsnormalAd = @"normalAd";
static NSString * const qsxigualive = @"xigualive";
static NSString * const qsminiApp = @"miniApp";
static NSString * const qsvideoDownload = @"videoDownload";
static NSString * const qsquestionsAndAnswers = @"questionsAndAnswers";
static NSString * const qscolumn = @"column";
static NSString * const qsautoOnComment = @"autoOnComment";


@implementation QSOptions

+ (instancetype)sharedConfig
{
    static QSOptions *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[QSOptions alloc] init];
    });
    return config;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _indicator = [QSDefaults boolForKey:qsindicator];
        _topnews = [QSDefaults boolForKey:qstopnews];
        _relateRead = [QSDefaults boolForKey:qsrelateRead];
        _paidCircle = [QSDefaults boolForKey:qspaidCircle];
        _relatedVideo = [QSDefaults boolForKey:qsrelatedVideo];
        _shareView = [QSDefaults boolForKey:qsshareView];
        _articleURL = [QSDefaults boolForKey:qsarticleURL];
        _hotBoard = [QSDefaults boolForKey:qshotBoard];
        _recommendUser = [QSDefaults boolForKey:qsrecommendUser];
        _hotsearch = [QSDefaults boolForKey:qshotsearch];
        _topBarLOT = [QSDefaults boolForKey:qstopBarLOT];
        _normalAd = [QSDefaults boolForKey:qsnormalAd];
        _xigualive = [QSDefaults boolForKey:qsxigualive];
        _miniApp = [QSDefaults boolForKey:qsminiApp];
        _videoDownload = [QSDefaults boolForKey:qsvideoDownload];
        _questionsAndAnswers = [QSDefaults boolForKey:qsquestionsAndAnswers];
        _column = [QSDefaults boolForKey:qscolumn];
        _autoOnComment = [QSDefaults boolForKey:qsautoOnComment];
    }
    return self;
}



- (void)setIndicator:(BOOL)indicator
{
    _indicator = indicator;
    [QSDefaults setBool:indicator forKey:qsindicator];
    [QSDefaults synchronize];
}

- (void)setTopnews:(BOOL)topnews
{
    _topnews = topnews;
    [QSDefaults setBool:topnews forKey:qstopnews];
    [QSDefaults synchronize];
}

- (void)setRelateRead:(BOOL)relateRead
{
    _relateRead = relateRead;
    [QSDefaults setBool:relateRead forKey:qsrelateRead];
    [QSDefaults synchronize];
}

- (void)setPaidCircle:(BOOL)paidCircle
{
    _paidCircle = paidCircle;
    [QSDefaults setBool:paidCircle forKey:qspaidCircle];
    [QSDefaults synchronize];
}

- (void)setRelatedVideo:(BOOL)relatedVideo
{
    _relatedVideo = relatedVideo;
    [QSDefaults setBool:relatedVideo forKey:qsrelatedVideo];
    [QSDefaults synchronize];
}

- (void)setShareView:(BOOL)shareView
{
    _shareView = shareView;
    [QSDefaults setBool:shareView forKey:qsshareView];
    [QSDefaults synchronize];
}

- (void)setArticleURL:(BOOL)articleURL
{
    _articleURL = articleURL;
    [QSDefaults setBool:articleURL forKey:qsarticleURL];
    [QSDefaults synchronize];
}

- (void)setHotBoard:(BOOL)hotBoard
{
    _hotBoard = hotBoard;
    [QSDefaults setBool:hotBoard forKey:qshotBoard];
    [QSDefaults synchronize];
}

- (void)setRecommendUser:(BOOL)recommendUser
{
    _recommendUser = recommendUser;
    [QSDefaults setBool:recommendUser forKey:qsrecommendUser];
    [QSDefaults synchronize];
}

- (void)setHotsearch:(BOOL)hotsearch
{
    _hotsearch = hotsearch;
    [QSDefaults setBool:hotsearch forKey:qshotsearch];
    [QSDefaults synchronize];
}

- (void)setTopBarLOT:(BOOL)topBarLOT
{
    _topBarLOT = topBarLOT;
    [QSDefaults setBool:topBarLOT forKey:qstopBarLOT];
    [QSDefaults synchronize];
}

- (void)setNormalAd:(BOOL)normalAd
{
    _normalAd = normalAd;
    [QSDefaults setBool:normalAd forKey:qsnormalAd];
    [QSDefaults synchronize];
}

- (void)setXigualive:(BOOL)xigualive
{
    _xigualive = xigualive;
    [QSDefaults setBool:xigualive forKey:qsxigualive];
    [QSDefaults synchronize];
}

- (void)setMiniApp:(BOOL)miniApp
{
    _miniApp = miniApp;
    [QSDefaults setBool:miniApp forKey:qsminiApp];
    [QSDefaults synchronize];
}

- (void)setVideoDownload:(BOOL)videoDownload
{
    _videoDownload = videoDownload;
    [QSDefaults setBool:videoDownload forKey:qsvideoDownload];
    [QSDefaults synchronize];
}

- (void)setQuestionsAndAnswers:(BOOL)questionsAndAnswers
{
    _questionsAndAnswers = questionsAndAnswers;
    [QSDefaults setBool:questionsAndAnswers forKey:qsquestionsAndAnswers];
    [QSDefaults synchronize];
}

- (void)setColumn:(BOOL)column
{
    _column = column;
    [QSDefaults setBool:column forKey:qscolumn];
    [QSDefaults synchronize];
}

- (void)setAutoOnComment:(BOOL)autoOnComment
{
    _autoOnComment = autoOnComment;
    [QSDefaults setBool:autoOnComment forKey:qsautoOnComment];
    [QSDefaults synchronize];
}


@end
