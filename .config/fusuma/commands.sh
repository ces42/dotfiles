#!/bin/sh
# look at /usr/include/linux/input-event-codes.h to find keycodes for ydotool
# ctrl = 29, shift = 42, alt = 56, super=125

# reads: none
# sets: old_win, active_win_id, active_win_class
switch_to_cursor_win() {
	_get_cursor_win
	echo "switch to: old_win=$old_win"
	echo "switch to: active_win_id=$active_win_id"
	echo ''
	_do_focusing
}

rm /run/user/1000/fusuma_old_win && mkfifo /run/user/1000/fusuma_old_win
rm /run/user/1000/fusuma_active_win_id && mkfifo /run/user/1000/fusuma_active_win_id
rm /run/user/1000/fusuma_active_win_class && mkfifo /run/user/1000/fusuma_active_win_class

_get_cursor_win_fast() { # WIP
	# currently not working correctly (9.5.23)
	# doesn't handle guake
	xdotool getactivewindow > /run/user/1000/fusuma_active_win_id &
	xdotool getmouselocation --shell | sed -n 's/WI....=\(.*\)/\1/p' > /run/user/1000/fusuma_old_win &
	# active_win_id=$(cat /run/user/1000/fusuma_active_win_id)
	# active_win_class=$(cat /run/user/1000/fusuma_active_win_class)
	# old_win=$(cat /run/user/1000/fusuma_old_win)
	read active_win_id < /run/user/1000/fusuma_active_win_id
	# read active_win_class < /run/user/1000/fusuma_active_win_class
	read old_win < /run/user/1000/fusuma_old_win
	active_win_class=$(xprop -id $active_win_id WM_CLASS | cut -d \" -f 4)
}

_get_cursor_win() {
	old_win=$(xdotool getactivewindow)
	if [ $? -gt 0 ]; then
		old_win=0
		active_win_id=0
		active_win_class='GNOME'
		return
	fi
	# if active window is guake, don't care about cursor position
	if echo $guake | grep -w "$old_win"; then
		active_win_id=$old_win
	else
		active_win_id=$(xdotool getmouselocation --shell | sed -n 's/WI....=\(.*\)/\1/p')
	fi
	# echo "switch to: old_win=$old_win"
	# echo "switch to: active_win_id=$active_win_id"
	active_win_class=$(xprop -id $active_win_id WM_CLASS | cut -d \" -f 4)
}

_do_focusing() {
	if [ "$old_win" != "$active_win_id" ]; then
		# check to not refocus if the mouse is over GNOME shell
		if [ $active_win_id -gt 0 ]; then
			# wmctrl -iR "$active_win_id"
			echo 'switching focus'
			xdotool windowfocus "$active_win_id"
		else
			active_win_id=$old_win
			old_win='SAME'
		fi
	else
		old_win='SAME'
	fi
}

# reads: old_win
# sets: old_win, active_win_id
switch_win_back() {
	if [ "$old_win" = 'NO_ACTION' ]; then
		echo swich_win_back: do nothing
	elif [ -n "$old_win" ] && [ "$old_win" != 'SAME' ]; then
		if [ "$raise" = "do" ]; then
			echo switch_win_back: raise + focus
			xdotool windowfocus "$old_win"
			xdotool windowraise "$old_win"
			active_win_id=$old_win
			raise=
		else
			echo switch_win_back: focus
			xdotool windowfocus "$old_win"
			active_win_id=$old_win
		fi
	fi
	
	# clean up variables
	# -- IDK it's really necessary b/c _get_cursor_win always sets old_win
	old_win=	
}

three_finger_begin() {
	# active_win_id=$(xdotool getactivewindow)
	switch_to_cursor_win
	# logger 'fusuma: window='$active_win_class
	echo "begin: active_win_class=$active_win_class"
	# echo "begin: old_win=$old_win"
	if [ "$active_win_class" = 'Evince' ]; then
		# logger 'fusuma: pressing alt'
		ydotool key --key-delay 0 56:1 # left alt
	fi
}

three_finger_end() {
	echo "end: old_win=$old_win"
	if [ "$active_win_class" = 'Evince' ]; then
		ydotool key --key-delay 0 56:0 # left alt
		raise=do
	fi
	switch_win_back
	# wmctrl -iR "$(cat /var/run/user/$(id -u)/fusuma-old-win)"
}

three_finger_left() {
	case $active_win_class in
		Spotify)
			# logger 'fusuma key: AudioNext'
			# xte 'key XF86AudioNext'
			# ydotool key --key-delay 0 29:1 106:1 106:0 29:0
			ydotool key --key-delay 0 163:1 163:0
			;;
		Evince)
			# logger 'fusuma key: `'
			ydotool key --key-delay 0 41:1 41:0 # grave (`)
			evince_switched=1
			;;
		gnome-calendar)
			ydotool key --key-delay 0 109:1 109:0 # PgDown
			;;
		*)
			# logger 'fusuma key ctrl+PgDown'
			ydotool key --key-delay 0 29:1 109:1 109:0 29:0 # ctrl and PgDown
			;;
	esac
	evince_switched=
}


