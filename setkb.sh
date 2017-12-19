#!/usr/bin/env sh

case "$ACTION" in
	add)
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
			setxkbmap -layout br -variant abnt2 &> /dev/null
		else
			loadkeys /usr/share/kbd/keymaps/i386/qwerty/br-abnt2.map.gz
		fi  
		;;

	remove)
    # check if running X
    if [ -f "/tmp/.X0-lock" ]; then
        setxkbmap -layout us
    else
        loadkeys /usr/share/kbd/keymaps/i386/qwerty/us.map.gz
    fi
		;;
esac

exit 0

