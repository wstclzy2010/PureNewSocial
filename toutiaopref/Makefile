ARCHS = arm64 arm64e
TARGET = iphone:10.3
	
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = toutiaopref

toutiaopref_FILES = PaiguRootListController.m
toutiaopref_INSTALL_PATH = /Library/PreferenceBundles
toutiaopref_FRAMEWORKS = UIKit
toutiaopref_PRIVATE_FRAMEWORKS = Preferences
toutiaopref_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/toutiaopref.plist$(ECHO_END)
