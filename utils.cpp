#include "utils.h"

utils::utils(QObject *parent)
    : QObject{parent}
{

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
