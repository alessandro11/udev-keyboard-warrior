SCRIPT = setkb.sh
UDEV_RULE = 80-keyboard.rules
PREFIX = /usr/local/bin
UDEV_PREFIX = /etc/udev/rules.d

CWD = $(shell pwd)
USERID = $(shell id -u)

install: isroot
	install --mode 0755 --owner=root --group=root $(SCRIPT) $(PREFIX)/$(SCRIPT)
	install --mode 0755 --owner=root --group=root $(UDEV_RULE) $(UDEV_PREFIX)/$(UDEV_RULE)

isroot:
	@if [ $(USERID) -ne 0 ]; then\
		echo "Must be root!";\
		exit 1;\
	fi

uninstall: isroot
	rm $(PREFIX)/$(SCRIPT)
	rm $(UDEV_PREFIX)/$(UDEV_RULE)