three_finger_right() {
	case $active_win_class in
		Spotify)
			# logger 'fusuma key: AudioPrev'
			# xte 'key XF86AudioPrev'
			# ydotool key --key-delay 0 29:1 105:1 105:0 29:0
			ydotool key --key-delay 0 165:1 165:0
			;;
		Evince)
			# logger 'fusuma key: shift+`'
			if [ $evince_switched ]; then
				ydotool key --key-delay 0 105:1 105:0 # left
			else
				ydotool key --key-delay 15 42:1 41:1 41:0 42:0 # sfhit + grave (`)
			fi
			evince_switched=1
			;;
		gnome-calendar)
			ydotool key --key-delay 0 104:1 104:0 # PgDown
			;;
		*)
			# logger 'fusuma key ctrl+PgUp'
			ydotool key --key-delay 0 29:1 104:1 104:0 29:0 # ctrl and PgUp
			;;
	esac
	evince_switched=
}

three_finger_up() {
	# if [ "$hold_wm_mode" ] && [ $(( $(date +%s%N) - $hold_wm_mode )) -lt 2000000000 ]; then
	# 	ydotool key --key-delay 56:1 62:1 62:0 56:0 # alt + f4
	# 	return
	# fi # doesn't work

	case $active_win_class in
		Tilix|Guake)
			ydotool key --key-delay 0 29:1 42:1 17:1 17:0 42:0 29:0
			;;
		firefox|firefox-default|"Firefox Developer Edition"|"Tor Browser"|Chromium)
			ydotool key --key-delay 0 29:1 62:1 62:0 29:0
			;;
		kitty)
			local winname=$(xprop -id $active_win_id WM_NAME | cut -d '"' -f 2)
			# echo $winname
			# if echo $winname | grep "^VI:"; then
			#     # xte 'keydown Control_L' 'keydown Alt_L' 'key Next' 'keyup Alt_L' 'keyup Control_L' 
			#     ydotool key --key-delay 0 1:1 1:0 # esc
			#     sleep 0.003
			#     # ydotool key --key-delay 0 29:1 24:1 24:0 29:0
			#     ydotool type --key-delay 3 ':q'
			#     ydotool key --key-delay 0 28:1 28:0
			# elif [ "$winname" = htop ] || [ "$winname" = man ]; then
			#     ydotool type --key-delay 0 'q'
			# else
			#     ydotool key --key-delay 0 29:1 62:1 62:0 29:0
			# fi
			case "$winname" in
			  "vi:"*)
				# xte 'keydown Control_L' 'keydown Alt_L' 'key Next' 'keyup Alt_L' 'keyup Control_L' 
				ydotool key --key-delay 0 1:1 1:0 # esc
				sleep 0.001
				# ydotool key --key-delay 0 29:1 24:1 24:0 29:0
				# ydotool type --key-delay 1 ':q'
				# sleep 0.001
				# ydotool key --key-delay 0 28:1 28:0
				ydotool key --key-delay 0 42:1 44:1 44:0 16:1 16:0 42:0 # shift + ZQ
				;;
			  htop|"man "*|"run-help "*|"mpv:"*|"mpa:"*)
				ydotool type --key-delay 0 'q'
				;;
			  *)
				ydotool key --key-delay 0 29:1 62:1 62:0 29:0
				;;
			esac
			;;
		Evince)
			# are we still in evince (not in the window switcher)?
			if [ "$(xprop -id $(xdotool getactivewindow) WM_CLASS | cut -d \" -f 4)" = 'Evince' ]; then
				ydotool key --key-delay 0 56:0 # left alt up
			fi
			ydotool key --key-delay 0 29:1 17:1 17:0 29:0
			;;
		*)
			ydotool key --key-delay 0 29:1 17:1 17:0 29:0 # ctrl + w
			;;
	esac
}

