# OLD: interception + caps2esc:
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

# keyd for modifying keyboard functions
- `https://github.com/rvaiya/keyd`
- conf file is `/etc/keyd/default.conf`
 

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


# Tilting the laptop enables airplane mode
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

# Pandoc
- needs perl modules that get install w/ `_ cpan install Pandoc::Elements`
- for 23.10 I also needed to install `IPC::Run3`
- However the test for these fail (I vaguely remember the fail to be a "false negative"?) so we need `_ cpan install -f Pandoc::Elements`
- also needs `_ pip3 install pandoc-secnos`

# stop screen from rotating when closing lid
- https://askubuntu.com/questions/1191182/screen-rotates-90-degrees-after-shutting-lid#1191269
- reinstall `iio-sensor-proxy`

# Fix lag when using ydotool
- Tag: mutter, libmutter
- https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/1858#note_818548
- For compiling mutter I had to add the `--dpkg-shlibdeps-params=--ignore-missing-info` to `dh_shlibdeps` in `debian/rules`
- test can be disabled by commeting out the paragraph in `debian/rules` after `override_dh_auto_test`
- fix crash on Gnome restart:
```diff
diff --git a/src/compositor/meta-compositor-x11.c b/src/compositor/meta-compositor-x11.c
index 1ad3327dd..ce7bc1945 100644
--- a/src/compositor/meta-compositor-x11.c
+++ b/src/compositor/meta-compositor-x11.c
@@ -188,6 +188,8 @@ meta_compositor_x11_manage (MetaCompositor  *compositor,
 
   compositor_x11->have_x11_sync_object = meta_sync_ring_init (xdisplay);
 
+  meta_x11_display_redirect_windows (x11_display, display);
+
   return TRUE;
 }
 
diff --git a/src/core/display.c b/src/core/display.c
index 0a191c0fb..787c15d60 100644
--- a/src/core/display.c
+++ b/src/core/display.c
@@ -1065,7 +1065,6 @@ meta_display_new (MetaContext  *context,
 #ifdef HAVE_X11_CLIENT
   if (display->x11_display)
     {
-      g_signal_emit (display, display_signals[X11_DISPLAY_OPENED], 0);
       meta_x11_display_restore_active_workspace (display->x11_display);
       meta_x11_display_create_guard_window (display->x11_display);
     }
```

# GSConnect
- binding keys: `https://github.com/GSConnect/gnome-shell-extension-gsconnect/issues/1215`

# Nemo
- make it default FM `xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search` (https://askubuntu.com/questions/1066752/how-to-set-nemo-as-the-default-file-manager-in-ubuntu/1173861#1173861)
- Edit shortcuts: `gsettings set org.gnome.desktop.interface can-change-accels true`
- use kitty: `gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty-tab`

# Tor upstart daemon
- https://askubuntu.com/questions/256911/how-to-prevent-tor-from-starting-automatically-on-ubuntu-server#266241
- adding `RUN_DAEMON="no"` to `/etc/default/tor` didn't seem to work
-  ran `systemctl disable tor.service`, `systemctl disable tor@default.service`

# cups upstart
- `sudo systemctl disable cups.service`
- `sudo systemctl enable cups.socket`
- `sudo systemctl enable cups-browsed.socket`

# Tuned
- disabled but keep installed (I'm not sure any of these settings would help?)

# git
- `git config --global diff.noprefix true`

# Gnome colortheme changes depending on Uhrzeit
- `~/bin/set_gtk_theme_by_timeofday`
- hourly cron job in crontab

# Mute when waking from sleep
- `/lib/systemd/system-sleep/mute`
