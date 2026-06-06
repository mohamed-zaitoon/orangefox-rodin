# Prebuilt firmware artifacts

These files are copied directly from the provided firmware images.

| File | Source | SHA-256 |
| --- | --- | --- |
| `kernel` | kernel payload extracted from `images/boot.img` | `a629445048e0518059f0241b99f48efa7b5ee6a86f48695fe1284c4437d9d588` |
| `dtb/mt6899-rodin.dtb` | entry 0 from the DT table inside `images/vendor_boot.img` | `696d85fb8eaa9c1c83c523a277f144645d1c9d61a87a6f6ab77084ba4dc835a6` |
| `dtbo.img` | direct copy of `images/dtbo.img` | `f0b6c9df8dfd69890cd3b91ac5ddc08efdd391ddf3c805ef0300debc03316fe8` |

Do not replace these with guessed kernel or DT files. If you update the firmware base, extract and hash the new artifacts again.
