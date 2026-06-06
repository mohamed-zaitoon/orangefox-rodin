# OrangeFox Recovery device tree for Xiaomi POCO X7 Pro (rodin)

This tree is generated from the provided HyperOS firmware images for Xiaomi POCO X7 Pro, codename `rodin`.

## Firmware base

- Device: Xiaomi POCO X7 Pro
- Codename: `rodin`
- Model: `2412DPC0AG`
- SoC: MediaTek MT6899 / Dimensity 8400 Ultra
- Firmware: `OS3.0.10.0.WOJMIXM`
- Boot image OS properties: Android 16 / API 36
- Vendor recovery base: Android 15 / API 35
- Kernel: `6.6.89-android15-8-g8e4be6b47e40-ab14134548-4k`
- A/B: yes
- Dynamic partitions: yes
- Virtual A/B userspace snapshots: yes
- Filesystems: EROFS logical partitions, f2fs `/data`, f2fs `/metadata`

## Extracted partition facts

Values below are extracted from `MT6899_Android_scatter.txt`, `MT6899_Android_scatter.xml`, and `super.img`.

| Item | Value |
| --- | --- |
| `boot_a` / `boot_b` | `67108864` bytes |
| `vendor_boot_a` / `vendor_boot_b` | `67108864` bytes |
| `init_boot_a` / `init_boot_b` | `8388608` bytes |
| `dtbo_a` / `dtbo_b` | `8388608` bytes |
| `metadata` | `73891840` bytes |
| `super` | `11811160064` bytes |
| `userdata` scatter size | `12884901888` bytes |
| super metadata version | `10.2` |
| super metadata slots | `3` |
| super groups | `main_a`, `main_b` |
| block size | `4096` logical / `0x20000` scatter erase block |

Populated logical partitions in the supplied `super.img`:

| Partition | Size |
| --- | --- |
| `odm_a` | `868179968` |
| `odm_dlkm_a` | `348160` |
| `product_a` | `3539931136` |
| `system_a` | `955572224` |
| `system_dlkm_a` | `7299072` |
| `system_ext_a` | `984190976` |
| `vendor_a` | `1733914624` |
| `vendor_dlkm_a` | `19501056` |
| `mi_ext_a` | `948715520` |

The `_b` logical partitions exist in metadata but are zero-sized in the provided fastboot package.

## Image analysis summary

- `boot.img`: Android boot header v4, contains kernel only.
- `init_boot.img`: Android boot header v4, contains generic LZ4 ramdisk and `snapuserd`.
- `vendor_boot.img`: vendor boot header v4, contains platform vendor ramdisk, recovery vendor ramdisk, and a DT table.
- `dtbo.img`: Android DT table with one rodin overlay entry.
- `rescue.img`: sparse ext filesystem labeled `rescue`; stock fstab mounts it as `/cache`.
- `vbmeta.img`: chains `boot`, `vbmeta_system`, and `vbmeta_vendor`; includes descriptors for `dtbo`, `init_boot`, `vendor_boot`, and dynamic partitions.

## Important implementation choices

- Prebuilt kernel, DTB, DTBO, and recovery kernel modules are copied from the supplied firmware instead of invented.
- `recovery.fstab` keeps stock mount points and crypto flags.
- `/data` uses stock FBE metadata encryption:
  `fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized,keydirectory=/metadata/vold/metadata_encryption`
- USB controller is stock extracted value: `11201000.usb0`.
- EROFS is enabled because all populated logical partitions in `super.img` are EROFS.
- FastbootD is enabled because the device uses dynamic partitions and stock recovery ships a fastboot HAL service.

## Build

OrangeFox documentation recommends syncing sources with the official sync script. For Android 14+ launch devices, use the `14.1` branch unless you know your target source branch differs.

```bash
mkdir -p ~/OrangeFox_sync
cd ~/OrangeFox_sync
git clone https://gitlab.com/OrangeFox/sync.git
./sync/orangefox_sync.sh --branch 14.1 --path ~/fox_14.1

cd ~/fox_14.1
mkdir -p device/xiaomi
git clone <this-repo-url> device/xiaomi/rodin

export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE=rodin
export FOX_AB_DEVICE=1
export FOX_VIRTUAL_AB_DEVICE=1
export OF_FORCE_PREBUILT_KERNEL=1
export LC_ALL=C

source build/envsetup.sh
lunch twrp_rodin-ap2a-eng
mka -j1 adbd vendorbootimage
```

The device `vendorsetup.sh` defaults to a low-memory local build (`OF_BUILD_JOBS=1`,
`NINJA_HIGHMEM_NUM_JOBS=1`, Java heap capped at 1 GB, and stricter Go memory
limits). To use more parallelism, export `OF_BUILD_JOBS` before sourcing
`build/envsetup.sh`, or set `OF_LOW_MEMORY_BUILD=0` to disable these limits.

On machines with around 16 GB RAM, run the build from a normal terminal instead
of the VS Code integrated terminal. `systemd-oomd` can otherwise kill the whole
VS Code cgroup during Soong memory spikes.

```bash
cd ~/fox_14.1
./device/xiaomi/rodin/build-lowmem.sh
```

On a 16 GB RAM machine, add temporary swap before building:

```bash
sudo fallocate -l 16G /swap-build.img
sudo chmod 600 /swap-build.img
sudo mkswap /swap-build.img
sudo swapon /swap-build.img
```

If your OrangeFox branch does not support `vendorbootimage`, try:

```bash
mka -j1 adbd bootimage
```

## GitHub Actions

The workflow is in `.github/workflows/orangefox.yml`.

Use a self-hosted runner with at least 100 GB free disk space. OrangeFox documentation notes that the `14.1` source branch needs around 85 GB before build outputs and ccache.

## Validation commands needed on the real device

Run these on booted stock firmware or stock recovery before publishing builds:

```bash
adb shell ls -l /dev/block/by-name
adb shell getprop ro.boot.slot_suffix
adb shell getprop ro.crypto.state ro.crypto.type ro.hardware ro.boot.hardware
adb shell cat /proc/mounts
fastboot getvar current-slot
```

These confirm live by-name aliases, active slot behavior, and crypto state. Decryption is configured from stock fstab, but Android 16 HyperOS decryption must be validated on-device with recovery logs.

## Known limitations

- Display resolution and brightness limits were not set because they were not present in the supplied files.
- Flashlight is disabled because no recovery-safe flashlight node was verified.
- FBE metadata decryption is configured, not guaranteed. Real success depends on OrangeFox/TWRP crypto support for Android 16 HyperOS.
- `vendorbootimage` builds are branch-sensitive in OrangeFox. If your branch lacks the target, use the fallback in the build section.