three_finger_down() {
	case $active_win_class in
		Tilix|kitty|Guake)
			echo "3finger down: key shift"
			ydotool key --key-delay 0 29:1 42:1 20:1 20:0 42:0 29:0
			# echo 'SAME' > "/var/run/user/$(id -u)/fusuma-old-win"
			;;
		TeXstudio)
			ydotool key --key-delay 0 29:1 49:1 49:0 29:0
			;;
		firefox|firefox-default|"Firefox Developer Edition"|"Tor Browser")
			echo "3finger down: key firefox special"
			if [ "$(echo "$(date +%s.%N) - $ff_newtab < 0.8" | bc)" -eq 1 ]; then 
				ydotool key --key-delay 0 29:1 62:1 62:0 29:0 # ctrl + f4
				ydotool key --key-delay 0 29:1 42:1 20:1 20:0 42:0 29:0 # ctrl + shift + t
				ff_newtab=
			else
				ff_newtab=$(date +%s.%N)
				ydotool key --key-delay 0 29:1 20:1 20:0 29:0
			fi
			;;
		gnome-calendar)
			ydotool key --key-delay 0 29:1 16:1 16:0 29:0 # ctrl + q
			;;
		# "")
		#     ydotool key --key-delay 0 29:1 56:1 20:1 20:0 56:0 29:0
		#     ;;
		Evince)
			# if [ -n "$(echo $state | grep "_NET_WM_STATE_MAXIMIZED_HORZ, _NET_WM_STATE_MAXIMIZED_VERT" | grep -v "_NET_WM_STATE_FULLSCREEN")" ]; then
			# 	ytodool key --key-delay 0 17:1 17:0
			# fi
			wmctrl -ir "$active_win_id" -b add,maximized_vert,maximized_horz
			;;
		*)
			echo "3finger down: key no shift"
			ydotool key --key-delay 0 29:1 20:1 20:0 29:0
			;;
	esac
	xdotool windowraise $active_win_id
	old_win=NO_ACTION
}


four_finger_hold() {
	hold_wm_mode=$(date +%s%N)
	notify-send.sh -f -t 1000 "fusuma server" "window manager mode"
	switch_to_cursor_win
}

four_finger_begin() {
	if [ ! "$hold_wm_mode" ] || [ $(( $(date +%s%N) - $hold_wm_mode )) -gt 1000000000 ]; then
		hold_wm_mode=
		ydotool key --key-delay 0 56:1 # left alt
	fi
}

four_finger_end() {
	echo "end"
	echo "wm_mode_tiling: $wm_mode_tiling"
	echo "hold_wm_mode: $hold_wm_mode"
	ydotool key --key-delay 0 56:0 # left alt
	# if [ "$has_switched_wins" ]; then
	# 	if [ "$wm_mode_tiling" = 'left' ]; then
	# 		echo "moving window right"
	# 		ydotool key --key-delay 0 125:1 106:1 106:0 125:0 # meta + right
	# 	elif [ "$wm_mode_tiling" = 'right' ]; then
	# 		echo "moving window left"
	# 		ydotool key --key-delay 0 125:1 105:1 105:0 125:0 # meta + left
	# 	fi
	# 	has_switched_wins=
	# fi
	if [ "$wm_mode_tiling" ]; then
		ydotool key --key-delay 0 28:1 28:0
	elif [ "$hold_wm_mode"]; then
		sleep 0.05
		switch_win_back
	fi
	hold_wm_mode=
	wm_mode_tiling=
	has_switched_wins=

	# clearing variables handled in if blocks
	# has_switched_wins=
	# hold_wm_mode=
	# wm_mode_tiling=
}

