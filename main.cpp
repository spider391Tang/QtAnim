#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

// #include "FileReader.h"
#include "fileio.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    qmlRegisterType<FileIO, 1>("FileIO", 1, 0, "FileIO");
    // qmlRegisterType<FileReader>("com.yourcompany", 1, 0, "FileReader");
    // qRegisterMetaType<DetectedObject>("DetectedObject");

    QQmlApplicationEngine engine;

    // FileReader fileReader;
    // engine.rootContext()->setContextProperty("fileReader", &fileReader);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
