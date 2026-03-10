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
	bool m_sdkInited = false;

public:

	static YP *get_singleton();

	void initialize();
	void initSDK_ifNot();
	void initMetrica(const String &api_key);
    
	void load_rewarded(const String &ad_unit_id);
    void show_rewarded();

	void load_interstitial(const String &ad_unit_id);
    void show_interstitial();

	void load_banner(const String &ad_unit_id, float width);
	void show_banner();

	YP();
	~YP();
};

#endif
