#include <QGuiApplication>
#include <QQmlApplicationEngine>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
   // qputenv("QT_QUICK_CONTROLS_STYLE", QByteArray("Material"));
   // qputenv("QT_QUICK_CONTROLS_MATERIAL_THEME", QByteArray("Dark"));
    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/sonegx-player-android/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
