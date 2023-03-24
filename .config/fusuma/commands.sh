#!/bin/sh

three_finger_begin() {
	# id=$(xdotool getactivewindow)
	old_win=$(xdotool getactivewindow)
	id=$(xdotool getmouselocation --shell | grep WINDOW | sed 's/.*=\(.*\)/\1/')
	if [ $old_win != $id ]; then
		# wmctrl -iR "$id"
		xdotool windowfocus "$id"
		# echo $old_win > "/var/run/user/$(id -u)/fusuma-old-win"
	else
		# echo 'SAME' > "/var/run/user/$(id -u)/fusuma-old-win"
		old_win='SAME'
	fi
	wname=$(xprop -id $id WM_CLASS | cut -d \" -f 4 | tee "/var/run/user/$(id -u)/fusuma-3finger")
	# logger 'fusuma: window='$wname
	echo "\n\nwname=$wname\n\n"
	if [ "$wname" = 'Evince' ]; then
		# logger 'fusuma: pressing alt'
		ydotool key --key-delay 0 56:1 # left alt
	fi
}

three_finger_end() {
	# file="/var/run/user/$(id -u)/fusuma-3finger"
	# old_win=$(cat /var/run/user/$(id -u)/fusuma-old-win)
	# echo $old_win
	if [ "$(cat $file)" = 'Evince' ]; then
		ydotool key --key-delay 0 56:0 # left alt
		raise=do
		# if [ "$(xprop -id $old_win WM_CLASS | cut -d \" -f 4)" = 'Evince' ]; then
		#     # xdotool windowraise $old_win
		# fi
	fi
	if [ "$old_win" != 'SAME' ]; then
		if [ "$raise" = "do" ]; then
			xdotool windowraise $old_win
		else
			xdotool windowfocus $old_win
		fi
	fi
	# rm "$file"
	# wmctrl -iR "$(cat /var/run/user/$(id -u)/fusuma-old-win)"
	
}

three_finger_left() {
	file="/var/run/user/$(id -u)/fusuma-3finger"
	# if [ $(( $(date +%s%N) - $(stat -c %.Y $file | sed 's/\.//') )) -gt 500000000 ]; then
	#     timeout 10 inotifywait --event modify $file
	# fi
	NAME=$(cat "$file")
	if [ -z "$NAME" ]; then
		NAME=$(xprop -id $(xdotool getactivewindow) WM_CLASS | cut -d \" -f 4)
	fi
	case $NAME in
		Spotify)
			# logger 'fusuma key: AudioNext'
			# xte 'key XF86AudioNext'
			ydotool key --key-delay 0 29:1 106:1 106:0 29:0
			;;
		Evince)
			# logger 'fusuma key: `'
			ydotool key --key-delay 0 41:1 41:0 # grave (`)
			;;
		gnome-calendar)
			ydotool key --key-delay 0 109:1 109:0 # PgDown
			;;
		*)
			# logger 'fusuma key ctrl+PgDown'
			ydotool key --key-delay 0 29:1 109:1 109:0 29:0 # ctrl and PgDown
			;;
	esac
	
}


three_finger_right() {
	file="/var/run/user/$(id -u)/fusuma-3finger"
	# if [ $(( $(date +%s%N) - $(stat -c %.Y $file | sed 's/\.//') )) -gt 500000000 ]; then
	#     timeout 10 inotifywait --event modify $file
	# fi
	NAME=$(cat "$file")
	if [ -z "$NAME" ]; then
		NAME=$(xprop -id $(xdotool getactivewindow) WM_CLASS | cut -d \" -f 4)
	fi
	case $NAME in
		Spotify)
			# logger 'fusuma key: AudioPrev'
			# xte 'key XF86AudioPrev'
			ydotool key --key-delay 0 29:1 105:1 105:0 29:0
			;;
		Evince)
			# logger 'fusuma key: shift+`'
			ydotool key --key-delay 0 42:1 41:1 41:0 42:0 # sfhit + grave (`)
			;;
		gnome-calendar)
			ydotool key --key-delay 0 104:1 104:0 # PgDown
			;;
		*)
			# logger 'fusuma key ctrl+PgUp'
			ydotool key --key-delay 0 29:1 104:1 104:0 29:0 # ctrl and PgUp
			;;
	esac
}

