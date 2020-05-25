include $(THEOS)/makefiles/common.mk

TOOL_NAME = airresist

airresist_FILES = main.m
airresist_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tool.mk
