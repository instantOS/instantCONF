PREFIX = /usr/

all: install

install:
	install -Dm 755 instantconf.sh ${DESTDIR}${PREFIX}bin/instantconf

uninstall:
	rm ${DESTDIR}${PREFIX}bin/instantconf
