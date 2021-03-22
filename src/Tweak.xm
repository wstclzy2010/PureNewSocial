#import "ViewController.h"

static BOOL isShow = NO;
static MBProgressHUD *hud = nil;



%hook TTVVideoDetailViewController
//跳转播放评论页后，返回按钮跳转到首页
- (void)_topViewBackButtonPressed
{
	if(![QSOptions sharedConfig].autoOnComment)
		return %orig;

	[self.navigationController popToRootViewControllerAnimated:YES];
}
%end



%hook TTVDetailFeedBottomContainerView
//自动跳转视频评论页
- (void)layoutSubviews
{
	if(![QSOptions sharedConfig].autoOnComment)
		return %orig;

	%orig;

	if([[[self nextResponder] nextResponder] isMemberOfClass:%c(TTVDetailFeedVideoCell)])
	{
		if(self.cellEntity.isFirstVideo) //isFirstVideo判断当前视频是否为最开始点击的视频，避免在视频流页面向下滑动时又出现跳转到首个视频的评论页面的情况
		{
			[self commentButtonHandler:nil];
			return;
		}
	}	
}
%end



%hook TTAdActionModel
- (id)initWithAdId:(id)arg1 logExtra:(id)arg2 extraData:(id)arg3
{
	return [QSOptions sharedConfig].normalAd ? nil : %orig;
}
%end

%hook TTAdWebActionManager
+ (id)sharedManager
{
	return [QSOptions sharedConfig].normalAd ? nil : %orig;
}
%end

%hook TTReachability
//模拟wifi连接
- (long long)currentReachabilityStatus
{
	return [QSOptions sharedConfig].indicator ? 1 : %orig;
}
%end




%hook TTExploreOrderedDataManager
//8.1.4普通版首页feed流数据
- (NSMutableArray *)mutableItems
{

	if(![QSOptions sharedConfig].normalAd 
		&& ![QSOptions sharedConfig].topnews 
		&& ![QSOptions sharedConfig].miniApp 
		&& ![QSOptions sharedConfig].xigualive 
		&& ![QSOptions sharedConfig].questionsAndAnswers 
		&& ![QSOptions sharedConfig].hotBoard 
		&& ![QSOptions sharedConfig].column)
		return %orig;

	NSMutableArray *origArray = %orig;
	NSMutableArray *adArray = [NSMutableArray new];
	NSMutableArray *miniArray = [NSMutableArray new];
	NSMutableArray *topArray = [NSMutableArray new];
	NSMutableArray *liveArray = [NSMutableArray new];
	NSMutableArray *QAArray = [NSMutableArray new];
	NSMutableArray *hotBoardArray = [NSMutableArray new];
	NSMutableArray *columnArray = [NSMutableArray new];

	if(origArray.count > 0)
	{
		if([QSOptions sharedConfig].normalAd)
		{
			
			[origArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
			{
				if([[model adIDStr] length] > 0)
					[adArray addObject: model];
			}];

			if(adArray.count > 0)
				[origArray removeObjectsInArray:adArray];
		}

		if([QSOptions sharedConfig].miniApp)
		{
			[origArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
			{
				if([model cellType] == 93) //小程序的cell类型为93
					[miniArray addObject: model];
			}];

			if(miniArray.count > 0)
				[origArray removeObjectsInArray:miniArray];
		}

		if([QSOptions sharedConfig].topnews)
		{
			[origArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
			{
				if([[model stickLabel] isEqualToString:@"置顶"])
					[topArray addObject: model];
			}];

			if(topArray.count > 0)
				[origArray removeObjectsInArray:topArray];
		}
		if([QSOptions sharedConfig].xigualive)
		{
			[origArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
			{
				if([model cellType] == 314 || [model cellType] == 318)//首页直播cell类型为314,直播回放为318
					[liveArray addObject: model];
			}];

			if(liveArray.count > 0)
				[origArray removeObjectsInArray:liveArray];
		}
		if([QSOptions sharedConfig].questionsAndAnswers)
		{
			[origArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
			{
				if([model cellType] == 202)//首页问答cell类型为202
					[QAArray addObject: model];
			}];

			if(QAArray.count > 0)
				[origArray removeObjectsInArray:QAArray];
		}
		if([QSOptions sharedConfig].hotBoard)
		{
			[origArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
			{
				if([model cellType] == 114)//首页热榜cell类型为114
					[hotBoardArray addObject: model];
			}];

			if(hotBoardArray.count > 0)
				[origArray removeObjectsInArray:hotBoardArray];
		}
		if([QSOptions sharedConfig].column)
		{
			[origArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
			{
				if([[model label] isEqualToString:@"专栏"])
					[columnArray addObject: model];
			}];

			if(columnArray.count > 0)
				[origArray removeObjectsInArray:columnArray];
		}
	}
	
	return origArray;
}

