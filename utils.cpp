#include "utils.h"
#include <QUrl>
utils::utils(QObject *parent)
    : QObject{parent}
{

}
void utils::share(const QString &urlfile) {

QDesktopServices::openUrl(QUrl(urlfile, QUrl::TolerantMode));


}
QString utils::convertUriToPath(const QString &uriString) {
    QString fullFilePath = convertUriToPathFile(uriString);
    // Use QFileInfo to extract the directory path
    QFileInfo fileInfo(fullFilePath);
    QString directoryPath = fileInfo.path();

    return directoryPath;
}
QString utils::convertUriToPathFile(const QString &uriString){
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
    QJniObject getUSB = QJniObject::callStaticObjectMethod(
        "org/sonegx/sonegxplayer/MyUtils",
        "getUSB",
        "(Landroid/content/Context;)Ljava/lang/String;",  // <-- Update to match the return type of getUSB()
          context.object<jobject>()
        );

    qDebug() << "getUSB"<<getUSB.toString();
    // Check if filePath is null
    if (!filePath.isValid()) {
        qDebug() << "Error: Unable to get file path from URI";
        return QString();  // Return an empty string on error
    }

    // Convert the Java string to a Qt string and return it
    qDebug() << "filePath.toString()  "<< filePath.toString();
    return QDir::fromNativeSeparators(filePath.toString());
}
bool utils::rotateToLandscape(){

    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    if(activity.isValid())
    {
        activity.callMethod<void>("setRequestedOrientation", "(I)V", 0);
        return true;
    }

    return false;
}
bool utils::rotateToPortrait(){
    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    if(activity.isValid())
    {
        activity.callMethod<void>("setRequestedOrientation", "(I)V", 1);
        return true;
    }

    return false;
}
void utils::setSecureFlag(){
     QNativeInterface::QAndroidApplication::runOnAndroidMainThread([=]()
                                  {
                                      QJniObject activity = QNativeInterface::QAndroidApplication::context();
                                      if (activity.isValid())
                                      {
                                          QJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
                                          if (window.isValid())
                                          {
                                              jint flagSecure = QJniObject::getStaticField<jint>("android/view/WindowManager$LayoutParams", "FLAG_SECURE");
                                              window.callMethod<void>("setFlags", "(II)V", flagSecure, flagSecure);
                                          }
                                      }
                                  });
}


