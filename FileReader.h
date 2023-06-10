#include <QObject>
#include <QVector>
#include <QFile>
#include <QString>
#include <QTextStream>

struct DetectedObject
{
    Q_GADGET
    Q_PROPERTY(QString time MEMBER time)
    Q_PROPERTY(int x MEMBER x)
    Q_PROPERTY(int y MEMBER y)
    Q_PROPERTY(int width MEMBER width)
    Q_PROPERTY(int height MEMBER height)
    Q_PROPERTY(float distance MEMBER distance)

public:
    QString time;
    int x;
    int y;
    int width;
    int height;
    float distance;
};

class FileReader : public QObject
{
    Q_OBJECT

public:
    explicit FileReader(QObject *parent = nullptr);

    Q_INVOKABLE QVector<DetectedObject> readFile(const QString &fileName);
};
