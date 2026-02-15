
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

@interface GodotYP : NSObject <UIApplicationDelegate>

@end

@implementation GodotYP


@end

YP *YP::get_singleton() {
	return instance;
}

void YP::_bind_methods() {
	//ClassDB::bind_method(D_METHOD("present", "mode"), &YP::present);

	ADD_SIGNAL(MethodInfo("rewarded_loaded"));
	//ADD_SIGNAL(MethodInfo("permission_updated", PropertyInfo(Variant::INT, "target"), PropertyInfo(Variant::INT, "status")));
}

YP::YP() {
	instance = this;

	godot_yp = [[GodotYP alloc] init];
}

YP::~YP() {
	instance = NULL;

	godot_yp = nil;
}
