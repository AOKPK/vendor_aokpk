# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

DATE = $(shell vendor/aokp/tools/getdate)
DEV = $(shell echo $(TARGET_PRODUCT) | cut -f2 -d '_')
#AOKP_BUILD = $(shell echo '1')

ifneq ($(AOKP_BUILD),)
	# AOKP_BUILD=<goo version int>/<build string>
	PRODUCT_PROPERTY_OVERRIDES += \
	    ro.goo.developerid=kecinzer \
	    ro.goo.rom=aokpk \
	    ro.goo.version=$(AOKP_BUILD) \
		ro.aokp.version=aokpk_$(DEV)_stable_$(AOKP_BUILD)
else
  DATETIME=$(shell date +"%y%m%d%H%M")
	PRODUCT_PROPERTY_OVERRIDES += \
      ro.goo.developerid=kecinzer \
      ro.goo.rom=aokpkdaily \
      ro.goo.version=$(DATETIME) \
      ro.aokp.version=aokpk_$(DEV)_daily_$(DATETIME)
endif

# Camera shutter sound property
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.camera-sound=1
