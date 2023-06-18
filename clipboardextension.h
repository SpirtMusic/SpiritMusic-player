#ifndef CLIPBOARDEXTENSION_H
#define CLIPBOARDEXTENSION_H

#include <QObject>
#include <QClipboard>
#include <QApplication>

class ClipboardExtension : public QObject
{
    Q_OBJECT
public:
    explicit ClipboardExtension(QObject *parent = nullptr);
    Q_INVOKABLE void setText(const QString &text);
signals:

};

#endif // CLIPBOARDEXTENSION_H
