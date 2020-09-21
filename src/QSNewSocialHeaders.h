//
//  QSNewSocialHeaders.h
//  PureNewSocial
//
//  Created by 排骨 on 2020/9/17.
//  Copyright © 2020 排骨. All rights reserved.
//
@interface TTTopBarSearchGuideView : UIView
@end

@interface TTCollapsingTopBar
- (void)removeTopBarLOTAnimationViewIfNeeded;
@end

@interface ExploreOrderedData 
@property(retain, nonatomic) NSString *stickLabel;
@property(retain, nonatomic) NSString *adIDStr;
@property(nonatomic) unsigned long long cellType;
@end

//@class TTVRelatedItem;

@interface TTVRelatedItem : NSArray
@property(retain, nonatomic) NSString *card_type;
@end

@interface TTProfileViewController : UIViewController <UITableViewDataSource>
- (void)reloadTableView;
- (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2;
- (int)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second;
@end

@interface SettingView :UIViewController <UITableViewDataSource>
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