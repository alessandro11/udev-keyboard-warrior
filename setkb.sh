#!/usr/bin/env sh

#if [ "$ACTION" == "add" ]; then
#   # check if running X
#   if xset q &>/dev/null; then
#       #setxkbmap -layout br -variant abnt2 &> /dev/null
#       setxkbmap -layout br -variant abnt2
#   else
#       loadkeys /usr/share/kbd/keymaps/i386/qwerty/br-abnt2.map.gz
#   fi  
#   #localectl set-keymap "$LAYOUT"
#   #localectl set-x11-keymap "$LAYOUT"
#elif [ "$ACTION" == "remove" ]; then
#   # check if running X
#   if xset q &>/dev/null; then
#       setxkbmap -layout us
#   else
#       loadkeys /usr/share/kbd/keymaps/i386/qwerty/us.map.gz
#   fi  
#fi

if [ "$ACTION" == "add" ]; then
    # check if running X
	if [ -n $DELAY ]; then
		# delay little bit due to race condition in case is running from X
		count=0
		while [ $count -lt 2 ]; do
			[ -f "/tmp/.X0-lock" ] && count=3
			count=$(($count+1))
			sleep 0.5
		done
	fi

    if [ -f "/tmp/.X0-lock" ]; then
        #setxkbmap -layout br -variant abnt2 &> /dev/null
        setxkbmap -layout br -variant abnt2
    else
        loadkeys /usr/share/kbd/keymaps/i386/qwerty/br-abnt2.map.gz
    fi  
elif [ "$ACTION" == "remove" ]; then
    # check if running X
    if [ -f "/tmp/.X0-lock" ]; then
        setxkbmap -layout us
    else
        loadkeys /usr/share/kbd/keymaps/i386/qwerty/us.map.gz
    fi
fi

exit 0

