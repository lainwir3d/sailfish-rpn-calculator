#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQuickView>
#include <QObject>

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

    QApplication app(argc, argv);

    QQuickView view;
    view.setTitle("Zik Manager");

    //QPixmap pixmap = QPixmap(":/icon.png");
    //view.setIcon(QIcon(pixmap));

    view.rootContext()->setContextProperty("settings", &s);

    view.setSource(QUrl(QStringLiteral("qrc:///rpncalc.qml")));

#ifdef Q_OS_ANDROID
    view.show();
#else
    view.setWidth(275);
    view.setHeight(500);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();
#endif

    return app.exec();
}

