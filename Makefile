INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = __________airresist

__________airresist_FILES = Tweak.x
__________airresist_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

ARCHS = armv7 arm64 arm64e