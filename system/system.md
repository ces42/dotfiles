Unfortunately I accidentally deleted this file...
Content that I remember being here
 - 32 bit libraries that were required for Civ V (cracked... Or maybe wine?)
 - 

# caps-lock and escape:
 - caps2esc??
`/etc/systemd/system/udevmon.service:`
```
[Unit]
Description=udevmon
;Wants=systemd-udev-settle.service
;After=systemd-udev-settle.service

[Service]
ExecStart=/usr/bin/nice -n -20 /usr/local/bin/udevmon -c /etc/udevmon.yaml

[Install]
WantedBy=multi-user.target
```

`/etc/udevmon.yaml`
```
- JOB: "intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE"
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
```

- In 22.04 this requires installing libyaml v0.6 manually, e.g. from [here](http://ftp.de.debian.org/debian/pool/main/y/yaml-cpp/libyaml-cpp0.6_0.6.3-9_amd64.deb)
 

# ydotool
- `_ systemctl enable /usr/lib/systemd/user/ydotool.service`
`/usr/lib/systemd/user/ydotool.service`
```
[Unit]
Description=Starts ydotoold service

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/ydotoold --socket-perm=666
ExecReload=/usr/bin/kill -HUP $MAINPID
KillMode=process
TimeoutSec=180

[Install]
WantedBy=default.target
```


# Tilting the laptop enable airplane mode
- Before 22.04 [this](https://askubuntu.com/questions/965595/why-does-airplane-mode-keep-toggling-on-my-hp-laptop-in-ubuntu-18-04/965596#965596) was a fix
- Now the culprit seems to be the device at `/sys/devices/platform/INT33D5:00` bzw `/dev/input/event21`
- `modprobe -r intel_hid` fixes this behavior (although the system now is oblivious to being in table mode)
- the fix from askubuntu is still necessary to prevent toggling of airplane mode after resuming from closing the lid
- make permanent with `echo 'blacklist intel_hid' > /etc/modprobe.d/blacklist-intel_hid.conf`

# xsuspender
- config in `.config/xsuspender.conf`
- currently (2. 8. 22) suspending Discord after 120 seconds of being unfocused
- manually compiled to fix [this issue](https://github.com/kernc/xsuspender/issues/38) (hardcode subdirectory to look in)
- currently (2. 8. 22) not in autostart
