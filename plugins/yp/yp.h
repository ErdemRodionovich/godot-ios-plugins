#ifndef YP_H
#define YP_H

#include "core/version.h"

#if VERSION_MAJOR == 4
#include "core/io/image.h"
#include "core/object/object.h"
#else
#include "core/image.h"
#include "core/object.h"
#endif

#ifdef __OBJC__
@class GodotYP;
#else
typedef void GodotYP;
#endif

class YP : public Object {
	GDCLASS(YP, Object);

	static void _bind_methods();

	GodotYP *godot_yp;

public:

	static YP *get_singleton();


	YP();
	~YP();
};

#endif
