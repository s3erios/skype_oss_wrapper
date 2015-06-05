CC	?= cc
MKDIR	?= mkdir
INSTALL	?= install

CFLAGS  ?= -O0 -ggdb
CFLAGS	+= -m32 -fPIC
LDFLAGS += -shared
LIBS	 = -lpthread

PREFIX	?= /usr
BIN_DIR	?= ${PREFIX}/bin
LIB_DIR ?= ${PREFIX}/lib/skype_oss_wrapper

OBJECTS	 = libpulse.o
TARGET	 = libpulse.so.0
WRAPPER	 = skype_oss

.PHONY:	all install clean

all:    ${TARGET} ${WRAPPER}

${TARGET}:	${OBJECTS}
	${CC} -m32 ${OBJECTS} -o ${TARGET} ${LDFLAGS} ${LIBS}

${WRAPPER}:
	echo "#!/bin/sh" > ${WRAPPER}
	echo "LD_LIBRARY_PATH=${LIB_DIR}:\$$LD_LIBRARY_PATH skype \"\$$@\"" >> ${WRAPPER}
	chmod +x ${WRAPPER}

install:	all
	${MKDIR} -p ${DESTDIR}${LIB_DIR}
	${MKDIR} -p ${DESTDIR}${BIN_DIR}
	${INSTALL} -m 755 ${WRAPPER} ${DESTDIR}${BIN_DIR}
	${INSTALL} -m 755 ${TARGET} ${DESTDIR}${LIB_DIR}

clean:
	rm -f ${WRAPPER} ${TARGET} ${OBJECTS}
