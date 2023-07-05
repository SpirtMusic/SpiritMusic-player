#include "serialgenerator.h"
#include <QCryptographicHash>
#include <QSettings>
SerialGenerator::SerialGenerator(QObject *parent)
    : QObject{parent}
{

}
QString SerialGenerator::encrypt(const QString& id)
{
    // Get the prefix and suffix of the ID
    QString prefix = id.left(4);
    QString suffix = id.right(4);

    // Create the mixed key by concatenating the first 4 characters from the prefix and the last 4 characters from the suffix
    QString key = prefix + suffix;

    // Convert the ID to a byte array
    QByteArray idBytes = QByteArray::fromHex(id.toLatin1());

    // Encrypt the ID using XOR with the key
    QByteArray encrypted;
    for (int i = 0; i < idBytes.size(); i++)
    {
        encrypted.append(idBytes.at(i) ^ key.at(i % key.size()).toLatin1());
    }

    // Convert the encrypted bytes to hex and truncate to 16 characters
    QString encryptedHex = encrypted.toHex();

    // Split the encrypted ID into groups of four characters separated by hyphens
    QString formattedEncrypted;
    for (int i = 0; i < encryptedHex.size(); i += 4)
    {
        formattedEncrypted += encryptedHex.mid(i, 4) + '-';
    }
    formattedEncrypted.chop(1); // Remove the last hyphen

    return formattedEncrypted;
}

QString SerialGenerator::decrypt(const QString& encryptedId, const QString& originalId)
{
    // Remove hyphens from the encrypted ID
    QString encryptedHex = encryptedId;
    encryptedHex.remove('-');


    // Get the prefix and suffix of the original ID
    QString prefix = originalId.left(4);
    QString suffix = originalId.right(4);

    // Create the mixed key by concatenating the first 4 characters from the prefix and the last 4 characters from the suffix
    QString key = prefix + suffix;

    // Convert the encrypted ID to a byte array
    QByteArray encryptedBytes = QByteArray::fromHex(encryptedHex.toLatin1());

    // Decrypt the ID using XOR with the key
    QByteArray decrypted;
    for (int i = 0; i < encryptedBytes.size(); i++)
    {
        decrypted.append(encryptedBytes.at(i) ^ key.at(i % key.size()).toLatin1());
    }

    // Convert the decrypted bytes to hex and format it as "XXXX-XXXX-XXXX-XXXX-XXXX"
    QString decryptedHex = decrypted.toHex();
    decryptedHex.insert(4, '-');
    decryptedHex.insert(9, '-');
    decryptedHex.insert(14, '-');
    decryptedHex.insert(19, '-');

    return decryptedHex;
}
bool SerialGenerator::checkDecryption(const QString& encryptedId, const QString& originalId)
{
    QString decryptedId = decrypt(encryptedId, originalId);
    return decryptedId == originalId;
}
void  SerialGenerator::activate(const QString &encryptedId){
    // Store the encrypted ID using Qt Settings
    QSettings settings;
    settings.setValue("encryptedId", encryptedId);

}
QString SerialGenerator::getEncryptedId()
{
    // Retrieve the encrypted ID from Qt Settings
    QSettings settings;
    return settings.value("encryptedId").toString();
}
