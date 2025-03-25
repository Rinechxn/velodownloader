#include "dbmanager.hpp"
#include <QStandardPaths>
#include <QDir>
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>

DatabaseManager::DatabaseManager() {
    QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(appDataPath);
    
    m_settingsDbPath = appDataPath + QStringLiteral("/settings.dat");
    m_historyDbPath = appDataPath + QStringLiteral("/history.dat");
    
    m_settingsDb = QSqlDatabase::addDatabase(QStringLiteral("QSQLITE"), QStringLiteral("settings"));
    m_settingsDb.setDatabaseName(m_settingsDbPath);
    
    m_historyDb = QSqlDatabase::addDatabase(QStringLiteral("QSQLITE"), QStringLiteral("history"));
    m_historyDb.setDatabaseName(m_historyDbPath);
    
    initSettingsDb();
    initHistoryDb();
}

QString DatabaseManager::getSetting(const QString &key, const QString &defaultValue) {
    if (!m_settingsDb.open()) 
        return defaultValue;
    
    QSqlQuery query(m_settingsDb);
    query.prepare(QStringLiteral("SELECT value FROM settings WHERE key = ?"));
    query.addBindValue(key);
    
    if (query.exec() && query.next()) {
        QString value = query.value(0).toString();
        m_settingsDb.close();
        return value;
    }
    
    m_settingsDb.close();
    return defaultValue;
}

void DatabaseManager::initSettingsDb() {
    if (!m_settingsDb.open()) return;
    
    QSqlQuery query(m_settingsDb);
    query.exec(QLatin1String("CREATE TABLE IF NOT EXISTS settings ("
              "key TEXT PRIMARY KEY, "
              "value TEXT NOT NULL)"));
    
    m_settingsDb.close();
}

void DatabaseManager::initHistoryDb() {
    if (!m_historyDb.open()) return;
    
    QSqlQuery query(m_historyDb);
    query.exec(QLatin1String("CREATE TABLE IF NOT EXISTS downloads ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "filename TEXT NOT NULL, "
              "path TEXT NOT NULL, "
              "url TEXT NOT NULL, "
              "timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)"));
    
    m_historyDb.close();
}

void DatabaseManager::setSetting(const QString &key, const QString &value) {
    if (!m_settingsDb.open()) return;
    
    QSqlQuery query(m_settingsDb);
    query.prepare(QStringLiteral("INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)"));
    query.addBindValue(key);
    query.addBindValue(value);
    query.exec();
    
    m_settingsDb.close();
}

void DatabaseManager::addDownload(const QString &name, const QString &path, const QString &url) {
    if (!m_historyDb.open()) return;
    
    QSqlQuery query(m_historyDb);
    query.prepare(QStringLiteral("INSERT INTO downloads (filename, path, url) VALUES (?, ?, ?)"));
    query.addBindValue(name);
    query.addBindValue(path);
    query.addBindValue(url);
    query.exec();
    
    m_historyDb.close();
}

QVariantList DatabaseManager::getDownloads() {
    QVariantList downloads;
    if (!m_historyDb.open()) return downloads;
    
    QSqlQuery query(m_historyDb);
    query.exec(QStringLiteral("SELECT filename, path, url FROM downloads ORDER BY timestamp DESC"));
    
    while (query.next()) {
        QVariantMap download;
        download[QStringLiteral("filename")] = query.value(0).toString();
        download[QStringLiteral("path")] = query.value(1).toString();
        download[QStringLiteral("url")] = query.value(2).toString();
        downloads.append(download);
    }
    
    m_historyDb.close();
    return downloads;
}
