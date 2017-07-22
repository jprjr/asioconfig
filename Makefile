all:
TARGET=x86_64-w64-mingw32
IUP_VER=3.22

include iup/Makefile

.PHONY: all asioconfig clean

all: build/$(TARGET)/asioconfig.exe

ASIO_INCDIRS = -Iasio/common -Iasio/host -Iasio/host/pc
ASIO_FILES = asio/common/asio.cpp asio/host/pc/asiolist.cpp asio/host/asiodrivers.cpp
WINDOWS_LIBS = -lgdi32 -lcomdlg32 -lcomctl32 -luuid -loleaut32 -lole32



build/$(TARGET)/asioconfig.exe: asioconfig.cpp $(LIBIUP) asioconfig.res
	mkdir -p build/$(TARGET)
	$(TARGET_CXX) -mwindows -static -I$(IUP_INCDIR) $(ASIO_INCDIRS) -o $@ asioconfig.cpp $(ASIO_FILES) -L$(IUP_LIBDIR) -liup $(WINDOWS_LIBS) asioconfig.res
	$(TARGET_STRIP) $@
	upx $@


asioconfig.res: asioconfig.rc
	$(TARGET_WINDRES) -c 1252 asioconfig.rc -O coff -o asioconfig.res

clean:
	rm -f asioconfig.res asioconfig.exe
