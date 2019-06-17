//
//  MJBIntroViewModel.h
//  MJBWeightTool
//
//  Created by 陈腾飞 on 2019/6/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJBIntroViewModel : NSObject

@property (nonatomic, assign) NSInteger advertisingPlace;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) NSInteger calRouteStrategy;
@property (nonatomic, assign) float BMIBs;
@property (nonatomic, copy) NSString *overtNumber;
@property (nonatomic, assign) float splashtime;
@property (nonatomic, assign) float r;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *truckNavigationSwitch;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger navId;
@property (nonatomic, assign) NSInteger t;
@property (nonatomic, assign) NSInteger isTruck;
@property (nonatomic, assign) float lastUpdateTime;
@property (nonatomic, assign) NSInteger visibleRouteStrategy;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger countDown;

@end

NS_ASSUME_NONNULL_END
