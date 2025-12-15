# pihask

A low-end Kiosk for HomeAssistant on Raspberry Pi 3 with an [HDMI/USB touchscreen](https://www.amazon.it/dp/B0B9M5SCG4?).

## Requirements

- Raspberry Pi 3 running Raspberry Pi OS
- [Docker installed](https://docs.docker.com/engine/install/debian/)


## How to build and run

Copy `.env.example` into `.env` and adapt it to your needs, then run
```bash
docker compose -f compose.yml -f compose.dev.yml up --build
```

## Raspberry boot config

This is the boot config I'm currently using, probably most of it doesn't impact on this project features:
```bash
$ cat /boot/firmware/cmdline.txt 
console=serial0,115200 console=tty1 root=PARTUUID=197e9b42-02 rootfstype=ext4 fsck.repair=yes rootwait cfg80211.ieee80211_regdom=IT ipv6.disable=1 video=HDMI-A-1:1920x1080@60,rotate=180

$ cat /boot/firmware/config.txt 
dtparam=audio=on
camera_auto_detect=1
display_auto_detect=1
auto_initramfs=1
dtoverlay=vc4-kms-v3d
max_framebuffers=2
gpu_mem=128
hdmi_enable_4kp60=1
hdmi_blanking=1
rotate=180
disable_fw_kms_setup=1
arm_64bit=1
disable_overscan=1
arm_boost=1

[cm4]
otg_mode=1

[cm5]
dtoverlay=dwc2,dr_mode=host

[all]
```
