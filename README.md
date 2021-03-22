# iOS今日头条专业版净化(始于专业版7.0.9)
## 特性


* 不依赖preferenceloader，插件设置项集成在应用内部
* 移除置顶新闻
* 移除首页悬浮推广
* 移除视频、小视频的流量提醒
* 移除文章底部的相关圈子、相关搜索、相关文章
* 移除视频页相关视频、缩小分享区
* 移除首页直播推荐
* 隐藏顶部热搜文字
* 移除关注页面推荐关注


其实只是一个自用插件，作为学习iOS插件的制作在此记录下来。
许多人喜欢刷抖音，而我每天都离不开头条。有些内容是我不想看到的，那就自己动手丰衣足食。
我的目的就是去掉某一些界面的显示，所以大量的对initWithFrame这个初始化方法和头条喜欢用的heightForData方法动手，去广告也是一样，找到形成该view的初始化方法，干掉它就不会显示了

## 截图预览

![Alt text](https://github.com/wstclzy2010/PureNewSocial/blob/developer/screenshot/IMG_0380(20210302-182616).JPEG)

## 设置项集成至应用内

这个步骤其实没有什么特别值得说的，因为这完全就是正向的内容，我相信只要学过OC和iOS的开发的，对他们来说都是非常熟悉且简单的东西。我是没有学过iOS开发甚至是OC语言的，那么当我有这个需求的时候，我做了些什么呢？
* 研究了半天，噢要在tableview上做文章，之后打开bilibili，搜索iOS开发，强行逼自己看了一天的tableview教程视频。
* 有了最最最基本的知识后，还差点东西，因为让你用xcode做一个tableview界面出来，简单啊，拖个tableview出来，就那几个方法，写一写就好了。但这里是逆向，是改别人的界面，你拿什么拖？hook哪个类？什么方法？

那么根据tableview的基本写法，要确定的有如下几个基本方法：
* 有几组``` - (long long)numberOfSectionsInTableView:(UITableView *)tableView ```
* 每组有多少行``` - (long long)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section ```
* 每行要显示的内容是什么``` - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath ```
* cell的点击事件``` - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(id)indexPath ```

上面这几个是一般是必须要hook的方法，那么还剩下一个问题，hook哪个类？
这个问题比较容易，因为正向开发者们会在什么类里面编写上面这四个方法？

* 当然是遵守UITableViewDataSource协议的类里面

这就可以通过lookin工具，在界面的tableview中打开控制台，输入dataSource，查看其数据源在哪个类中即可

在今日头条7.0.9版本中，”我的“界面的数据源类为TTProfileViewController

那么代码为
```
NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

%hook TTProfileViewController
//有几组
- (long long)numberOfSectionsInTableView:(UITableView *)tableView
{
	
	if([appVersion isEqualToString:@"7.0.9"])
		return %orig+1;        //首先%orig表示返回值，及long long类型的数量，在原来的数量上增加一组
	
	else
		return %orig;
}
//每组有多少行
- (long long)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if([appVersion isEqualToString:@"7.0.9"])
	{
		if(section == [self numberOfSectionsInTableView:tableView] - 1)  //假设有10，那么第10组的组号就是9
			return 1;
		else
			return %orig;
	}

	return %orig;	
}
//每行要显示的内容是什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([appVersion isEqualToString:@"7.0.9"])
	{
		if ([indexPath section] != [self numberOfSectionsInTableView:tableView] - 1)
			return %orig;
	
		else
		{
			UITableViewCell *cell = %orig;  
			/* 不要根据正向开发的写法重新创建cell，没必要而且可能会崩溃，直接%orig获取到它创建好的cell即可：
			
			static NSString *ID = @"cell";
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if(!cell)
                               cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
			
			
			*/

			cell.textLabel.text = @"清爽今日头条";
			cell.textLabel.font = [UIFont systemFontOfSize:16];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //cell右侧有个指示箭头，表示可以点击进入另一个viewcontroller
		
			return cell;
		}
	}

	else
		return %orig;
}
//点击cell的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(id)indexPath
{
	if([appVersion isEqualToString:@"7.0.9"])
	{
		if ([indexPath section] != [self numberOfSectionsInTableView:tableView] - 1)
		{
			%orig;
			return;
		}
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];

		if ([indexPath row] == 0)
		{
			ViewController *vc = [[ViewController alloc] init];  //我自己用xcode写了一个ViewController，点击的时候进入这个页面
			[self.navigationController pushViewController:vc animated:YES];
		}
	}
	
	else
		return %orig;
}

%end
```

那么ViewController需要什么内容呢？首先它必须遵守<UITableViewDataSource,UITableViewDelegate>协议，它自己作为代理，自己作为数据源，要以纯代码的方式画一个tableview，否则进入是黑屏
```
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"清爽今日头条";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backclick)];
    self.navigationItem.leftBarButtonItem = item;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)               style:UITableViewStyleGrouped];

    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)backclick
{
    [self.navigationController popViewControllerAnimated:YES];
}
```

剩下的就是tableview一些必备方法了，就不再重复说了，你平时怎么写tableviewCell的现在也怎么写

## 退出应用

因为我太菜，没有实现热开关，那么我采取的还是增加一个关闭应用的开关让用户关掉应用后重新进入才能生效。这里调用exit(0)会有一种崩溃的视觉效果，这是不好的，所以可以在调用退出前增加一个动画
```
- (void)exitApplication 
{
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight  forView:self.view.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}
```

## 接收开关的bool值

前面的开关我是保存在NSUserDefaults中的
```
#define QSDefaults [NSUserDefaults standardUserDefaults]

UISwitch *switchView = [[UISwitch alloc] init];
switchView.on = [QSDefaults boolForKey:@"Indicator"];
[switchView addTarget:self action:@selector(qs_Indicator:) forControlEvents:UIControlEventValueChanged];
cell.accessoryView = switchView;

- (void)qs_Indicator:(UISwitch *)switchView
{
    [QSDefaults setBool:switchView.isOn forKey:@"Indicator"];
    [QSDefaults synchronize];
}
```
问题转变到，如何接收存储在standardUserDefaults的开关值，和普通的利用preferenceloader依赖写到设置中一样，我这里采取：
```
static BOOL Indicator;

static void loadPrefs()
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	NSUserDefaults *QSSetting = [NSUserDefaults standardUserDefaults];
	Indicator = [[QSSetting objectForKey:@"Indicator"] boolValue];
	..........
	..........
}

%ctor
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
 	loadPrefs();
	[pool release];
}
```
就是在启动应用的时候，读取开关的值
