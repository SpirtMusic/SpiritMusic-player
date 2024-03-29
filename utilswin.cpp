#include "utilswin.h"

UtilsWin::UtilsWin(QObject *parent)
    : QObject{parent}
{

}
QString UtilsWin::winMachineUniqueId(){
    QByteArray machineUniqueIdBytes = QSysInfo::machineUniqueId();
    if (machineUniqueIdBytes.isEmpty())
        return QString(); // Return an empty string if no unique ID is available

    QByteArray hashBytes = QCryptographicHash::hash(machineUniqueIdBytes, QCryptographicHash::Sha256);
    QString hashedId = QString(hashBytes.toHex());

    QString truncatedId = hashedId.left(20);

    QString formattedId;
    for (int i = 0; i < truncatedId.length(); i++)
    {
        if (i != 0 && i % 4 == 0)
            formattedId.append('-');

        formattedId.append(truncatedId.at(i));
    }

    return formattedId;

}
