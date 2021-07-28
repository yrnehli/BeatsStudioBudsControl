DEBUG = 0
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BeatsStudioBudsControl
$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "sbreload"