%end

%hook ExploreFetchListManager
//专业版置顶新闻(在7.9.2测试版中不再使用)
- (void)setItems:(NSArray *)items
{
	if([QSOptions sharedConfig].topnews)
	{
		NSMutableArray *temArray = [NSMutableArray new];
		NSMutableArray *adArray = [NSMutableArray new];

		if(items.count > 0)
			for (ExploreOrderedData * model in items) 
				[temArray addObject: model];

		[temArray enumerateObjectsUsingBlock:^(ExploreOrderedData * model, NSUInteger idx, BOOL * _stop)
		{
			if([[model stickLabel] isEqualToString:@"置顶"] || [[model adIDStr] length] > 0)
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
	return [QSOptions sharedConfig].topnews ? %orig(nil,arg2,arg3) : %orig;
}

%end

%hook TTLayOutPureTitleCell
//7.0.9置顶新闻
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{	
	return [QSOptions sharedConfig].topnews ? %orig(nil,arg2,arg3) : %orig;
}
%end

%hook TTFeedPureTitleCell
//普通版置顶新闻
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{
	return [QSOptions sharedConfig].topnews ? %orig(nil,arg2,arg3) : %orig;
}
%end


%hook TTDetailNatantNewRelateReadView
//文章底部相关文章
- (id)initWithWidth:(double)arg1
{
	return [QSOptions sharedConfig].relateRead ? nil : %orig;
}
%end

%hook TTDetailNatantRelateArticleGroupView
//7.8.3新版文章底部相关文章
- (id)initWithWidth:(double)arg1
{
	return [QSOptions sharedConfig].relateRead ? nil : %orig;
}
%end


%hook TTAuthorizeHintView
//首页悬浮推广
- (void)show
{
	if([QSOptions sharedConfig].normalAd)
		return;

	%orig;
}
%end

%hook TTFeedActivityView
- (_Bool)shouldShowActivity
{
	return [QSOptions sharedConfig].normalAd ? NO : %orig;
}

- (id)init
{
	return [QSOptions sharedConfig].normalAd ? nil : %orig;
}
%end

%hook TTPaidCircleItem
//文章下方相关圈子的高度
- (id)init
{
	return [QSOptions sharedConfig].paidCircle ? nil : %orig;
}
%end



%hook TTVVideoDetailNatantInfoView
//缩小分享区
- (void)setShowShareView:(_Bool)showShareView
{
	if([QSOptions sharedConfig].shareView)
		return %orig(NO);

	%orig;
}
%end

%hook ArticleURLSetting
//文章底部相关搜索
+ (id)adArticleInfoString
{
	return [QSOptions sharedConfig].articleURL ? nil : %orig;
}
+ (id)new27ArticleInfoString
{
	return [QSOptions sharedConfig].articleURL ? nil : %orig;
}

+ (id)newArticleInfoString
{
	return [QSOptions sharedConfig].articleURL ? nil : %orig;
}
%end

%hook TTHotBoardFeedCellView
//新版本头条会出现的热榜
- (id)initWithFrame:(struct CGRect)arg1
{
	return [QSOptions sharedConfig].hotBoard ? nil : %orig;
}

%end

%hook TTHotBoardLynxCell
//新版本头条会出现的热榜热点
+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3
{
	return [QSOptions sharedConfig].hotBoard ? %orig(nil,0,arg3) : %orig;
}

- (void)willAppear
{
	if([QSOptions sharedConfig].hotBoard)
		return;
	
	%orig;
}
%end



%hook TTRecommendUserCellView
//关注列表“他们也在用头条”
- (id)initWithFrame:(struct CGRect)arg1
{
	return [QSOptions sharedConfig].recommendUser ? nil : %orig;
}

+ (double)heightForData:(id)arg1 cellWidth:(double)arg2 listType:(unsigned long long)arg3 slice:(_Bool)arg4
{
	return [QSOptions sharedConfig].recommendUser ? %orig(nil,0,arg3,arg4) : %orig;
}

%end



%hook TTTopBarSearchGuideView
//新版顶部热搜，旧版没有这个类
- (id)initWithFrame:(struct CGRect)arg1
{
	return [QSOptions sharedConfig].hotsearch ? nil : %orig;
}
%end



// %hook TTCollapsingTopBar
// //移除新版本顶部节日动画
// - (void)setupTopBarLOTAnimationView
// {
//
// 	if(topBarLOT)
// 	{
// 		[self removeTopBarLOTAnimationViewIfNeeded];
// 		return;		
// 	}
// 	%orig;
// }
// - (void)setupSearchBarLOTAnimationView
// {
//
// 	if(topBarLOT)
// 		return;

// 	%orig;
// }
// - (void)setupBackgroundLOTAnimationView
// {
//
// 	if(topBarLOT)
// 		return;

// 	%orig;
// }
// - (void)setMaxTopBarHeight:(double)maxTopBarHeight
// {
//
// 	if(topBarLOT)
// 		return %orig(72);

// 	%orig;
// }
// %end


%hook TTShowADTask
//开屏广告
- (void)startWithApplication:(id)arg1 options:(id)arg2
{
	if([QSOptions sharedConfig].normalAd)
		return;

	%orig;
}
%end

%hook SSADBaseModel
//详情页广告
- (id)initWithDictionary:(id)arg1
{
	return [QSOptions sharedConfig].normalAd ? nil : %orig;
}
%end

%hook TLIndexPathDataModel
//西瓜视频页feed流数据
- (id)initWithItems:(id)arg1
{
	if(![QSOptions sharedConfig].normalAd && ![QSOptions sharedConfig].xigualive)
		return %orig;
	
	NSMutableArray *origArray = arg1;
	NSMutableArray *adArray = [NSMutableArray new];

	if(origArray.count > 0)
		[origArray enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _stop)
		{
			if([QSOptions sharedConfig].normalAd && [model isMemberOfClass:%c(TTVFeedListVideoAdItem)])
				[adArray addObject:model];

			if([QSOptions sharedConfig].xigualive && [model isMemberOfClass:%c(TTVFeedListLiveItem)])
				[adArray addObject:model];
		}];

	if(adArray.count > 0)
		[origArray removeObjectsInArray:adArray];


	return %orig(origArray);
}
%end



%hook TTAppExternalAppBridge
- (void)preloadAdMpWithParam:(id)arg1 callback:(id)arg2 engine:(id)arg3 controller:(id)arg4
{
	if([QSOptions sharedConfig].normalAd)
		return;

	%orig;
}
%end

%hook TTAdSplashControllerView
//启动广告
- (id)initWithFrame:(struct CGRect)arg1 model:(id)arg2
{
	return [QSOptions sharedConfig].normalAd ? nil : %orig;
}
%end

%hook TTVVideoDetailCommoditySwiperViewController
//视频页商品推荐
- (id)init
{
	return [QSOptions sharedConfig].normalAd ? nil : %orig;
}
%end

%hook TTVRelatedVideoItem
- (_Bool)hasAd
{
	return [QSOptions sharedConfig].normalAd ? NO : %orig;
}
%end




%hook TTVVideoDetailRelatedVideoViewController
//普通版相关视频数据
- (NSArray *)allRelatedItems
{

	if(![QSOptions sharedConfig].normalAd && ![QSOptions sharedConfig].relatedVideo)
		return %orig;

	if([QSOptions sharedConfig].relatedVideo)
		return nil;
	
	NSArray *origArr = %orig;
	NSMutableArray *adArray = [NSMutableArray new];
	NSMutableArray *temArray = [NSMutableArray new];
	if([QSOptions sharedConfig].normalAd)
	{
		if(origArr.count > 0)
			[origArr enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _stop)
			{
				[temArray addObject:model];
			}];

		if(temArray.count > 0)		
			[temArray enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _stop)
			{
				if ([model isMemberOfClass:%c(TTVVideoDetailRelatedAdItem)]
					||[model showDislike])  //TTVDetailRelatedVideoItem为广告item时，它的showDislike值为YES
					[adArray addObject:model];
			}];

		if(adArray.count > 0)
			[temArray removeObjectsInArray:adArray];
	}
	
	origArr = [temArray mutableCopy];

	return origArr;
}
%end

