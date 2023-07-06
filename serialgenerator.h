#ifndef SERIALGENERATOR_H
#define SERIALGENERATOR_H

#include <QObject>
class SerialGenerator : public QObject
{
    Q_OBJECT
public:
    explicit SerialGenerator(QObject *parent = nullptr);
    Q_INVOKABLE bool checkDecryption(const QString& encryptedId, const QString& originalId);
    Q_INVOKABLE bool  activate(const QString& encryptedId, const QString& originalId);
    Q_INVOKABLE QString  getEncryptedId();
    Q_INVOKABLE void  cleanSerial();
    QString encrypt(const QString& id);

private:
    QString decrypt(const QString& encryptedId, const QString& originalId);

};

#endif // SERIALGENERATOR_H
