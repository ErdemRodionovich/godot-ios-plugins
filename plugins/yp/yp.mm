
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

YP *instance = NULL;
id yb_instance;

void callYBridge(NSString *methodName, id argument = nil){
	SEL selector = NSSelectorFromString(methodName);
	if (yb_instance && [yb_instance respondsToSelector:selector]) {
		if (argument) {
			[yb_instance performSelector:selector withObject:argument];
		} else {
			[yb_instance performSelector:selector];
		}
	} else {
		NSLog(@"YBridge instance does not respond to %@ selector", methodName);
	}
}

@interface GodotYP : NSObject
@end

@implementation GodotYP
- (instancetype)init {
    self = [super init];
    return self;
}

- (void) initialization_completed {
	if(instance){
		instance->emit_signal("initialization_completed");
	}
}

- (void) initialization_failed:(NSString *)error {
	if(instance){
		instance->emit_signal("initialization_failed", String(error.UTF8String));
	}
}

- (void) interstitial_loaded {
	if(instance){
		instance->emit_signal("interstitial_loaded");
	}
}

- (void) interstitial_failed_to_load:(NSString *)error {
	if(instance){
		instance->emit_signal("interstitial_failed_to_load", String(error.UTF8String));
	}
}

- (void) interstitial_showed {
	if(instance){
		instance->emit_signal("interstitial_showed");
	}
}

- (void) interstitial_failed_to_show:(NSString *)error {
	if(instance){
		instance->emit_signal("interstitial_failed_to_show", String(error.UTF8String));
	}
}

- (void) rewarded_loaded {
	if(instance){
		instance->emit_signal("rewarded_loaded");
	}
}

- (void) rewarded_failed_to_load:(NSString *)error {
	if(instance){
		instance->emit_signal("rewarded_failed_to_load", String(error.UTF8String));
	}
}

- (void) rewarded_showed {
	if(instance){
		instance->emit_signal("rewarded_showed");
	}
}

- (void) rewarded_failed_to_show:(NSString *)error {
	if(instance){
		instance->emit_signal("rewarded_failed_to_show", String(error.UTF8String));
	}
}

- (void)tracking_permission_result:(NSString *)result {
	NSLog(@"Tracking permission result: %@", result);
	if(instance){
		instance->initSDK_ifNot();
	}
}

@end

YP *YP::get_singleton() {
	return instance;
}

void YP::_bind_methods() {
	ClassDB::bind_method(D_METHOD("initialize"), &YP::initialize);
	ClassDB::bind_method(D_METHOD("load_rewarded", "adUnitID"), &YP::load_rewarded);
	ClassDB::bind_method(D_METHOD("show_rewarded"), &YP::show_rewarded);
	ClassDB::bind_method(D_METHOD("load_interstitial", "adUnitID"), &YP::load_interstitial);
	ClassDB::bind_method(D_METHOD("show_interstitial"), &YP::show_interstitial);

	ADD_SIGNAL(MethodInfo("initialization_completed"));
	ADD_SIGNAL(MethodInfo("initialization_failed", PropertyInfo(Variant::STRING, "error")));
	ADD_SIGNAL(MethodInfo("rewarded_loaded"));
	ADD_SIGNAL(MethodInfo("rewarded_failed_to_load", PropertyInfo(Variant::STRING, "error")));
	ADD_SIGNAL(MethodInfo("rewarded_showed"));
	ADD_SIGNAL(MethodInfo("rewarded_failed_to_show", PropertyInfo(Variant::STRING, "error")));
	ADD_SIGNAL(MethodInfo("interstitial_loaded"));
	ADD_SIGNAL(MethodInfo("interstitial_failed_to_load", PropertyInfo(Variant::STRING, "error")));
	ADD_SIGNAL(MethodInfo("interstitial_showed"));
	ADD_SIGNAL(MethodInfo("interstitial_failed_to_show", PropertyInfo(Variant::STRING, "error")));
}

YP::YP() {
	instance = this;
	Class cls = NSClassFromString(@"YBridge");
	if(cls){
		yb_instance = [[cls alloc] init];
	} else {
		NSLog(@"YBridge class not found. Make sure the YP plugin is properly integrated.");
	}
}

YP::~YP() {
	instance = NULL;
}

void YP::initialize(){
	NSLog(@"Initializing YP plugin");
	callYBridge(@"checkAndRequestTrackingPermission");
}

void YP::initSDK_ifNot(){
	if (!m_sdkInited) {
		NSLog(@"Initializing SDK");
		callYBridge(@"initSDK");
		m_sdkInited = true;
	}
}

void YP::load_rewarded(const String &ad_unit_id){
	initSDK_ifNot();
	NSString *adId = [[NSString alloc] initWithUTF8String:ad_unit_id.utf8().get_data()];
	NSLog(@"Loading rewarded ad with ID: %@", adId);
	callYBridge(@"loadRewarded:", adId);
}

void YP::show_rewarded(){
	initSDK_ifNot();
	NSLog(@"Showing rewarded ad");
	callYBridge(@"showRewarded");
}

void YP::load_interstitial(const String &ad_unit_id){
	initSDK_ifNot();
	NSString *adId = [[NSString alloc] initWithUTF8String:ad_unit_id.utf8().get_data()];
	NSLog(@"Loading interstitial ad with ID: %@", adId);
	callYBridge(@"loadInterstitial:", adId);
}

void YP::show_interstitial(){
	initSDK_ifNot();
	NSLog(@"Showing interstitial ad");
	callYBridge(@"showInterstitial");
}
