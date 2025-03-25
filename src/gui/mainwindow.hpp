// mainwindow.hpp
#pragma once

#include <QWidget>
#include <QQuickView>
#include <QQmlEngine>
#include <QProcess>
#include "database/dbmanager.hpp"
#include <QTimer>
#include <QJSValue>

class MainWindow : public QWidget
{
    Q_OBJECT
    Q_PROPERTY(QString downloadPath READ downloadPath WRITE setDownloadPath NOTIFY downloadPathChanged)

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow() override;
    QString downloadPath() const;
    void setDownloadPath(const QString &path);

public slots:
    void startDownload(const QString &url);
    void cancelDownload();
    void selectFolder();
    QVariantList getDownloads();
    void logQml(const QString &message);
    void logQmlError(const QString &component, const QString &error);
    void closeApp();
    void startWindowDrag();

signals:
    void downloadsChanged();
    void progressChanged(const QString &status, double percent);
    void downloadPathChanged(const QString &path);

protected:
    void resizeEvent(QResizeEvent *event) override;
    void changeEvent(QEvent *event) override;

private:
    void setupWindow();
    void setupQml();

    QQuickView *m_quickView;
    DatabaseManager m_db;
    QString m_downloadPath;
    QProcess *m_currentProcess;
    QWidget *m_container;
    QJSValue m_currentDialogCallback;
};