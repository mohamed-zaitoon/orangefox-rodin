DEVICE_PATH := device/xiaomi/rodin

PRODUCT_DEVICE := rodin
PRODUCT_BRAND := POCO
PRODUCT_MODEL := 2412DPC0AG
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_NAME := omni_rodin

PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_USE_VIRTUAL_AB := true
PRODUCT_VIRTUAL_AB_OTA := true
PRODUCT_VIRTUAL_AB_COMPRESSION := true

# OrangeFox 14.1 is Android 14 based and only exposes SystemSDK up to 34.
# The analyzed stock firmware remains Android 16; this value keeps the
# recovery build system compatible.
PRODUCT_SHIPPING_API_LEVEL := 34

PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.device=rodin \
    ro.product.model=2412DPC0AG \
    ro.product.vendor.marketname=POCO X7 Pro \
    ro.board.platform=mt6899 \
    ro.boot.dynamic_partitions=true \
    ro.build.ab_update=true \
    ro.virtual_ab.enabled=true \
    ro.virtual_ab.userspace.snapshots.enabled=true \
    ro.virtual_ab.compression.enabled=true \
    ro.virtual_ab.io_uring.enabled=true \
    ro.crypto.metadata_init_delete_all_keys.enabled=true \
    ro.crypto.volume.filenames_mode=aes-256-cts \
    ro.recovery.usb.vid=18D1 \
    ro.recovery.usb.adb.pid=D001 \
    ro.recovery.usb.fastboot.pid=4EE0

PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd \
    fsck.erofs \
    fsck.f2fs \
    lpdump \
    lpunpack \
    make_f2fs \
    snapuserd \
    snapuserd_ramdisk

PRODUCT_PACKAGES_DEBUG += \
    bootctl \
    logcat

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/init.recovery.hardware.rc:recovery/root/init.recovery.hardware.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.mt6899.rc:recovery/root/init.recovery.mt6899.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.project.rc:recovery/root/init.recovery.project.rc \
    $(DEVICE_PATH)/recovery/root/first_stage_ramdisk/fstab.emmc:recovery/root/first_stage_ramdisk/fstab.emmc \
    $(DEVICE_PATH)/recovery/root/first_stage_ramdisk/fstab.mt6899:recovery/root/first_stage_ramdisk/fstab.mt6899 \
    $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab:recovery/root/system/etc/recovery.fstab \
    $(DEVICE_PATH)/recovery/root/system/etc/init/android.hardware.fastboot-service.example_recovery.rc:recovery/root/system/etc/init/android.hardware.fastboot-service.example_recovery.rc

RODIN_RECOVERY_MODULES := $(wildcard $(DEVICE_PATH)/recovery/root/lib/modules/*)
PRODUCT_COPY_FILES += \
    $(foreach f,$(RODIN_RECOVERY_MODULES),$(f):recovery/root/lib/modules/$(notdir $(f)))
