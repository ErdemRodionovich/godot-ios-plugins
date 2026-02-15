
#include "yp_module.h"

#include "core/version.h"

#if VERSION_MAJOR == 4
#include "core/config/engine.h"
#else
#include "core/engine.h"
#endif

#include "core/version.h"

#include "yp.h"

YP *yp;

void godot_yp_init() {
	yp = memnew(YP);
	Engine::get_singleton()->add_singleton(Engine::Singleton("YP", yp));
}

void godot_yp_deinit() {
	if (yp) {
		memdelete(yp);
	}
}