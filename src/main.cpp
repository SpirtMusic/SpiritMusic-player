#include <QApplication>
#include <QQmlApplicationEngine>
#ifdef Q_OS_ANDROID
#include <utils/android/utilsandroid.h>
#endif
#ifdef Q_OS_LINUX
#include <utils/unix/utilsunix.h>
#endif
#ifdef Q_OS_WIN
#include <utils/windows/utilswin.h>
#endif
#include <QQmlContext>
#include <core/clipboardextension.h>
#include <core/jsonfile.h>
#include <core/serialgenerator.h>

#include <QQuickWindow>
#include <QMpv/qmpv.h>

int main(int argc, char *argv[])
{
    /***
     * Forcing Qt Quick to rendering via OpenGL API
     * Because we use qquickframebufferobject to rendering MPV Item
     * and we know qquickframebufferobject works only with OpenGL api
     * https://doc.qt.io/qt-6/qquickframebufferobject.html#details
     ***/
#if defined(Q_OS_LINUX) || defined(Q_OS_WIN)
   QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);
#endif

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
#ifdef Q_OS_ANDROID
    UtilsAndroid androidUtils;
    engine.rootContext()->setContextProperty("androidUtils", &androidUtils);
#endif
#ifdef Q_OS_LINUX
    UtilsUnix linuxUtils;
    engine.rootContext()->setContextProperty("linuxUtils", &linuxUtils);
#endif
#ifdef Q_OS_WIN
    UtilsWin winUtils;
    engine.rootContext()->setContextProperty("winUtils", &winUtils);
#endif

    JsonFile jsonFile;
    SerialGenerator serialn;
    qmlRegisterType<QMpv>("QMpv", 1, 0, "MPV");
    engine.rootContext()->setContextProperty("ActivateSys", &serialn);
    engine.rootContext()->setContextProperty("JsonFile", &jsonFile);
    ClipboardExtension ClipboardExt;
    engine.rootContext()->setContextProperty("clipboardExtension", &ClipboardExt);
    const QUrl url(u"qrc:/qml/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
