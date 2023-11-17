- check `/etc/systemd/logind.conf`. Might need to reconfigure lid and power button events

# Bugs
- Find why system-monitor is logging so many things related to dateMenu.js

# PRs
- `:Lazy`: add lazy install dir to path

# Ideas
- rewrite fpickd in dash
- fpickd image preview: https://github.com/sergei-grechanik/st/tree/graphics
- ~~shortcut to turn selected text into formatted paper title~~
	* wrapper for Evince (make it the default PDF opener for FF) which looks up paper name (eg from arXiv) number and moves PDF

# perf
- synchronize timeouts in system-monitor's events for different elements (maybe maintain a list of all existing timeouts and merge two events if they have the same interval?)

# fn-keys
- [acpid2](https://wiki.archlinux.org/title/Acpid) might be able to map the "settings" key `fn+f12`. cf `acpi_listen`


# vim-math ideas
- summand textobject (delims: +, -, \oplus, etc)
- equation part textobject (delims: =, \to, \equiv, \cong, etc)
- toggle \sin(a) <-> (\sin a)
         R_q (F) <-> (R_q F)

# TOOLS
- `dbus-send --print-reply --dest=org.gnome.Mutter.IdleMonitor /org/gnome/Mutter/IdleMonitor/Core org.gnome.Mutter.IdleMonitor.GetIdletime` to get idle time
