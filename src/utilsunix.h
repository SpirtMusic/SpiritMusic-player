#ifndef UTILSUNIX_H
#define UTILSUNIX_H

#include <QObject>
#include <QSysInfo>
#include <QCryptographicHash>
#include <QFileInfo>
#include <QUrl>

class UtilsUnix : public QObject
{
    Q_OBJECT
public:
    explicit UtilsUnix(QObject *parent = nullptr);
    Q_INVOKABLE  QString linuxMachineUniqueId();
    Q_INVOKABLE  bool isFileExists(QString filePath);

signals:

};

#endif // UTILSUNIX_H
