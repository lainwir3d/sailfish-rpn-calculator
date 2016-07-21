#include <QtQuick>

#include <sailfishapp.h>
#include <../common/src/settingsmanager.h>

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    //return SailfishApp::main(argc, argv);

    SettingsManager s;

    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();
    view->rootContext()->setContextProperty("settings",  &s);
    view->setSource(SailfishApp::pathTo("qml/harbour-rpncalc.qml"));
    view->showFullScreen();
    return app->exec();
}

