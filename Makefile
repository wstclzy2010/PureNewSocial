ARCHS = arm64 arm64e
TARGET = iphone:10.3

DEBUG = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = toutiaohook

toutiaohook_FILES = Tweak.xm
# toutiaohook_CFLAGS = -fobjc-arc
toutiaohookU_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += toutiaopref
include $(THEOS_MAKE_PATH)/aggregate.mk
