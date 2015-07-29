#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>

class SettingsManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString angleUnit READ angleUnit WRITE setAngleUnit NOTIFY angleUnitChanged)
public:
    explicit SettingsManager(QObject *parent = 0);
    Q_INVOKABLE void setVibration(int on);
    Q_INVOKABLE int vibration();
    void setAngleUnit(QString unit);
    QString angleUnit();

private:
    QSettings * settings;

signals:
    void angleUnitChanged();

public slots:

};

#endif // SETTINGSMANAGER_H
