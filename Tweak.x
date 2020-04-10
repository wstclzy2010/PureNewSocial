%hook TTVPalyerTrafficAlert
//视频流量提醒
- (bool)shouldShow
{
	return NO;
}

%end

%hook TTIndicatorView
//小视频流量提醒
- (id)initWithIndicatorStyle:(long long)arg1 indicatorText:(id)arg2 indicatorImage:(id)arg3 
	maxLine:(long long)arg4 dismissHandler:(id)arg5
{
	if([arg2 isEqualToString:@"正在使用流量播放"])
	{
		return nil;
	}
	return %orig;
}

%end

%hook TTLayOutPureTitleCellView
//专业版置顶新闻
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{	
	return %orig(nil,0,arg3);
}

%end

%hook TTFeedPureTitleController
//
- (id)buidFeedItemsLayoutWithOrderedData:(id)arg1
{
	return nil;
}

%end

%hook TTDetailNatantNewRelateReadView
//文章底部相关文章
- (id)initWithWidth:(double)arg1
{
    return %orig(0);
}
- (void)refreshNewStyleFrame{}

%end

%hook TTAuthorizeHintView
//首页悬浮推广
- (void)show{}
%end

%hook TTPaidCircleItem
//文章下方相关圈子的高度
- (double)heightForWidth:(double)arg1
{
	arg1 = 0;
	return 0;
}
%end

%hook TTVVideoDetailRelatedVideoViewController
//视频下方相关视频
- (void)setAllRelatedItems:(id)allRelatedItems{}
%end


%hook TTVVideoDetailNatantInfoView
//缩小分享区
- (void)setShowShareView:(_Bool)showShareView
{
	%orig(NO);
}
%end

%hook ExploreMixedListView
//普通版置顶新闻
- (id)initWithFrame:(struct CGRect)arg1 topInset:(double)arg2 bottomInset:(double)arg3
{
	return %orig(arg1,arg2,0);
}
	
%end


%hook NSURL
//文章底部相关搜索
+ (id)URLWithString:(NSString *)URLString
{
	if([URLString containsString:@"https://is.snssdk.com/2/article/information/v23"]
		|| [URLString containsString:@"/article/information/v26"])
	{
		NSLog(@"NB啊小老弟，让我改掉这个请求");
		URLString = @"https://is.snssdk.com/2/article/fucku/";
	}
	return %orig;
}
%end


// %hook TTVPlayerTipShareFinished
// 	- (id)initWithFrame:(struct CGRect)arg1{
// 		return nil;
// 	}
// %end

