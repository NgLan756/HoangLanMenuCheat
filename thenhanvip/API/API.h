#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <zlib.h>
#import <BackgroundTasks/BackgroundTasks.h>
#import <Accelerate/Accelerate.h>

@interface API : NSObject <CLLocationManagerDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) UIImage *notificationImage;
@property (nonatomic, strong) UIAlertController *alertCtrl;
@property (nonatomic) NSInteger countdownSeconds;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, strong) NSString *udid;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *deviceModel;
@property (nonatomic, strong) NSString *expiryDate;

+ (instancetype)sharedClient;

- (void)startLoading;
- (void)setToken:(NSString *)token;
- (NSString *)getToken;
- (void)loadResourcesWithCompletion:(void(^)(BOOL success))completion;
- (NSString *)getUDID;
- (NSString *)getKey;
- (NSString *)getDeviceModel;
- (NSString *)getExpiryDate;
- (void) paid:(void (^)(void))execute;
- (void) logoutAndReauthenticate;
@end
