//
//  WCHLOptions.h
//  WCSettingUI
//
//  Created by 排骨 on 2020/8/4.
//  Copyright © 2020 排骨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSOptions : NSObject

+ (instancetype)sharedConfig;

@property (assign, nonatomic) BOOL indicator;
@property (assign, nonatomic) BOOL topnews;
@property (assign, nonatomic) BOOL relateRead;
@property (assign, nonatomic) BOOL paidCircle;
@property (assign, nonatomic) BOOL relatedVideo;
@property (assign, nonatomic) BOOL shareView;
@property (assign, nonatomic) BOOL articleURL;
@property (assign, nonatomic) BOOL hotBoard;
@property (assign, nonatomic) BOOL recommendUser;
@property (assign, nonatomic) BOOL hotsearch;
@property (assign, nonatomic) BOOL topBarLOT;
@property (assign, nonatomic) BOOL normalAd;
@property (assign, nonatomic) BOOL xigualive;
@property (assign, nonatomic) BOOL miniApp;
@property (assign, nonatomic) BOOL videoDownload;
@property (assign, nonatomic) BOOL questionsAndAnswers;
@property (assign, nonatomic) BOOL column;
@property (assign, nonatomic) BOOL autoOnComment;

@end

NS_ASSUME_NONNULL_END
