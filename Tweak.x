@interface TTTopBarSearchGuideView : UIView
// @property(retain, nonatomic) NSMutableArray *visibleLabels;
// @property(retain, nonatomic) NSMutableString *totalSearchText;
// @property(copy, nonatomic) NSString *interLabelString;
@end

NSMutableDictionary * preferences;

static BOOL PalyerTraffic;
static BOOL Indicator;
static BOOL topnewspro;
static BOOL RelateRead;
static BOOL AuthorizeHint;
static BOOL PaidCircle;
static BOOL RelatedVideo;
static BOOL ShareView;
static BOOL topnews;
static BOOL ArticleURL;
static BOOL HotBoard;
static BOOL RecommendUser;
static BOOL oldhotsearch;
static BOOL hotsearch;

%hook TTVPalyerTrafficAlert
//视频流量提醒
- (bool)shouldShow
{
	if(PalyerTraffic)
	{
		return NO;
	}
	return %orig;
}

%end

%hook TTIndicatorView
//小视频流量提醒
- (id)initWithIndicatorStyle:(long long)arg1 indicatorText:(id)arg2 indicatorImage:(id)arg3 
		maxLine:(long long)arg4 dismissHandler:(id)arg5
{
	if(Indicator)
	{
		if([arg2 isEqualToString:@"正在使用流量播放"])
		{
			return nil;
		}
	}
	return %orig;	
}



%end

%hook TTLayOutPureTitleCellView
//专业版置顶新闻

- (id)initWithFrame:(struct CGRect)arg1
{
	if(topnewspro)
	{
		return nil;
	}
	return %orig;
}

+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{	
	if(topnewspro)
	{
		return %orig(nil,0,arg3);
	}
	return %orig;
}	


%end

%hook TTFeedPureTitleController

- (id)initWithOrderedData:(id)arg1
{
	if(topnewspro)
	{
		return nil;
	}
	return %orig;
}
%end

%hook TTDetailNatantNewRelateReadView
//文章底部相关文章
- (id)initWithWidth:(double)arg1
{
	if(RelateRead)
	{
		return nil;
	}
	return %orig;
}
// - (void)refreshNewStyleFrame{}

%end

%hook TTAuthorizeHintView
//首页悬浮推广
- (void)show
{
	if(AuthorizeHint)
	{
		return;
	}
	%orig;
}
%end

%hook TTPaidCircleItem
//文章下方相关圈子的高度
// - (double)heightForWidth:(double)arg1
// {
// 	arg1 = 0;
// 	return 0;
// }
- (id)init
{
	if(PaidCircle)
	{
    	return nil;	
	}
	return %orig;
}
%end

%hook TTVVideoDetailRelatedVideoViewController
//视频下方相关视频
- (void)setAllRelatedItems:(id)allRelatedItems
{
	if(RelatedVideo)
	{
		return;
	}
	%orig;
}
%end


%hook TTVVideoDetailNatantInfoView
//缩小分享区
- (void)setShowShareView:(_Bool)showShareView
{
	if(ShareView)
	{
		return %orig(NO);
	}
	%orig;
}
%end

%hook ExploreMixedListView
//普通版置顶新闻
- (id)initWithFrame:(struct CGRect)arg1 topInset:(double)arg2 bottomInset:(double)arg3
{
	if(topnews)
	{
		return %orig(arg1,arg2,0);
	}
	return %orig;
}
	
%end

%hook ArticleURLSetting
//文章底部相关搜索
+ (id)newArticleInfoString
{
	if(ArticleURL)
	{
		return nil;
	}
	return %orig;
}
%end
// %hook NSURL
// //文章底部相关搜索
// + (id)URLWithString:(NSString *)URLString
// {
// 	if([URLString containsString:@"https://is.snssdk.com/2/article/information/v23"]
// 		|| [URLString containsString:@"/article/information/v26"])
// 	{
// 		// NSLog(@"NB啊小老弟，让我改掉这个请求");
// 		// URLString = nil;
// 		return nil;
// 	}
// 	return %orig;
// }

// %end

%hook TTHotBoardFeedCellView
//新版本头条会出现的热榜
- (id)initWithFrame:(struct CGRect)arg1
{
	if(HotBoard)
	{
		return nil;
	}
	return %orig;
}

%end

%hook TTRecommendUserCellView
//关注列表“他们也在用头条”
- (id)initWithFrame:(struct CGRect)arg1
{
	if(RecommendUser)
	{
		return nil;
	}
	return %orig;
}
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3 slice:(_Bool)arg4
{
	if(RecommendUser)
	{
		return %orig(nil,0,arg3,arg4);
	}
	return %orig;
}

%end

%hook TTTopBar
//7.0.9顶部热搜
- (void)setSearchLabelContainer:(UIView *)searchLabelContainer 
{
	if(oldhotsearch)
	{
		NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
		NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
		if([appVersion isEqualToString:@"7.0.9"])
		{
			return;
		}
	}
	
	%orig;
}

%end

%hook TTTopBarSearchGuideView
//新版顶部热搜，旧版没有这个类
- (void)layoutWithSearchWords:(id)arg1 containerWidth:(double)arg2 containerHeight:(double)arg3
{
	if(hotsearch)
	{
		return %orig(arg1,0,0);
	}
	%orig;
}
%end


static void loadPrefs()
{
	static NSString * file = @"/User/Library/Preferences/com.paigu.toutiaopref.plist";
	NSMutableDictionary * preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:file];

	if(!preferences)
	{
		preferences = [[NSMutableDictionary alloc] init];
	}
	else
	{
		PalyerTraffic = [[preferences objectForKey:@"PalyerTraffic"] boolValue];
		Indicator = [[preferences objectForKey:@"Indicator"] boolValue];
		topnewspro = [[preferences objectForKey:@"topnewspro"] boolValue];
		RelateRead = [[preferences objectForKey:@"RelateRead"] boolValue];
		AuthorizeHint = [[preferences objectForKey:@"AuthorizeHint"] boolValue];
		PaidCircle = [[preferences objectForKey:@"PaidCircle"] boolValue];
		RelatedVideo = [[preferences objectForKey:@"RelatedVideo"] boolValue];
		ShareView = [[preferences objectForKey:@"ShareView"] boolValue];
		topnews = [[preferences objectForKey:@"topnews"] boolValue];
		ArticleURL = [[preferences objectForKey:@"ArticleURL"] boolValue];
		HotBoard = [[preferences objectForKey:@"HotBoard"] boolValue];
		RecommendUser = [[preferences objectForKey:@"RecommendUser"] boolValue];
		oldhotsearch = [[preferences objectForKey:@"oldhotsearch"] boolValue];
		hotsearch = [[preferences objectForKey:@"hotsearch"] boolValue];
	}
	[preferences release];
}
	
static NSString *nsNotificationString = @"com.lacertosusrepo.safiprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, 
	CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	loadPrefs();
}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	loadPrefs();
	notificationCallback(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, 
		notificationCallback, (CFStringRef)nsNotificationString, NULL, 
			CFNotificationSuspensionBehaviorCoalesce);

	[pool release];
}
///////////////////////////////////////////////////测试开关
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///////////////////////////////////////////////////

// %hook SettingView

// #define MJDefaults [NSUserDefaults standardUserDefaults]
// #define MJAutoKey @"mj_auto_key"
// // 一共有多少组
// - (long long)numberOfSectionsInTableView:(id)arg1
// {
// 	return %orig+1;
// }

// - (long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2
// {
// 	return %orig+2;
// }

// - (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2
// {
// 	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
// 		reuseIdentifier:nil];

	
// }

// %end




























