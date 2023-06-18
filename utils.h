#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QNetworkInterface>
#include <QSysInfo>
#include <QCoreApplication>
#include <QDebug>
#include <QtCore/private/qandroidextras_p.h>
#include <QFile>
#include <QSettings>
#include <QUuid>
 #include <QStandardPaths>
#include <QTextStream>
#include <QCryptographicHash>
class utils : public QObject
{
    Q_OBJECT
public:
    explicit utils(QObject *parent = nullptr);
    Q_INVOKABLE QString getAndroidID()
    {
        //        if (!checkPermission()) {
        //            qDebug() << "Permission denied! from MAC";
        //            return QString(); // Return an empty string or handle the permission denial case
        //    }
        // Check if the UUID file exists
        QJniObject activity =   QNativeInterface::QAndroidApplication::context();
        if (activity.isValid())
        {
            QJniObject contentResolver = activity.callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
            if (contentResolver.isValid())
            {
                QJniObject androidId = QJniObject::callStaticObjectMethod("android/provider/Settings$Secure",
                                                                                        "getString",
                                                                                        "(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;",
                                                                                        contentResolver.object<jobject>(),
                                                                                        QJniObject::fromString("android_id").object<jstring>());
                if (androidId.isValid())
                {
                     QString finalID=hashAndFormat(androidId.toString());
                          return finalID;
                }
            }
        }

        return QString();

    }

    QString hashAndFormat(const QString& androidId)
    {
        QByteArray androidIdBytes = androidId.toUtf8();
        QByteArray hashBytes = QCryptographicHash::hash(androidIdBytes, QCryptographicHash::Sha256);
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
    bool checkPermission()
    {
        auto r = QtAndroidPrivate::checkPermission(QString("android.permission.STORAGE")).result();
        if (r == QtAndroidPrivate::Denied)
        {
            r = QtAndroidPrivate::requestPermission(QString("android.permission.STORAGE")).result();
            if (r == QtAndroidPrivate::Denied)
                return false;
        }
        return true;
    }

    Q_INVOKABLE bool rotateToLandscape();
    Q_INVOKABLE bool rotateToPortrait();
signals:

};

#endif // UTILS_H
