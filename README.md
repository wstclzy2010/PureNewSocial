# iOS今日头条专业版净化(基于专业版7.0.9开发)
* 不依赖preferenceloader，插件设置项集成在应用内部
* 移除置顶新闻
* 移除首页悬浮推广
* 移除视频、小视频的流量提醒
* 移除文章底部的相关圈子、相关搜索、相关文章
* 移除视频页相关视频、缩小分享区
* 移除首页直播推荐
* 隐藏顶部热搜文字
* 移除关注页面推荐关注
---
其实只是一个自用插件，作为学习iOS插件的制作在此记录下来。
许多人喜欢刷抖音，而我每天都离不开头条。有些内容是我不想看到的，那就自己动手丰衣足食。
我的目的就是去掉某一些界面的显示，所以大量的对initWithFrame这个初始化方法动手，去广告也是一样，找到形成该view的初始化方法，干掉它就不会显示了

---
![Alt text](https://github.com/wstclzy2010/PureNewSocial/blob/master/IMG_0373.PNG)
![Alt text](https://github.com/wstclzy2010/PureNewSocial/blob/master/IMG_0374.PNG)
