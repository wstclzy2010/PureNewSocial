@interface TTTopBarSearchGuideView : UIView
@end

@interface TTCollapsingTopBar
- (void)removeTopBarLOTAnimationViewIfNeeded;
@end

@interface ExploreOrderedData 
@property(retain, nonatomic) NSString *stickLabel;
@end

//@class TTVRelatedItem;

@interface TTVRelatedItem : NSArray
@property(retain, nonatomic) NSString *card_type;
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
static BOOL topBarLOT;
static BOOL normalAd;
static BOOL Xigualive;


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
		topBarLOT = [[preferences objectForKey:@"topBarLOT"] boolValue];
		normalAd = [[preferences objectForKey:@"normalAd"] boolValue];
		Xigualive = [[preferences objectForKey:@"Xigualive"] boolValue];
	}
	[preferences release];
}
	
static NSString *nsNotificationString = @"com.paigu.toutiaopref/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, 
	CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	loadPrefs();
}


%hook TTVPalyerTrafficAlert
//视频流量提醒
- (bool)shouldShow
{
	if(PalyerTraffic)
		return NO;

	return %orig;
}

%end


%hook AWEVideoContainerViewController
// //小视频流量提醒
- (_Bool)needCellularAlert
{
	if(Indicator)
		return NO;
	
	return %orig;
}
%end

%hook AWEVideoContainerViewControllerNew
// 7.9.0测试版小视频流量提醒
- (_Bool)needCellularAlert
{
	loadPrefs();
	if(Indicator)
		return NO;
	
	return %orig;
}
%end

%hook TTExploreOrderedDataManager
//792内测普通版首页feed流数据
- (NSMutableArray *)mutableItems
{
	loadPrefs();

	if(!normalAd && !topnews && !miniApp)
		return %orig;

	NSMutableArray *origArray = %orig;
	NSMutableArray *adArray = [NSMutableArray new];
	NSMutableArray *miniArray = [NSMutableArray new];
	NSMutableArray *topArray = [NSMutableArray new];

	if(origArray.count > 0)
	{
		if(normalAd)
		{
			
			[origArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
			{
				if([[model adIDStr] length] > 0)
					[adArray addObject: model];
			}];

			if(adArray.count > 0)
				[origArray removeObjectsInArray:adArray];
		}

		if(miniApp)
		{
			[origArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
			{
				if([model cellType] == 93) //小程序的cell类型为93
					[miniArray addObject: model];
			}];

			if(miniArray.count > 0)
				[origArray removeObjectsInArray:miniArray];
		}

		if(topnews)
		{
			[origArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
			{
				if([[model stickLabel] isEqualToString:@"置顶"])
					[topArray addObject: model];
			}];

			if(topArray.count > 0)
				[origArray removeObjectsInArray:topArray];
		}
	}
	
	return origArray;
}

%end


%hook ExploreFetchListManager
//专业版置顶新闻
- (void)setItems:(NSArray *)items
{
	if(topnewspro)
	{
		NSMutableArray *temArray = [NSMutableArray new];
		NSMutableArray *adArray = [NSMutableArray new];

		if(items.count > 0)
			for (ExploreOrderedData * model in items) 
				[temArray addObject: model];

		[temArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _Nonnull stop)
		{
			if([[model stickLabel] isEqualToString:@"置顶"])
				[adArray addObject: model];
		}];

		if(adArray.count > 0)
			[temArray removeObjectsInArray:adArray];

		items = [temArray mutableCopy];

		return %orig(items);
	}
    
    %orig;
}

+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{	
	if(topnewspro)
		return %orig(nil,arg2,arg3);
	
	return %orig;
}

%end

%hook TTLayOutPureTitleCell
//7.0.9置顶新闻
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{	
	if(topnewspro)
		return %orig(nil,arg2,arg3);
	
	return %orig;
}
%end

%hook TTFeedPureTitleCell
//普通版置顶新闻
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{
	if(topnewspro || topnews)
		return %orig(nil,arg2,arg3);

	return %orig;
}
%end


%hook TTDetailNatantNewRelateReadView
//文章底部相关文章
- (id)initWithWidth:(double)arg1
{
	if(RelateRead)
		return nil;

	return %orig;
}
// - (void)refreshNewStyleFrame{}

%end

%hook TTAuthorizeHintView
//首页悬浮推广
- (void)show
{
	if(AuthorizeHint)
		return;

	%orig;
}
%end

%hook TTPaidCircleItem
//文章下方相关圈子的高度
- (id)init
{
	if(PaidCircle)
    	return nil;	

	return %orig;
}
%end

// %hook TTVVideoDetailRelatedVideoViewController
// //视频下方相关视频
// - (void)setAllRelatedItems:(id)allRelatedItems
// {
// 	if(RelatedVideo)
// 	{
// 		return;
// 	}
// 	%orig;
// }
// %end


%hook TTVVideoDetailNatantInfoView
//缩小分享区
- (void)setShowShareView:(_Bool)showShareView
{
	if(ShareView)
		return %orig(NO);

	%orig;
}
%end

%hook ArticleURLSetting
//文章底部相关搜索
+ (id)newArticleInfoString
{
	if(ArticleURL)
		return nil;

	return %orig;
}
%end

