#include "clipboardextension.h"

ClipboardExtension::ClipboardExtension(QObject *parent)
    : QObject{parent}
{

}
void ClipboardExtension::setText(const QString &text)
{
    QClipboard *clipboard = QApplication::clipboard();
    clipboard->setText(text);
}
