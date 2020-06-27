#!/usr/bin/env sh

#
# if no layout has been passed at parameter 1, assume
# us layout.
#
layout=${1:-us}
variant=""
#
# Timeout in half seconds to wait for X_LOCK_FILE to appear
#
DELAY_TIMEOUT=6

#####
# get_kblayout_variant - gets order of keyboards layouts and respective variant
#
# Param:
#  $1 (REFERENCE) in/out - in layout of the keyboard to be set as first one; e.g us,br,us
#                        - out sequence of layouts us,us,br e.g.
#  $2 (REFERENCE) out - variant of the layouts in kb_layout.
#  $3 - 0 Xorg is not running, setxkbmap will be used to set
#       the layout; 1 Xorg is running loadkeys will be used, variant is ignored.
#
# Return:
#  kb_layout reference variable; returns string with sequence of layouts;
#  kb_variant reference variable; return string of variants; the order of
#  layout is one to one with variant; e.g.: layout=us,us,br variant=,intl,abnt2
#  us , has no variant (pure us kbd)
#  us intl the keyboard is us but can set accent
#  br abnt2 the keyboard layout and variant is full pt_BR
#
# P.s.:
#  if no X is running, kb_layout will be set to the layout us, for ex.
#  br will be translated to br-abnt2. This is due to the reason the file
#  for loadkeys expected us.map.gz, for us, and br-abnt2.map.gz for br.
get_kblayout_variant() {
    local -n kb_layout=$1
    local -n kb_variant=$2
    local noX=$3

    if [ $noX -eq 0 ]; then
        if [ "$kb_layout" == "br" ]; then
            kb_layout="br-abnt2"
        fi

        kb_variant=""
        return 1
    fi

    case $kb_layout in
        us)
            kb_layout="us,us,br"
            kb_variant=",intl,abnt2"
            ;;

        br)
            kb_layout="br,us,us"
            kb_variant="abnt2,intl,"
            ;;

        *)
            kb_layout="us,us,br"
            kb_variant=",intl,abnt2"
            ;;
    esac

    return 0
}

IsXrunning() {
    xrdb -quiet -query &>/dev/null
    return $?
}

case "$ACTION" in
	add)
		if [ -n $DELAY ]; then
			# delay little bit due to race condition in case is running from X
			count=0
			while [ ! IsXrunning ] && [ $count -lt $DELAY_TIMEOUT ]; do
				sleep 0.5
                count=$(($count+1))
                [ IsXrunning; ] && count=$DELAY_TIMEOUT
			done
		fi

		if IsXrunning; then
            get_kblayout_variant layout variant 1
			setxkbmap -layout $layout -variant $variant
		else
            # no X running; variant is ignored
            get_kblayout_variant layout variant 0
			sudo loadkeys /usr/share/kbd/keymaps/i386/qwerty/${layout}.map.gz
		fi
		;;

	remove)
        if [ IsXrunning ]; then
            get_kblayout_variant layout variant 1
            setxkbmap -layout $layout -variant $variant
        else
            # no X running; variant is ignored
            get_kblayout_variant layout variant 0
			sudo loadkeys /usr/share/kbd/keymaps/i386/qwerty/${layout}.map.gz
        fi
		;;
esac

exit 0