four_finger_left() {
	if [ $hold_wm_mode ]; then
		ydotool key --key-delay 0 125:1 105:1 105:0 125:0 # meta + left
		ydotool key --key-delay 0 56:1 # left alt down
		hold_wm_mode=
		wm_mode_tiling=left
		has_switched_wins=1
	else
		if [ $has_switched_wins ]; then
			ydotool key --key-delay 0 106:1 106:0 # left
		else
			ydotool key --key-delay 0 15:1 15:0
		fi
		has_switched_wins=1
	fi
}

four_finger_right() {
	if [ "$hold_wm_mode" ]; then
		ydotool key --key-delay 0 56:0 # left alt up
		ydotool key --key-delay 0 125:1 106:1 106:0 125:0 # meta + right
		ydotool key --key-delay 0 56:1 # left alt down
		wm_mode_tiling=right
		hold_wm_mode=
	else
		if [ $has_switched_wins ]; then
			ydotool key --key-delay 0 105:1 105:0 # left
		else
			ydotool key --key-delay 15 42:1 15:1 15:0 42:0 # shift+tab
		fi
		has_switched_wins=1
	fi
}

four_finger_down() {
	if [ $hold_wm_mode ]; then
		# for hiding:
		# ydotool key --key-delay 0 125:1 35:1 35:0 125:0 # meta + h
		ydotool key --key-delay 0 125:1 42:1 104:1 104:0 42:0 125:0
		# hold_wm_mode=
	else
		if [ $has_switched_wins ]; then
			# ydotool key --key-delay 0 1:1 1:0
			:
		else
			ydotool key --key-delay 0 56:0
			ydotool key --key-delay 0 125:1 104:1 104:0 125:0
		fi
	fi
}

four_finger_up() {
	if [ $hold_wm_mode ]; then
		ydotool key --key-delay 0 125:1 42:1 109:1 109:0 42:0 125:0
		# hold_wm_mode=
	else
		if [ -z $has_switched_wins ]; then
			ydotool key --key-delay 0 56:0
			ydotool key --key-delay 0 125:1 109:1 109:0 125:0
		else
			ydotool key --key-delay 0 17:1 17:0 # w
		fi
	fi
}

pinch_two_in() {
	echo "pinch 2 in"
	# switch_to_cursor_win
	_get_cursor_win
	if [ "$active_win_class" = "Evince" ] || [ "$active_win_class" = "firefox" ]; then
		if [ -n "$(xprop -id $active_win_id WM_NAME | grep -iP "fmovies|youtube|odysee\.com|tagesschau|prime video|Picture-in-Picture")" ] && xprop -id $active_win_id | grep "^_NET_WM_STATE(ATOM) =" | grep "_NET_WM_STATE_FULLSCREEN"; then
			ydotool key --key-delay 0 33:1 33:0
		fi
		return
	fi
	state=$(xprop -id $active_win_id | grep "^_NET_WM_STATE(ATOM) =")
	if [ -n "$(echo $state | grep _NET_WM_STATE_FULLSCREEN)" ]; then
		# case $(xprop -id $window WM_CLASS | cut -d "\"" -f 4) in
		case $active_win_class in
			vlc)
				ydo='33:1 33:0' # f
				;;
			xournalpp)
				ydo='87:1 87:0' # F11
				;;
			kitty)
				ydo='29:1 42:1 87:1 87:0 42:0 29:0' # ctrl + shift + F11
				;;
			*)
				wmctrl -ir "$active_win_id" -b remove,fullscreen
				# wmctrl -r ':ACTIVE:' -b remove,fullscreen
				;;
		esac
		if [ "$ydo" ]; then
			_do_focusing
			echo $ydo | xargs ydotool key --key-delay 0
			ydo=
			sleep 0.1
		fi
	else
		wmctrl -ir "$active_win_id" -b remove,maximized_vert,maximized_horz
	fi
	raise=do
	switch_win_back
}


