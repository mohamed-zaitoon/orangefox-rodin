$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, vendor/twrp/config/common.mk)
$(call inherit-product, device/xiaomi/rodin/device.mk)

PRODUCT_DEVICE := rodin
PRODUCT_NAME := omni_rodin
PRODUCT_BRAND := POCO
PRODUCT_MODEL := 2412DPC0AG
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_RELEASE_NAME := POCO X7 Pro

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

BUILD_FINGERPRINT := Xiaomi/rodin/missi:16/BP2A.250605.031.A3/OS3.0.10.0.WOJMIXM:user/release-keys
PRIVATE_BUILD_DESC := rodin-user 16 BP2A.250605.031.A3 OS3.0.10.0.WOJMIXM release-keys

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=rodin \
    PRODUCT_NAME=rodin_global \
    PRIVATE_BUILD_DESC="$(PRIVATE_BUILD_DESC)"
