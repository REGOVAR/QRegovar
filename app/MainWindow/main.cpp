#include "mainwindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setApplicationName("Regovar");
    a.setOrganizationName("Regovar");
    a.setOrganizationDomain("regovar.org");
    a.setApplicationVersion("0.0.a");


    MainWindow w;
    w.show();

    return a.exec();
}