three_finger_up() {
	file="/var/run/user/$(id -u)/fusuma-3finger"
	if [ $(( $(date +%s%N) - $(stat -c %.Y $file | sed 's/\.//') )) -gt 500000000 ]; then
		timeout 5 inotifywait --event modify $file
	fi
	NAME=$(cat "$file")
	if [ -z "$NAME" ]; then
		NAME=$(xprop -id $(xdotool getactivewindow) WM_CLASS | cut -d \" -f 4)
	fi
	case $NAME in
		Tilix)
			ydotool key --key-delay 0 29:1 42:1 17:1 17:0 42:0 29:0
			;;
		firefox|"Firefox Developer Edition"|"Tor Browser")
			ydotool key --key-delay 0 29:1 62:1 62:0 29:0
			;;
		kitty)
			winname=$(xprop -id $(xdotool getactivewindow) WM_NAME | cut -d '"' -f 2)
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
				ydotool type --key-delay 1 ':q'
				sleep 0.001
				ydotool key --key-delay 0 28:1 28:0
				;;
			  htop|"man "*)
				ydotool type --key-delay 0 'q'
				;;
			  *)
				ydotool key --key-delay 0 29:1 62:1 62:0 29:0
				;;
			esac
			;;
		Evince)
			if [ $(xprop -id $(xdotool getactivewindow) WM_CLASS | cut -d \" -f 4) = 'Evince' ]; then
				ydotool key --key-delay 0 56:0 # left alt
			fi
			ydotool key --key-delay 0 29:1 17:1 17:0 29:0
			;;
		*)
			ydotool key --key-delay 0 29:1 17:1 17:0 29:0
			;;
	esac
}

three_finger_down() {
	file="/var/run/user/$(id -u)/fusuma-3finger"
	if [ $(( $(date +%s%N) - $(stat -c %.Y $file | sed 's/\.//') )) -gt 500000000 ]; then
		timeout 5 inotifywait --event modify $file
	fi
	NAME=$(cat "$file")
	if [ -z "$NAME" ]; then
		NAME=$(xprop -id $(xdotool getactivewindow) WM_CLASS | cut -d \" -f 4)
	fi
	echo "\nNAME=$NAME\n"
	case $NAME in
		Tilix|kitty|Guake)
			echo "key: shift\n\n"
			ydotool key --key-delay 0 29:1 42:1 20:1 20:0 42:0 29:0
			echo 'SAME' > "/var/run/user/$(id -u)/fusuma-old-win"
			;;
		TeXstudio)
			ydotool key --key-delay 0 29:1 49:1 49:0 29:0
			;;
		firefox|"Firefox Developer Edition"|"Tor Browser")
			echo "key: firefox special\n\n"
			if [ $(echo "$(date +%s.%N) - $(stat -c %.9Y /var/run/user/$(id -u)/fusuma-FF-newtab) < 0.6" | bc) -eq 1 ]; then 
				ydotool key --key-delay 0 29:1 62:1 62:0 29:0 # ctrl + w
				ydotool key --key-delay 0 29:1 42:1 20:1 20:0 42:0 29:0 # ctrl + shift + t
				rm "/var/run/user/$(id -u)/fusuma-FF-newtab"
			else
				touch "/var/run/user/$(id -u)/fusuma-FF-newtab"
				ydotool key --key-delay 0 29:1 20:1 20:0 29:0
			fi
			echo 'SAME' > "/var/run/user/$(id -u)/fusuma-old-win"
			;;
		# "")
		#     ydotool key --key-delay 0 29:1 56:1 20:1 20:0 56:0 29:0
		#     ;;
		*)
			echo "key: no shift\n\n"
			ydotool key --key-delay 0 29:1 20:1 20:0 29:0
			;;
	esac
}


four_finger_begin() {
	ydotool key --key-delay 0 56:1 # left alt
}

four_finger_end() {
	rm "/var/run/user/$(id -u)/fusuma-4finger-switch"
	ydotool key --key-delay 0 56:0 # left alt
}

four_finger_left() {
	touch "/var/run/user/$(id -u)/fusuma-4finger-switch"
	ydotool key --key-delay 0 15:1 15:0
}

four_finger_right() {
	touch "/var/run/user/$(id -u)/fusuma-4finger-switch"
	ydotool key --key-delay 0 42:1 15:1 15:0 42:0
}

four_finger_down() {
	ydotool key --key-delay 0 56:0
	if [ -n "$(cat "/var/run/user/$(id -u)/fusuma-4finger-hold")" ]; then
		ydotool key --key-delay 0 125:1 35:1 35:0 125:0
		echo -n > "/var/run/user/$(id -u)/fusuma-4finger-hold"
	else
		ydotool key --key-delay 0 125:1 104:1 104:0 125:0
	fi
}

four_finger_up() { 
	if [ -f "/var/run/user/$(id -u)/fusuma-4finger-switch" ]; then
		ydotool key --key-delay 0 17:1 17:0 # w
	else
		ydotool key --key-delay 0 56:0
		ydotool key --key-delay 0 125:1 109:1 109:0 125:0
	fi
}

