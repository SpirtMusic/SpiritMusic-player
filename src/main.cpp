#include <QApplication>
#include <QQmlApplicationEngine>
#ifdef Q_OS_ANDROID
#include <utilsandroid.h>
#endif
#ifdef Q_OS_LINUX
#include <utilsunix.h>
#endif
#ifdef Q_OS_WIN
#include <utilswin.h>.h>
#endif
#include <QQmlContext>
#include <clipboardextension.h>
#include <jsonfile.h>
#include <serialgenerator.h>
//#include <aes.h>
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
        // qputenv("QT_MEDIA_BACKEND", "android");
    // qputenv("QT_QUICK_CONTROLS_STYLE", QByteArray("Material"));
    // qputenv("QT_QUICK_CONTROLS_MATERIAL_THEME", QByteArray("Dark"));
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
    // AES fileCrypto;
    qmlRegisterType<QMpv>("QMpv", 1, 0, "MPV");
    //engine.rootContext()->setContextProperty("fileCrypto", &fileCrypto);
    engine.rootContext()->setContextProperty("ActivateSys", &serialn);
    engine.rootContext()->setContextProperty("JsonFile", &jsonFile);
    ClipboardExtension ClipboardExt;
    engine.rootContext()->setContextProperty("clipboardExtension", &ClipboardExt);
        //  qmlRegisterType<ClipboardExtension>("ClipboardExtension", 1, 0, "ClipboardExtension");
    const QUrl url(u"qrc:/qml/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
