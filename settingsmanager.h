#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>

class SettingsManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString angleUnit READ angleUnit WRITE setAngleUnit NOTIFY angleUnitChanged)
    Q_PROPERTY(int reprFloatPrecision READ reprFloatPrecision WRITE setReprFloatPrecision NOTIFY reprFloatPrecisionChanged())
    Q_PROPERTY(bool autoSimplify READ autoSimplify WRITE setAutoSimplify NOTIFY autoSimplifyChanged)
    Q_PROPERTY(bool symbolicMode READ symbolicMode WRITE setSymbolicMode NOTIFY symbolicModeChanged)

public:
    explicit SettingsManager(QObject *parent = 0);
    Q_INVOKABLE void setVibration(int on);
    Q_INVOKABLE int vibration();
    void setAngleUnit(QString unit);
    QString angleUnit();

    int reprFloatPrecision() { return settings->value("reprFloatPrecision").toInt(); }
    void setReprFloatPrecision(int prec);

    bool autoSimplify() { return settings->value("autoSimplify").toBool(); }
    void setAutoSimplify(bool enabled);

    bool symbolicMode() { return settings->value("symbolicMode").toBool(); }
    void setSymbolicMode(bool enabled);

private:
    QSettings * settings;

signals:
    void angleUnitChanged();
    void reprFloatPrecisionChanged();
    void autoSimplifyChanged();
    void symbolicModeChanged();

public slots:

};

#endif // SETTINGSMANAGER_H