pinch_two_out() {
	echo "pinch 2 out"
	# switch_to_cursor_win
	_get_cursor_win
	if [ "$active_win_class" = "Evince" ] || [ "$active_win_class" = "firefox" ]; then
		echo pass
		return
	fi
	state=$(xprop -id $active_win_id | grep "^_NET_WM_STATE(ATOM) =")
	if [ -n "$(echo $state | grep "_NET_WM_STATE_FULLSCREEN")" ]; then
		:
	elif [ -n "$(echo $state | grep "_NET_WM_STATE_MAXIMIZED_HORZ, _NET_WM_STATE_MAXIMIZED_VERT" | grep -v "_NET_WM_STATE_FULLSCREEN")" ]; then
		# case $(xprop -id $active_win_id WM_CLASS | cut -d "\"" -f 4) in
		case $active_win_class in
			vlc)
				ydo='33:1 33:0'
				;;
			xournalpp)
				ydo='87:1 87:0'
				;;
			firefox|firefox-default|"Firefox Developer Edition"|"Tor Browser"|Chromium)
				if [ -n "$(xprop -id $active_win_id WM_NAME | grep -iP "fmovies|youtube|odysee\.com|tagesschau|prime video|Picture-in-Picture")" ]; then
					ydo='33:1 33:0'
				else
					ydo='87:1 87:0'
				fi
				;;
			kitty)
				ydo='29:1 42:1 87:1 87:0 42:0 29:0'
				;;
			*)
				# wmctrl -r ":ACTIVE:" -b add,fullscreen
				wmctrl -ir "$active_win_id" -b add,fullscreen
				;;
		esac
		if [ "$ydo" ]; then
			_do_focusing
			echo $ydo | xargs ydotool key --key-delay 0
			ydo=
			sleep 0.1
		fi
	else
		wmctrl -ir "$active_win_id" -b add,maximized_vert,maximized_horz
	fi
	raise=do
	switch_win_back
}


# old pinch_three_in
# window=$(xdotool getactivewindow); state=$(xprop -id $window | grep "^_NET_WM_STATE(ATOM) ="); if [ -n "$(echo $state | grep "_NET_WM_STATE_FULLSCREEN")" ]; then :; elif [ -n "$(echo $state | grep "_NET_WM_STATE_MAXIMIZED_HORZ, _NET_WM_STATE_MAXIMIZED_VERT" | grep -v "_NET_WM_STATE_FULLSCREEN")" ]; then case $(xprop -id $window WM_CLASS | cut -d "\"" -f 4) in vlc) ydotool key --key-delay 0 33:1 33:0 ;; xournalpp) ydotool key --key-delay 0 87:1 87:0 ;; firefox) if [ -n "$(xprop -id $window WM_NAME | grep -iP "fmovies|youtube|tagesschau|prime video")" ]; then ydotool key --key-delay 0 33:1 33:0; else ydotool key --key-delay 0 87:1 87:0; fi ;; kitty) ydotool key --key-delay 0 29:1 42:1 87:1 87:0 42:0 29:0 ;; *) wmctrl -r ":ACTIVE:" -b add,fullscreen ;; esac else wmctrl -r ":ACTIVE:" -b add,maximized_vert,maximized_horz; fi
pinch_three_out() {
	case $(xprop -id $(xdotool getactivewindow) WM_CLASS | cut -d '"' -f 4) in
		kitty|Tilix)
			ydotool key --key-delay 0 56:1 1:1 1:0 56:0
			;;
		*)
			ydotool key --key-delay 0 125:1 5:1 5:0 125:0
			;;
	esac
}

pinch_three_in() {
	# ydotool key --key-delay 0 125:1 125:0 # meta
	gdbus call --session --dest org.gnome.Shell --object-path /dev/ramottamado/EvalGjs --method dev.ramottamado.EvalGjs.Eval "Main.overview.toggle();"
}

pinch_four_out() {
	ydotool key --key-delay 0 56:1 106:1 106:0 56:0 # alt + left
}

pinch_four_in() {
	ydotool key --key-delay 0 56:1 105:1 105:0 56:0 # alt + right
}

renice -11 -p $$
echo commands sourced

# remember ids of guake windows
guake=$(xdotool search --classname Guake)
