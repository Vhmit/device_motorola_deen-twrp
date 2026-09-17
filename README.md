TWRP Device Tree for Motorola One (Deen)
===========================================

The Motorola Motorola One (codenamed _"deen"_) is a mid-range smartphone from Motorola mobility.
It was announced on August 2018.

Basic   | Spec Sheet
-------:|:-------------------------
CPU     | Octa-core 2.0 GHz Cortex-A53
Chipset | Qualcomm MSM8953-PRO Snapdragon 625
GPU     | Adreno 506
Memory  | 4 GB RAM
Shipped Android Version | 8.1.0
Storage | 64 GB
MicroSD | Up to 256 GB
Battery | Li-Ion 3000mAh battery
Display | 720 x 1520 pixels, 5.9 inches (~287 ppi pixel density)
Camera  | 13 MP, 2160 pixels, panorama,depth sensor, PDAF ,flash LED

![Motorola One](https://files.tecnoblog.net/wp-content/uploads/2025/01/motorola-one-branco.png "Motorola One")

### Kernel Source

https://github.com/jro1979oliver/kernel_motorola_deen/tree/android-9.0

## Compile

First repo init the twrp-9 omni: 

```
mkdir ~/android/twrp-9
cd ~/android/twrp-9
repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-9.0
```

Then add to a local manifest (if you don't have .repo/local_manifest then make that directory and make a blank file and name it something like twrp.xml):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="osm0sis/twrp_abtemplate" path="bootable/recovery/installer" remote="github" revision="master"/>
  <project name="device_motorola_deen-twrp" path="device/motorola/deen" remote="Vhmit" revision="android-9.0"/>
</manifest>
```

Now you can sync your source:

```
repo sync
```

To automatically make the TWRP installer zip, you need to import this commit in the build/make path: https://gerrit.twrp.me/c/android_build/+/5037

Or, if you do not want to generate recovery-installer.zip:
- rm -rf bootable/recovery/installer, 
- ignore this TWRP patch,
- Revert this [commit](https://github.com/Vhmit/device_motorola_deen-twrp/commit/060ee0040caa568a5d65d44342e38a3a4f60a055).

Finally execute these:

```
. build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch omni_deen-eng
mka bootimage
```
