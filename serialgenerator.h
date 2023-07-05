#ifndef SERIALGENERATOR_H
#define SERIALGENERATOR_H

#include <QObject>
class SerialGenerator : public QObject
{
    Q_OBJECT
public:
    explicit SerialGenerator(QObject *parent = nullptr);
    Q_INVOKABLE bool checkDecryption(const QString& encryptedId, const QString& originalId);
    Q_INVOKABLE void  activate(const QString& encryptedId);
    Q_INVOKABLE QString  getEncryptedId();
    QString encrypt(const QString& id);

private:
    QString decrypt(const QString& encryptedId, const QString& originalId);

};

#endif // SERIALGENERATOR_H
