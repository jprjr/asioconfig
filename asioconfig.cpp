#include <stdlib.h>
#include <stdio.h>
#include <iup.h>
#include "asio.h"
#include "asiodrivers.h"

AsioDrivers *drivers;
ASIODriverInfo my_info;
Ihandle *dlg;

static int doubleclick_handler(Ihandle *ih, int item, char *text) {
    my_info.sysRef = GetForegroundWindow();
    strcpy(my_info.name,text);
    fprintf(stderr,"Attempting to init %s\n",text);
    if(!drivers->loadDriver(text)) {
        char *errormsg;
        int errormsglen;
        errormsglen = snprintf(0,0,"Unable to load driver for %s",text);
        errormsg = (char *)malloc(sizeof(char) * (errormsglen + 1));
        errormsglen = snprintf(errormsg,errormsglen+1,"Unable to load driver for %s",text);
        IupMessageError(dlg,errormsg);
        free(errormsg);
    }

    ASIOInit(&my_info);
    ASIOControlPanel();
    return 0;
}

int main(int argc, char **argv) {
    drivers = new AsioDrivers();
    char **names;
    int i = 0;
    long devices = 0;
    names = (char **)malloc(sizeof(char *) * 32);
    if(names == 0) {
        return 1;
    }
    for(i=0; i<32; i++) {
        names[i] = (char *)malloc(sizeof(char) * 32);
        if(names[i] == 0) {
            return 1;
        }
    }

    my_info.asioVersion = 2;

    Ihandle *list;
    IupOpen(&argc, &argv);

    list = IupList(0);

    devices = drivers->asioGetNumDev();
    if(devices == 0) {
        IupSetAttribute(list,"1","No items found");
        /* return 1; */
    }

    char listIndexString[3];

    for(i=0; i<devices; i++) {
        if(i < 32) {
          snprintf(listIndexString,3,"%d",i+1);
          drivers->asioGetDriverName(i,names[i],32);
          IupSetAttribute(list,listIndexString,names[i]);
        }
    }
    IupSetCallback(list,"DBLCLICK_CB",(Icallback)doubleclick_handler);

    dlg = IupDialog(IupVbox(list,NULL));
    IupSetAttribute(dlg, "TITLE", "Hello world");

    IupShowXY(dlg, IUP_CENTER, IUP_CENTER);

    IupMainLoop();

    IupClose();

    return EXIT_SUCCESS;
}

