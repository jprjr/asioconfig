all:
TARGET=i686-w64-mingw32
IUP_VER=3.22

include iup/Makefile

.PHONY: all asioconfig clean

all: build/$(TARGET)/asioconfig.exe

ASIO_INCDIRS = -Iasio/common -Iasio/host -Iasio/host/pc
ASIO_FILES = asio/common/asio.cpp asio/host/pc/asiolist.cpp asio/host/asiodrivers.cpp
WINDOWS_LIBS = -lgdi32 -lcomdlg32 -lcomctl32 -luuid -loleaut32 -lole32



build/$(TARGET)/asioconfig.exe: asioconfig.cpp $(LIBIUP) build/$(TARGET)/asioconfig.coff
	mkdir -p build/$(TARGET)
	$(TARGET_CXX) -mwindows -static -I$(IUP_INCDIR) $(ASIO_INCDIRS) -o $@ asioconfig.cpp $(ASIO_FILES) -L$(IUP_LIBDIR) -liup $(WINDOWS_LIBS) build/$(TARGET)/asioconfig.coff
	$(TARGET_STRIP) $@
	upx $@


build/$(TARGET)/asioconfig.coff: asioconfig.rc
	$(TARGET_WINDRES) -v -c 1252 asioconfig.rc -o $@

clean:
	rm -f build/$(TARGET)/*
