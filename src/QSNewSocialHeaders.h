//
//  QSNewSocialHeaders.h
//  PureNewSocial
//
//  Created by 排骨 on 2020/9/17.
//  Copyright © 2020 排骨. All rights reserved.
//
#import "DownloaderManager.h"
#import "MBProgressHUD.h"


@interface TTTopBar : UIView
@property(retain, nonatomic) UIView *searchLabelContainer;
@end

@interface TTTopBarSearchGuideView : UIView
@end

@interface TTCollapsingTopBar
- (void)removeTopBarLOTAnimationViewIfNeeded;
@end

@interface ExploreOrderedData
@property (retain, nonatomic) NSString *label; 
@property(retain, nonatomic) NSString *stickLabel;
@property(retain, nonatomic) NSString *adIDStr;
@property(nonatomic) unsigned long long cellType;
@end

//@class TTVRelatedItem;

@interface TTVRelatedItem : NSArray
@property(retain, nonatomic) NSString *card_type;
@end

@interface TTVDetailRelatedVideoItem
@property(nonatomic) _Bool showDislike;
@end

@interface TTProfileViewController : UIViewController <UITableViewDataSource>
- (void)reloadTableView;
- (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2;
- (int)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second;
@end

@interface SettingView :UIView
+ (double) fontSizeOfCellLeftLabel; 
@end

@interface UIColor (DarkMode)
+ (id)ttColorWithName:(NSString *)arg1;
@end

@interface TTProfilePublishBannerCell : UITableViewCell
@property(retain, nonatomic) UIButton *publishBtn; 
@end

@class TTProfilePublishBannerCell;



@interface BDNovelFreeAdHandler
@property(nonatomic) _Bool lastGetFreeInAddIsFree;
@property(nonatomic) long long currentBeginFreeAdTime;
@property(nonatomic) long long limitAdFreeTime; 
@end

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

@interface TTVideoEngine
@property(retain, nonatomic) UIView *playerView;

@end

@interface TTVPlayerControlView : UIAlertController <DownloaderManagerDelegeate>
@property(nonatomic, readonly) UIResponder *nextResponder;

@end

@interface TTVDemandPlayer
@end

@interface TTVVideoPlayerView 
@end

@interface TSVNewControlOverlayViewController : UIViewController <DownloaderManagerDelegeate>
@end

@interface TSVMusicVideoURLModel : NSObject
@property(nonatomic, readonly) NSArray *urlList;
@end

@interface TSVVideoModel : NSObject
@property(nonatomic, readonly) TSVMusicVideoURLModel *downloadAddr;
@end

@interface TTShortVideoModel : NSObject
@property(nonatomic, readonly) TSVVideoModel *video;
@end

@interface AWEVideoPlayView : UIView
@property(nonatomic, readonly) TTShortVideoModel *model;
@end



@interface TTSettingSwitch : UISwitch
- (void)setOn:(BOOL)arg1 animated:(BOOL)arg2;
@end

@interface SSThemedLabel : UILabel
@property(copy, nonatomic) NSString *backgroundColorThemeKey;
@property(copy, nonatomic) NSString *textColorThemeKey; 
@end

@interface SSThemedTableView : UITableView
@property(nonatomic) _Bool enableTTStyledSeparator;
@property(copy, nonatomic) NSString *backgroundColorThemeKey;
@end

@interface SSThemedTableViewCell : UITableViewCell
@property(nonatomic) _Bool separatorAtBottom;
@property(nonatomic) _Bool separatorAtTOP;
@end

@interface SettingDetailTextCell : SSThemedTableViewCell
@property(retain, nonatomic) SSThemedLabel *tt_DetailLabel;
@property(retain, nonatomic) SSThemedLabel *tt_titleLabel;
@end

@interface SSNavigationBar : UIBarButtonItem
+ (id) navigationBackButtonWithTarget:(id)arg1 action:(SEL)arg2;
+ (id) navigationTitleViewWithTitle:(id)arg1;
@end

@interface SSThemedView : UIView
@end