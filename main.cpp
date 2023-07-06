#include <QApplication>
#include <QQmlApplicationEngine>
#ifdef Q_OS_ANDROID
#include <utils.h>
#endif
#include <QQmlContext>
#include <clipboardextension.h>
#include <jsonfile.h>
#include <serialgenerator.h>
//#ifdef Q_OS_ANDROID
//const QVector<QString> permissions({"MANAGE_EXTERNAL_STORAGE",
//                                    "android.permission.WRITE_EXTERNAL_STORAGE",
//                                    "android.permission.READ_EXTERNAL_STORAGE"});
//#endif
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    //  qputenv("QT_MEDIA_BACKEND", "android");
    // qputenv("QT_QUICK_CONTROLS_STYLE", QByteArray("Material"));
    // qputenv("QT_QUICK_CONTROLS_MATERIAL_THEME", QByteArray("Dark"));
    QQmlApplicationEngine engine;
#ifdef Q_OS_ANDROID
    //    //Request requiered permissions at runtime

    //    for(const QString &permission : permissions){
    //        auto result = QtAndroidPrivate::checkPermission(permission).result();
    //        if(result == QtAndroidPrivate::Denied){
    //            auto resultHash = QtAndroidPrivate::requestPermission(QStringList({permission})).result();
    //            if(resultHash[permission] == QtAndroidPrivate::Denied)
    //                return 0;
    //        }
    //    }
    utils android;
    engine.rootContext()->setContextProperty("androidUtils", &android);
#endif
    JsonFile jsonFile;
    SerialGenerator serialn;

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
