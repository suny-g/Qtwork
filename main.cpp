#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "musicmanager.h"
#include "playlistmodel.h"
#include "metadatareader.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    MusicManager musicManager;
    MetadataReader metadataReader;

    engine.rootContext()->setContextProperty("musicManager", &musicManager);
    engine.rootContext()->setContextProperty("metadataReader", &metadataReader);

    engine.loadFromModule("Music", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}