%hook TTVLPlayer
//放映厅电影广告
- (void)requestPasterAD
{
	if([QSOptions sharedConfig].normalAd)
		return;

	%orig;
}
%end

%hook TTVContinuousADHelper
- (id)init
{
	return [QSOptions sharedConfig].normalAd ? nil : %orig;
}
%end



%hook BDNovelFreeAdHandler
//小说广告
- (_Bool)isInAdFreeTime
{
	if([QSOptions sharedConfig].normalAd)
	{
		self.lastGetFreeInAddIsFree = YES;
		self.currentBeginFreeAdTime = 1;
		self.limitAdFreeTime = 6666666;
		return YES;
	}
	
	return %orig;
}
%end

%hook TTIGTableViewSectionMap
//微头条广告数据
- (void)updateWithObjects:(id)arg1 sectionControllers:(id)arg2
{
	if(![QSOptions sharedConfig].normalAd)
		return %orig(arg1,arg2);

	NSMutableArray *origArray = arg1;
	NSMutableArray *adArray = [NSMutableArray new];

	if(origArray.count > 0)
		[origArray enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _stop)
		{
			if ([model isKindOfClass:%c(ExploreOrderedData)])
				if([[model adIDStr] length] > 0)
					[adArray addObject: model];
		}];

	if(adArray.count > 0)
		[origArray removeObjectsInArray:adArray];

	%orig(origArray,arg2);
}
%end



