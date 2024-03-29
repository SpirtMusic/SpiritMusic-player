#ifndef UTILSWIN_H
#define UTILSWIN_H

#include <QObject>
#include <QSysInfo>
#include <QCryptographicHash>

class UtilsWin : public QObject
{
    Q_OBJECT
public:
    explicit UtilsWin(QObject *parent = nullptr);
    Q_INVOKABLE  QString winMachineUniqueId();

signals:

};

#endif // UTILSWIN_H
