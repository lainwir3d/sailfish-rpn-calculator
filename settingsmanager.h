#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>

class SettingsManager : public QObject
{
    Q_OBJECT
public:
    explicit SettingsManager(QObject *parent = 0);
    Q_INVOKABLE void setVibration(int on);
    Q_INVOKABLE int vibration();
    Q_INVOKABLE void setAngleUnit(QString unit);
    Q_INVOKABLE QString angleUnit();

private:
    QSettings * settings;

signals:

public slots:

};

#endif // SETTINGSMANAGER_H