%hook TTVPasterADModel
- (void)setVideoPasterADInfoModel:(id)videoPasterADInfoModel
{
	if([QSOptions sharedConfig].normalAd)
		return;
	
	%orig;
}
%end



/*小视频*/
%hook TSVNewControlOverlayViewController

- (void)viewDidLoad 
{
    %orig;
	if([QSOptions sharedConfig].videoDownload)
	{
		UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    	[self.view addGestureRecognizer:longPress];
	}
}

%new
- (void)longPressAction:(UILongPressGestureRecognizer *)sender 
{
    //解决手势触发两次
    if (sender.state == UIGestureRecognizerStateBegan) 
	{
        NSURL *url = nil;
        UIView *selfView = self.view;
        NSArray *arrViews = [[selfView superview] subviews];
        for(UIView *view in arrViews) {
            if ([view isKindOfClass:%c(AWEVideoPlayView)]) {
                TTShortVideoModel *model = [(AWEVideoPlayView * )view model];
                TSVVideoModel *videoModel = [model video];
                TSVMusicVideoURLModel *downloadAddr = [videoModel downloadAddr];
                NSArray *urlList = [downloadAddr urlList];
                if (urlList.count > 0) {
                    NSString *urlString = urlList[0];
                    url = [NSURL URLWithString:urlString];
                    break;
                }    
            }
        }
        if (url) 
		{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"清爽今日头条" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertVC addAction:cAction];

            UIAlertAction *dAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DownloaderManager *downloadManager = [DownloaderManager sharedDownloaderManager];
            downloadManager.delegate = self;
            [downloadManager downloadVideoWithURL:url];
        }];
        [alertVC addAction:dAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
}

