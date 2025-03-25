#include "mainwindow.hpp"
#include <QFileDialog>
#include <QStandardPaths>
#include <QRegularExpression>
#include <QDebug>
#include <QQmlContext>
#include <QVBoxLayout>
#include <QScreen>
#include <QGuiApplication>
#include <QStyle>
#include <QResizeEvent>

MainWindow::MainWindow(QWidget *parent)
    : QWidget(parent)
    , m_quickView(new QQuickView)
    , m_currentProcess(nullptr)
    , m_downloadPath(m_db.getSetting(QLatin1String("download_path"),
        QStandardPaths::writableLocation(QStandardPaths::DownloadLocation)))
    , m_container(nullptr)
{
    setupWindow();
    setupQml();
}

MainWindow::~MainWindow()
{
    delete m_quickView;
    if (m_currentProcess) {
        m_currentProcess->terminate();
        delete m_currentProcess;
    }
}

void MainWindow::setupWindow()
{
    setWindowTitle(QLatin1String("Velo Downloader"));
    setWindowFlags(Qt::Window | Qt::FramelessWindowHint);  // Add FramelessWindowHint
    setMinimumSize(800, 621);

    // Create container for QQuickView
    m_container = QWidget::createWindowContainer(m_quickView, this);
    m_container->setMinimumSize(800, 600);
    m_container->setFocusPolicy(Qt::StrongFocus);

    // Setup layout
    auto layout = new QVBoxLayout(this);
    layout->setContentsMargins(0, 0, 0, 0);
    layout->setSpacing(0);
    layout->addWidget(m_container);

    // Center on screen
    if (QScreen *screen = QGuiApplication::primaryScreen()) {
        const QRect availableGeometry = screen->availableGeometry();
        setGeometry(QStyle::alignedRect(Qt::LeftToRight, Qt::AlignCenter, size(), availableGeometry));
    }
}

void MainWindow::setupQml()
{
    // Setup QML context and expose C++ objects to QML
    QQmlContext *context = m_quickView->rootContext();
    context->setContextProperty(QLatin1String("mainWindow"), this);
    
    // Load your QML file
    m_quickView->setSource(QUrl(QLatin1String("qrc:/qml/main.qml")));
}

QString MainWindow::downloadPath() const {
    return m_downloadPath;
}

void MainWindow::setDownloadPath(const QString &path) {
    if (m_downloadPath != path) {
        m_downloadPath = path;
        m_db.setSetting(QLatin1String("download_path"), path);
        emit downloadPathChanged(path);
        qDebug() << QLatin1String("Download path updated:") << path;
    }
}

void MainWindow::startDownload(const QString &url) {
    if (url.isEmpty()) {
        qWarning() << QLatin1String("No URL provided");
        return;
    }
    
    qInfo() << QLatin1String("Starting download:") << url;
    
    QString ytdlpPath = qApp->applicationDirPath() + QLatin1String("/bin/yt-dlp.exe");
    if (!QFile::exists(ytdlpPath)) {
        QString error = QLatin1String("yt-dlp.exe not found");
        qWarning() << error;
        emit progressChanged(QLatin1String("Error: ") + error, 0);
        return;
    }
    
    if (m_currentProcess) {
        delete m_currentProcess;
    }
    
    m_currentProcess = new QProcess(this);
    
    connect(m_currentProcess, &QProcess::readyReadStandardOutput, this, [this]() {
        QString output = QString::fromUtf8(m_currentProcess->readAllStandardOutput());
        QRegularExpression progressRegex(QLatin1String("\\[(download)\\].*?(\\d+\\.?\\d*)%"));
        auto match = progressRegex.match(output);
        
        if (match.hasMatch()) {
            double progress = match.captured(2).toDouble();
            emit progressChanged(QLatin1String("Downloading"), progress);
        }
        else if (output.contains(QLatin1String("[ExtractAudio]"))) {
            emit progressChanged(QLatin1String("Extracting Audio"), -1);
        }
    });
    
    connect(m_currentProcess, &QProcess::finished, this, [this](int exitCode) {
        if (exitCode == 0) {
            emit progressChanged(QLatin1String("Completed"), 100);
            m_db.addDownload(QLatin1String("download"), m_downloadPath, QLatin1String("url"));
            emit downloadsChanged();
        } else {
            emit progressChanged(QLatin1String("Error"), 0);
        }
    });
    
    QStringList arguments;
    arguments << url << QLatin1String("-P") << m_downloadPath << QLatin1String("--newline");
    m_currentProcess->start(ytdlpPath, arguments);
}

void MainWindow::cancelDownload() {
    if (m_currentProcess) {
        m_currentProcess->terminate();
        emit progressChanged(QLatin1String("Cancelled"), 0);
    }
}

void MainWindow::selectFolder() {
    QString dir = QFileDialog::getExistingDirectory(this, 
        tr("Select Download Directory"),
        m_downloadPath,
        QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
        
    if (!dir.isEmpty()) {
        setDownloadPath(dir);
    }
}

QVariantList MainWindow::getDownloads() {
    return m_db.getDownloads();
}

void MainWindow::logQml(const QString &message) {
    qInfo() << QLatin1String("QML:") << message;
}

void MainWindow::logQmlError(const QString &component, const QString &error) {
    qWarning() << QLatin1String("QML Error in") << component << QLatin1String(":") << error;
}

void MainWindow::resizeEvent(QResizeEvent *event)
{
    QWidget::resizeEvent(event);
    if (m_container) {
        m_container->resize(event->size());
    }
}

void MainWindow::changeEvent(QEvent *event)
{
    QWidget::changeEvent(event);
    if (event->type() == QEvent::WindowStateChange) {
        if (m_container) {
            m_container->resize(size());
        }
    }
}
void MainWindow::closeApp() {
    close();
    QCoreApplication::quit();
}

void MainWindow::startWindowDrag() {
    if (auto win = window()->windowHandle()) {
        win->startSystemMove();
    }
}