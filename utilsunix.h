#ifndef UTILSUNIX_H
#define UTILSUNIX_H

#include <QObject>
#include <QSysInfo>
#include <QCryptographicHash>

class UtilsUnix : public QObject
{
    Q_OBJECT
public:
    explicit UtilsUnix(QObject *parent = nullptr);
    Q_INVOKABLE  QString linuxMachineUniqueId();

signals:

};

#endif // UTILSUNIX_H