%new
- (void)videoDownloadeProgress:(float)progress downloadTask:(NSURLSessionDownloadTask * _Nullable)downloadTask {
    if (!isShow)
    {
        hud = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = NSLocalizedString(@"下载中...", @"HUD loading title");
        NSProgress *progressObject = [NSProgress progressWithTotalUnitCount:100];
        hud.progressObject = progressObject;
        [hud.button setTitle:NSLocalizedString(@"取消", @"HUD cancel button title") forState:UIControlStateNormal];
        [hud.button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(self, @selector(ttDownloadTask),
                         downloadTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        isShow = YES;
    }
    hud.progressObject.completedUnitCount = [@(progress * 100)  intValue] ;
    hud.detailsLabel.text = [NSString stringWithFormat:@"%lld%%",hud.progressObject.completedUnitCount];
    if (hud.progressObject.fractionCompleted >= 1.f)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            hud = nil;
            isShow = NO;
        });
    }
}

%new
- (void)cancel 
{
    NSURLSessionDownloadTask *downloadTask = objc_getAssociatedObject(self, @selector(ttDownloadTask));
    [downloadTask cancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        hud = nil;
        isShow = NO;
    });
}

%new
- (void)videoDidFinishDownloaded:(NSString * _Nonnull)filePath {
    //保存到系统相册
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath)) 
	{
        UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}

%new
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) 
	{
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                               message:@"保存失败"
                               preferredStyle:UIAlertControllerStyleAlert];
 
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault
		handler:^(UIAlertAction * action) {}];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
        // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Save Failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // [alert show];
    }
    else 
	{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.square = YES;
        hud.label.text = NSLocalizedString(@"完成！", @"HUD done title");
        [hud hideAnimated:YES afterDelay:2.f];
    }
    //移除沙盒的缓存文件
    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
    
}

%end 



%hook TTProfileViewController

%new
- (int)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second
{
	NSArray *versions1 = [first componentsSeparatedByString:@"."];
	NSArray *versions2 = [second componentsSeparatedByString:@"."];
	NSMutableArray *ver1Array = [NSMutableArray arrayWithArray:versions1];
	NSMutableArray *ver2Array = [NSMutableArray arrayWithArray:versions2];
	// 确定最大数组
	NSInteger a = (ver1Array.count> ver2Array.count) ? ver1Array.count : ver2Array.count;
	// 补成相同位数数组
	if (ver1Array.count < a) {
		for(NSInteger j = ver1Array.count; j < a; j++)
		{
			[ver1Array addObject:@"0"];
		}
	}
	else
	{
		for(NSInteger j = ver2Array.count; j < a; j++)
		{
			[ver2Array addObject:@"0"];
		}
	}
		// 比较版本号
	int result = [self compareArray1:ver1Array andArray2:ver2Array];
	static int myres = -1;
	if(result == 1)
	{
		myres = 0; //v1大于v2
	}
	else if (result == -1)
	{
		myres = 1;//v1小于v2
	}
	else if (result == 0)
	{
		myres = 2;//v1等于v2
	}
	return myres;
}

%new
// 比较版本号
- (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2
{
	for (int i = 0; i< array2.count; i++) 
	{
		NSInteger a = [[array1 objectAtIndex:i] integerValue];
		NSInteger b = [[array2 objectAtIndex:i] integerValue];
		if (a > b) 
		{
			return 1;
		}
		else if (a < b)
		{
			return -1;
		}
	}
	return 0;
}
// //有几组
- (long long)numberOfSectionsInTableView:(UITableView *)tableView
{
	//[self reloadTableView];
	return %orig+1;
}
//每组有多少行
- (long long)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == [self numberOfSectionsInTableView:tableView] - 1)
		return 1;
	else
		return %orig;
}

// @interface TTProfilePublishBannerCell : UITableViewCell
// @end


