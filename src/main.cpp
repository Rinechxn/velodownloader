#include <QApplication>
#include <QQuickStyle>
#include "gui/framelesshelper.hpp"
#include "mainwindow.hpp"

int main(int argc, char *argv[]) {
#if (QT_VERSION < QT_VERSION_CHECK(6, 0, 0))
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
#endif
    QQuickStyle::setStyle(QLatin1String("Basic"));
    QApplication app(argc, argv);
    FramelessHelper helper;

    MainWindow window;
    helper.setFramelessWindows({&window});
    helper.setTitlebarHeight(32);
    window.show();

    return app.exec();
}