%hook TTHotBoardFeedCellView
//新版本头条会出现的热榜
- (id)initWithFrame:(struct CGRect)arg1
{
	if(HotBoard)
		return nil;

	return %orig;
}

%end

%hook TTHotBoardLynxCell
//新版本头条会出现的热榜热点
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{
	if(HotBoard)
		return %orig(nil,0,arg3);

	return %orig;
}
- (void)willAppear{}
%end

%hook TTXiguaLiveNewCell
//西瓜直播
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{
	if(Xigualive)
		return %orig(nil,0,arg3);

	return %orig;
}
%end

%hook TTRecommendUserCellView
//关注列表“他们也在用头条”
- (id)initWithFrame:(struct CGRect)arg1
{
	if(RecommendUser)
		return nil;

	return %orig;
}
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3 slice:(_Bool)arg4
{
	if(RecommendUser)
		return %orig(nil,0,arg3,arg4);

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
			return;
	}
	
	%orig;
}

%end

%hook TTTopBarSearchGuideView
//新版顶部热搜，旧版没有这个类
- (void)layoutWithSearchWords:(id)arg1 containerWidth:(double)arg2 containerHeight:(double)arg3
{
	if(hotsearch)
		return %orig(arg1,0,0);

	%orig;
}
%end



%hook TTCollapsingTopBar
//移除新版本顶部节日动画
- (void)setupTopBarLOTAnimationView
{
	if(topBarLOT)
	{
		[self removeTopBarLOTAnimationViewIfNeeded];
		return;		
	}
	%orig;
}
- (void)setupSearchBarLOTAnimationView
{
	if(topBarLOT)
		return;

	%orig;
}
- (void)setupBackgroundLOTAnimationView
{
	if(topBarLOT)
		return;

	%orig;
}
- (void)setMaxTopBarHeight:(double)maxTopBarHeight
{
	if(topBarLOT)
		return %orig(72);

	%orig;
}
%end


%hook TTShowADTask
//开屏广告
- (void)startWithApplication:(id)arg1 options:(id)arg2
{
	if(normalAd)
		return;

	%orig;
}
%end

%hook SSADBaseModel
//详情页广告
- (id)initWithDictionary:(id)arg1
{
	if(normalAd)
		return nil;

	return %orig;
}
%end

%hook TTAdFeedModel
//首页广告数据
- (void)setDynamic_adWithNSDictionary:(id)arg1
{
	if(normalAd)
		return;

	%orig;
}
- (void)setDynamic_adWithNSString:(id)arg1
{
	if(normalAd)
		return;

	%orig;
}
- (void)setRaw_ad_data:(NSDictionary *)raw_ad_data
{
	if(normalAd)
		return;

	%orig;
}
%end

%hook TTADVanGoghCell
//首页广告视图
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{
	if(normalAd)
		return %orig(nil,arg2,arg3);

	return %orig;
}
%end

%hook TTFeedVideoADCell
//首页广告视图
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{
	if(normalAd)
		return %orig(nil,arg2,arg3);

	return %orig;
}
%end

%hook TTVFeedListVideoAdCell
//西瓜视频页广告cell
- (void)setItem:(id)arg1
{
	if(normalAd)
		if([arg1 isKindOfClass:%c(TTVFeedListVideoAdItem)])
		{
			arg1 = nil;
			return;
		}	
	%orig;	
}
%end

%hook TTVFeedListPicAdCell
//7.9.2测试版西瓜视频页广告cell
- (void)setItem:(id)arg1
{
	if(normalAd)
		if([arg1 isKindOfClass:%c(TTVFeedListPicAdCell)])
		{
			arg1 = nil;
			return;
		}
	%orig;	
}
%end


%hook TTVVideoDetailCommoditySwiperViewController
//视频页商品推荐
- (id)init
{
	if(normalAd)
		return nil;

	return %orig;
}
%end


%hook TTVVideoDetailRelatedVideoViewController
//普通版相关视频广告
- (void)setAllRelatedItems:(NSArray *)allRelatedItems
{
	if(RelatedVideo)
		return %orig(nil);
	
	if(normalAd)
	{
		NSMutableArray *temArray = [NSMutableArray new];
		if(allRelatedItems.count > 0)
			for (id model in allRelatedItems)
				[temArray addObject:model];

		[temArray removeObjectAtIndex:0];
		allRelatedItems = [temArray mutableCopy];

		return %orig(allRelatedItems);
	}

	%orig;
}
%end


@interface BDNovelFreeAdHandler
@property(nonatomic) _Bool lastGetFreeInAddIsFree;
@property(nonatomic) long long currentBeginFreeAdTime;
@property(nonatomic) long long limitAdFreeTime; 
@end


%hook BDNovelFreeAdHandler
//小说广告
- (_Bool)isInAdFreeTime
{
	loadPrefs();
	if(normalAd)
	{
		self.lastGetFreeInAddIsFree = YES;
		self.currentBeginFreeAdTime = 1;
		self.limitAdFreeTime = 6666666;
		return YES;
	}
	
	return %orig;
}
%end

%ctor
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	loadPrefs();
	notificationCallback(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, 
		notificationCallback, (CFStringRef)nsNotificationString, NULL, 
			CFNotificationSuspensionBehaviorCoalesce);

	[pool release];
}
