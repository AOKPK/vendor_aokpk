# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

DATE = $(shell vendor/aokp/tools/getdate)
AOKP_BRANCH=jb-mr2

ifneq ($(AOKPK_STABLE),)
  PRODUCT_PROPERTY_OVERRIDES += \
    ro.goo.developerid=kecinzer \
    ro.goo.rom=aokpk \
    ro.goo.version=$(AOKPK_STABLE) \
    ro.aokp.version=aokpk_$(AOKP_PRODUCT)_$(AOKP_BRANCH)_stable_$(AOKPK_STABLE)
else
  DATETIME=$(shell date +"%y%m%d%H%M")
  PRODUCT_PROPERTY_OVERRIDES += \
    ro.goo.developerid=kecinzer \
    ro.goo.rom=aokpkdaily \
    ro.goo.version=$(DATETIME) \
    ro.aokp.version=aokpk_$(AOKP_PRODUCT)_$(AOKP_BRANCH)_daily_$(DATETIME)
endif

# needed for statistics
PRODUCT_PROPERTY_OVERRIDES += \
        ro.aokp.branch=$(AOKP_BRANCH) \
        ro.aokp.device=$(AOKP_PRODUCT)

# Camera shutter sound property
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.camera-sound=1
