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
//    QJniObject::callStaticMethod<void>("setRequestedOrientation",
//                                              "(I)V",
//                                              0); // 0: ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
}
bool utils::rotateToPortrait(){
//    QJniObject::callStaticMethod<void>("setRequestedOrientation",
//                                              "(I)V",
//                                              1); // 1: ActivityInfo.SCREEN_ORIENTATION_PORTRAIT

    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    if(activity.isValid())
    {
        activity.callMethod<void>("setRequestedOrientation", "(I)V", 1);
        return true;
    }

    return false;
}
