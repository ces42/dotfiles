Unfortunately I accidentally deleted this file...
Content that I remember being here
 - How I remapped caps lock and escape (caps2esc? but there's also a .service file involved somewhere I think)
 - 32 bit libraries that were required for Civ V (cracked... Or maybe wine?)

# caps-lock and escape:
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
