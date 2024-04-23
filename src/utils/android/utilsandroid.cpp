#include "utilsandroid.h"
#include <QUrl>
UtilsAndroid::UtilsAndroid(QObject *parent)
    : QObject{parent}
{

}
void UtilsAndroid::share(const QString &urlfile) {

    QDesktopServices::openUrl(QUrl(urlfile, QUrl::TolerantMode));

}
QString UtilsAndroid::convertUriToPath(const QString &uriString) {
    QString fullFilePath = convertUriToPathFile(uriString);
    // Use QFileInfo to extract the directory path
    QFileInfo fileInfo(fullFilePath);
    QString directoryPath = fileInfo.path();
    return directoryPath;
}
QString UtilsAndroid::convertUriToPathFile(const QString &uriString){
    qDebug()<<"uriString : "<<uriString;
    // Create a QJniObject from the URI string
    QJniObject uriObject = QJniObject::fromString(uriString);
    QJniObject uri = QJniObject::callStaticObjectMethod(
        "android/net/Uri",
        "parse",
        "(Ljava/lang/String;)Landroid/net/Uri;",
        uriObject.object<jstring>()
        );

    // Get the context from the main application instance
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    QJniObject context = activity.callObjectMethod("getApplicationContext", "()Landroid/content/Context;");
    // Call the Java method to get the file path
    QJniObject filePath= QJniObject::callStaticObjectMethod(
        "org/sonegx/sonegxplayer/MyUtils",
        "getPath",
        "(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;",
        context.object<jobject>(),
        uri.object<jobject>()
        );

    // Check if filePath is null
    if (!filePath.isValid()) {
        qDebug() << "Error: Unable to get file path from URI";
        return QString();  // Return an empty string on error
    }

    // Convert the Java string to a Qt string and return it
    return QDir::fromNativeSeparators(filePath.toString());
}
bool UtilsAndroid::rotateToLandscape(){

    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    if(activity.isValid())
    {
        activity.callMethod<void>("setRequestedOrientation", "(I)V", 0);
        return true;
    }

    return false;
}
bool UtilsAndroid::rotateToPortrait(){
    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    if(activity.isValid())
    {
        activity.callMethod<void>("setRequestedOrientation", "(I)V", 1);
        return true;
    }

    return false;
}
void UtilsAndroid::setSecureFlag(bool setSecure) {
    QNativeInterface::QAndroidApplication::runOnAndroidMainThread([=]() {
        QJniObject activity = QNativeInterface::QAndroidApplication::context();

        if (activity.isValid()) {
            QJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");

            if (window.isValid()) {
                jint flagSecure = QJniObject::getStaticField<jint>("android/view/WindowManager$LayoutParams", "FLAG_SECURE");

                if (setSecure) {
                    window.callMethod<void>("setFlags", "(II)V", flagSecure, flagSecure);
                } else {
                    window.callMethod<void>("clearFlags", "(I)V", flagSecure);
                }
            }
        }
    });
}

bool UtilsAndroid::isFileExists(QString filePath){
    QString file=convertUriToPathFile(filePath);
    qDebug()<<"utils::isFileExists : "<<file;
    bool fileExists = QFileInfo::exists(file) && QFileInfo(file).isFile();
    return fileExists;
}

bool UtilsAndroid::checkStoragePermission(){
    qDebug()<<"checkStoragePermission()";
    QOperatingSystemVersion currentVersion = QOperatingSystemVersion::current();

    // Check if the current OS is Android and its version is >= 13
    if (currentVersion.type() == QOperatingSystemVersion::Android && currentVersion.majorVersion() >= 13) {
        qDebug() << "QOperatingSystemVersion: Android >= 13.";
        auto r = QtAndroidPrivate::checkPermission(QString("android.permission.READ_MEDIA_VIDEO")).result();
        if (r == QtAndroidPrivate::Denied)
        {
            qDebug()<<"checkStoragePermission() Denied";
            r = QtAndroidPrivate::requestPermission(QString("android.permission.READ_MEDIA_VIDEO")).result();
            if (r == QtAndroidPrivate::Denied)
                return false;
        }
        return true;
    } else {
        qDebug() << "QOperatingSystemVersion: Android < 13.";
        auto r = QtAndroidPrivate::checkPermission(QString("android.permission.READ_EXTERNAL_STORAGE")).result();
        if (r == QtAndroidPrivate::Denied)
        {
            qDebug()<<"checkStoragePermission() Denied";
            r = QtAndroidPrivate::requestPermission(QString("android.permission.READ_EXTERNAL_STORAGE")).result();
            if (r == QtAndroidPrivate::Denied)
                return false;
        }
        return true;
    }


}

QString UtilsAndroid::getAndroidID(){
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

QString UtilsAndroid::hashAndFormat(const QString& androidId){
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
void UtilsAndroid::keepScreenOn(bool keepOn) {
    // Get the current activity
    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    if (activity.isValid()) {
        // Get the window object
        QJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");

        if (window.isValid()) {
            const int FLAG_KEEP_SCREEN_ON = 128;

            if (keepOn) {
                // Add the FLAG_KEEP_SCREEN_ON flag to keep the screen on
                window.callMethod<void>("addFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
            } else {
                // Remove the FLAG_KEEP_SCREEN_ON flag to allow the screen to turn off
                window.callMethod<void>("clearFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
            }
        }
    }
}
