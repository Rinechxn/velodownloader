#pragma once
#include <QString>
#include <QSqlDatabase>
#include <QVariantList>

class DatabaseManager {
    public:
        DatabaseManager();
        QString getSetting(const QString &key, const QString &defaultValue = {});  // Use {} instead of QString()
        void setSetting(const QString &key, const QString &value);
        void addDownload(const QString &name, const QString &path, const QString &url);
        QVariantList getDownloads();
    
    private:
        void initSettingsDb();
        void initHistoryDb();
        QString m_settingsDbPath;  // Remove explicit initialization
        QString m_historyDbPath;   // Remove explicit initialization
        QSqlDatabase m_settingsDb;
        QSqlDatabase m_historyDb;
    };