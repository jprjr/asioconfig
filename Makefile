all:
TARGET=i686-w64-mingw32
IUP_VER=3.22

include iup/Makefile

.PHONY: all asioconfig clean dist

all: build/$(TARGET)/asioconfig.exe

ASIO_INCDIRS = -IASIOSDK2.3/common -IASIOSDK2.3/host -IASIOSDK2.3/host/pc
ASIO_FILES = ASIOSDK2.3/common/asio.cpp ASIOSDK2.3/host/pc/asiolist.cpp ASIOSDK2.3/host/asiodrivers.cpp
WINDOWS_LIBS = -lgdi32 -lcomdlg32 -lcomctl32 -luuid -loleaut32 -lole32


build/$(TARGET)/asioconfig.exe: asioconfig.cpp $(LIBIUP) build/$(TARGET)/asioconfig.coff
	mkdir -p build/$(TARGET)
	$(TARGET_CXX) -mwindows -static -I$(IUP_INCDIR) $(ASIO_INCDIRS) -o $@ asioconfig.cpp $(ASIO_FILES) -L$(IUP_LIBDIR) -liup $(WINDOWS_LIBS) build/$(TARGET)/asioconfig.coff
	$(TARGET_STRIP) $@
	upx $@

build/$(TARGET)/asioconfig.coff: asioconfig.rc
	mkdir -p build/$(TARGET)
	$(TARGET_WINDRES) -v -c 1252 asioconfig.rc -o $@

clean:
	rm -f build/$(TARGET)/*

dist: build/$(TARGET)/asioconfig.exe
	mkdir -p dist
	cd build/$(TARGET) && zip asioconfig.zip asioconfig.exe