//每行要显示的内容是什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] != [self numberOfSectionsInTableView:tableView] - 1)
		return %orig;

	else
	{
		static NSString *ID = @"qscell";
		NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
		NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

		if([self versionCompareFirst:appVersion andVersionSecond:@"7.9.0"] != 1)
		{
			TTProfilePublishBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
			if(!cell)
					cell = [[%c(TTProfilePublishBannerCell) alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
			[cell.publishBtn removeFromSuperview];
			[cell setPublishBtn:nil];
		
			cell.textLabel.text = @"清爽今日头条";
			if([appVersion isEqualToString:@"7.0.9"])
				cell.textLabel.font = [UIFont systemFontOfSize:16];
			else
			{
				cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
				// cell.textLabel.textColor = [UIColor colorWithRed:(193/255.0f) green:(193/255.0f)blue:(193/255.0f) alpha:1.0f];
			}
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			//[self tableView:tableView didSelectRowAtIndexPath:indexPath];
			return cell;
		}
		else
		{
			static NSString *ID = @"qscell";
			SSThemedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
			if(!cell)
					cell = [[%c(SSThemedTableViewCell) alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];

			UIView *tempView = [[UIView alloc] init];
			tempView.backgroundColor = [UIColor whiteColor];
			[cell setBackgroundView:tempView];
			cell.textLabel.text = @"清爽今日头条";
			if([appVersion isEqualToString:@"7.0.9"])
				cell.textLabel.font = [UIFont systemFontOfSize:16];
			else
				cell.textLabel.font = [UIFont boldSystemFontOfSize:16]; //新版头条的功能选项就是加粗的
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			return cell;
		}
	}
	//return %orig;
}
//点击cell的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(id)indexPath
{
	if ([indexPath section] != [self numberOfSectionsInTableView:tableView] - 1)
	{
		%orig;
		return;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//tableView.allowsSelection = NO;
	ViewController *vc = [[ViewController alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
}

- (double)tableView:(id)arg1 heightForRowAtIndexPath:(id)arg2
{
	if ([arg2 section] != [self numberOfSectionsInTableView:arg1] - 1)
		return %orig;
	
	return 44;
}

%end



// %hook TTVPalyerTrafficAlert
// //视频流量提醒
// - (bool)shouldShow
// {
// 	if(![QSOptions sharedConfig].indicator)
// 		return %orig;

// 	return NO;
// }

// %end


// %hook AWEVideoContainerViewController
// // //小视频流量提醒
// - (_Bool)needCellularAlert
// {
// 	if(![QSOptions sharedConfig].indicator)
// 		return %orig;

// 	return NO;
// }
// %end


// %hook AWEVideoContainerViewControllerNew
// // 7.9.0小视频流量提醒
// - (_Bool)needCellularAlert
// {
// 	if(![QSOptions sharedConfig].indicator)
// 		return %orig;

// 	return NO;
// }
// %end
// %hook TTIndicatorView
// //小视频流量提醒
// - (id)initWithIndicatorStyle:(long long)arg1 indicatorText:(id)arg2 indicatorImage:(id)arg3 
// 		maxLine:(long long)arg4 dismissHandler:(id)arg5
// {
// 	if(Indicator)
// 		if([arg2 isEqualToString:@"正在使用流量播放"])
// 			return nil;

// 	return %orig;	
// }


// %hook TTVFeedListVideoAdItem
// //西瓜视频页广告item
// - (double)cellHeightWithWidth:(long long)arg1
// {
//
// 	if(normalAd)
// 		return 0;
	
// 	return %orig;
// }
// %end

// %hook TTVFeedListVideoAdCell
// //西瓜视频页广告cell
// - (void)setItem:(id)arg1
// {
// 	if(normalAd)
// 		if([arg1 isKindOfClass:%c(TTVFeedListVideoAdItem)])
// 		{
// 			arg1 = nil;
// 			return;
// 		}	
// 	%orig;	
// }
// %end

// %hook TTVFeedListPicAdItem
// //西瓜视频页广告item
// - (double)cellHeightWithWidth:(long long)arg1
// {
//
// 	if(normalAd)
// 		return 0;
	
// 	return %orig;
// }
// %end

// %hook TTVFeedListPicAdCell
// - (void)setItem:(id)arg1
// {
// 	if(normalAd)
// 		if([arg1 isKindOfClass:%c(TTVFeedListPicAdItem)])
// 		{
// 			arg1 = nil;
// 			return;
// 		}
// 	%orig;	
// }
// %end
