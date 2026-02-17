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

class YP : public Object {
	GDCLASS(YP, Object);

	static void _bind_methods();

public:

	static YP *get_singleton();

	void initialize();
    
	void load_rewarded(const String &ad_unit_id);
    void show_rewarded();

	void load_interstitial(const String &ad_unit_id);
    void show_interstitial();

	YP();
	~YP();
};

#endif
