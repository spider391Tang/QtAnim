#include "FileReader.h"

FileReader::FileReader(QObject *parent) : QObject(parent) {}

QVector<DetectedObject> FileReader::readFile(const QString &fileName)
{
    QVector<DetectedObject> objects;
    QFile file(fileName);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return objects;

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList parts = line.split(",");
        DetectedObject object;
        object.time = parts[0].trimmed();
        object.x = parts[2].trimmed().toInt();
        object.y = parts[3].trimmed().toInt();
        object.width = parts[4].trimmed().toInt();
        object.height = parts[5].trimmed().toInt();
        object.distance = parts[6].trimmed().toFloat();
        objects.append(object);
    }

    file.close();
    return objects;
}
