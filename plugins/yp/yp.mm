
#include "yp.h"

#import <Foundation/Foundation.h>

#if VERSION_MAJOR == 4
#if VERSION_MINOR >= 6
#import "drivers/apple_embedded/godot_app_delegate.h"
#import "drivers/apple_embedded/godot_view_controller.h"
#elif VERSION_MINOR >= 5
#import "drivers/apple_embedded/godot_app_delegate.h"
#import "drivers/apple_embedded/view_controller.h"
#else
#import "platform/ios/app_delegate.h"
#import "platform/ios/view_controller.h"
#endif
#else
#import "platform/iphone/app_delegate.h"
#import "platform/iphone/view_controller.h"
#endif

#import <YandexMobileAds/YandexMobileAds.h>

YP *instance = NULL;

// @interface GodotYP : NSObject <UIApplicationDelegate>
// @end
// @implementation GodotYP
// @end

// Internal Objective-C class to handle Yandex callbacks
@interface GodotYP : NSObject <YMAInterstitialAdLoaderDelegate, YMAInterstitialAdDelegate>
@property (nonatomic, strong) YMAInterstitialAdLoader *interstitialAdLoader;
@property (nonatomic, strong) YMAInterstitialAd *interstitialAd;
@end

@implementation GodotYP
- (instancetype)init {
    self = [super init];
    if (self) {
        _interstitialAdLoader = [[YMAInterstitialAdLoader alloc] init];
        _interstitialAdLoader.delegate = self;
    }
    return self;
}

// Delegate methods
- (void)interstitialAdLoader:(YMAInterstitialAdLoader *)adLoader didLoad:(YMAInterstitialAd *)interstitialAd {
    self.interstitialAd = interstitialAd;
    self.interstitialAd.delegate = self;
	if(instance != NULL){
    	instance->emit_signal("interstitial_loaded");
	}
}

- (void)interstitialAdLoader:(YMAInterstitialAdLoader *)adLoader didFailToLoadWithError:(YMAAdRequestError *)error {
    if(instance != NULL){
		instance->emit_signal("interstitial_failed_to_load", String(error.error.localizedDescription.UTF8String));
	}
}
@end

YP *YP::get_singleton() {
	return instance;
}

void YP::_bind_methods() {
	ClassDB::bind_method(D_METHOD("load_rewarded", "adUnitID"), &YP::load_rewarded);
	ClassDB::bind_method(D_METHOD("show_rewarded"), &YP::show_rewarded);
	ClassDB::bind_method(D_METHOD("load_interstitial", "adUnitID"), &YP::load_interstitial);
	ClassDB::bind_method(D_METHOD("show_interstitial"), &YP::show_interstitial);

	ADD_SIGNAL(MethodInfo("rewarded_loaded"));
	ADD_SIGNAL(MethodInfo("rewarded_showed"));
	ADD_SIGNAL(MethodInfo("rewarded_failed_to_load", PropertyInfo(Variant::STRING, "error")));
	ADD_SIGNAL(MethodInfo("interstitial_loaded"));
	ADD_SIGNAL(MethodInfo("interstitial_showed"));
	ADD_SIGNAL(MethodInfo("interstitial_failed_to_load", PropertyInfo(Variant::STRING, "error")));
}

YP::YP() {
	instance = this;
	[YMAMobileAds initializeSDKWithCompletionHandler:nil];
	godot_yp = [[GodotYP alloc] init];
}

YP::~YP() {
	instance = NULL;
	godot_yp = nil;
}

void YP::load_rewarded(const String &ad_unit_id){

}

void YP::show_rewarded(){

}

void YP::load_interstitial(const String &ad_unit_id){
	NSString *id = [[NSString alloc] initWithUTF8String:ad_unit_id.utf8().get_data()];
	YMAAdRequestConfiguration *config = [[YMAAdRequestConfiguration alloc] initWithAdUnitID:id];
	//[config initWithAdUnitID:id];
	[godot_yp.interstitialAdLoader loadAdWithRequestConfiguration:config];
}

void YP::show_interstitial(){
	if(godot_yp.interstitialAd){
		UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
		[godot_yp.interstitialAd showFromViewController:root];
	}
}
