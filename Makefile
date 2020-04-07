ARCHS = arm64 arm64e
TARGET = iphone:latest:13.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = toutiaohook

toutiaohook_FILES = Tweak.x
# toutiaohook_CFLAGS = -fobjc-arc
toutiaohookU_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
