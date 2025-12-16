# pihask

A low-end containerized Kiosk for [HomeAssistant](https://www.home-assistant.io/) on Raspberry Pi
with any [HDMI/USB touchscreen](https://www.amazon.it/dp/B0B9M5SCG4?).


## Features

- Display the HomeAssistant dashboard on [Cog](https://github.com/Igalia/cog) with support for the GPU[^gpu].
- Optionally turn off the screen on idle timeout.
- Wake up on touch.
- Wake up optionally on MQTT notifications (i.e. objects detected by [Frigate](https://frigate.video/))
- Auto-login optionally when HA is configured with trusted networks:
  the kiosk has no need for credentials. \
  See [the relevant section](#ha-trusted-networks) for details.
- Fully containerized, though using privileged containers (probabily this could be easily refined)


## Requirements

- Raspberry Pi 3 Model B+ running Raspberry Pi OS (tested with Trixie/arm64)
- [Docker installed](https://docs.docker.com/engine/install/debian/)


## How to build and run

Copy `.env.example` into `.env` and adapt it to your needs, then run
```bash
docker compose -f compose.yml -f compose.dev.yml up --build
```
> [!TIP]
> So far there aren't official images, so you have to build them on your own.
> In case of interest I'll publish them, please let me know.


## Implementation details

This project basically produces two distinct images:
- *kiosk-display*: takes control of the display using Weston[^weston] to render the lightweight browser Cod (a WPE[^wpe] launcher)
- *kiosk-wakeup*: (optional) subscribes to an MQTT topic in order to wake up the screen on certain events (i.e. a person has been detected in the courtyard or at the door)


## HA trusted networks

I've set this in my HA config to avoid the login page and saving cookies

```configuration.yaml

homeassistant:
  ...
  auth_providers:
  - type: trusted_networks
    trusted_networks:
    - 192.168.1.xyz
    trusted_users:
      192.168.1.xyz: 4c2b....
    allow_bypass_login: True
  - type: homeassistant

```

## Customizing Weston

Please note most of the graphical environment are controlled by [weston.ini](weston.ini).
The defaults can be easily overridden mounting a custmized copy at `/etc/xdg/weston/weston.ini`

## Raspberry boot config

This is the boot config I'm currently using, cdrtainly not optimized.
Probably most of it doesn't impact on this project features:
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

[^wpe]: WPE is a WebKit port for embedded and low-consumption computer devices, see [wpewebkit.org](https://wpewebkit.org/)
[^weston]: [Weston](https://wayland.pages.freedesktop.org/weston/) is the Wayland reference implementation
[^gpu]: [Videocore](https://en.wikipedia.org/wiki/VideoCore) is the low-power mobile multimedia processor on Raspberry Pi 
