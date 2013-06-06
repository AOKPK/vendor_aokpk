# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

DATE = $(shell vendor/aokp/tools/getdate)
DEV = $(shell echo $(TARGET_PRODUCT) | cut -f2 -d '_')
#AOKPK_STABLE = $(shell echo '2')
AOKP_BRANCH=jb-mr1

ifneq ($(AOKPK_STABLE),)
  PRODUCT_PROPERTY_OVERRIDES += \
    ro.goo.developerid=kecinzer \
    ro.goo.rom=aokpk \
    ro.goo.version=$(AOKPK_STABLE) \
    ro.aokp.version=aokpk_$(DEV)_stable_$(AOKPK_STABLE)
else
  DATETIME=$(shell date +"%y%m%d%H%M")
  PRODUCT_PROPERTY_OVERRIDES += \
    ro.goo.developerid=kecinzer \
    ro.goo.rom=aokpkdaily \
    ro.goo.version=$(DATETIME) \
    ro.aokp.version=aokpk_$(DEV)_daily_$(DATETIME)
endif

# needed for statistics
PRODUCT_PROPERTY_OVERRIDES += \
        ro.aokp.branch=$(AOKP_BRANCH) \
        ro.aokp.device=$(AOKP_PRODUCT)

# Camera shutter sound property
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.camera-sound=1
