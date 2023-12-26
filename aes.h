#ifndef AES_H
#define AES_H

#include <QObject>
#include <QVariant>
#include <QtConcurrent>
#include <QFileInfo>
class AES : public QObject
{
    Q_OBJECT
public:
    explicit AES(QObject *parent = nullptr);
    Q_INVOKABLE QVariant encrypt(const QString& filePath, QByteArray key);
    Q_INVOKABLE QVariant decrypt(const QString& filePath, QByteArray key);
    Q_INVOKABLE QFuture<bool> encryptVideo(const QString& inputFilePath, const QString& outputFilePath,const QByteArray& encryptionKey);
    Q_INVOKABLE QFuture<bool> decryptVideo(const QString& inputFilePath, const QString& outputFilePath,const QByteArray& encryptionKey);
    QString createCustomPath();
    Q_INVOKABLE QString getoutputFullFilename() const;
    void setoutputFullFilename(const QString& newFilename);
    void createTempDir(const QString &templatePath);
    ~AES();
signals:
    void encryptionVideoProgressChanged(int progress);
    void preparingVideoProgressChanged();
    void decryptionVideoFinished(const QString &fullpathname);
    void decryptionProjectFinished(const QString &projecFile);
private:
    QTemporaryDir *tempDir;
    QString outputFullFilename;
    QString m_customPath;
};

#endif // AES_H
