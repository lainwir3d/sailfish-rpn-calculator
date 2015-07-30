#include "settingsmanager.h"

SettingsManager::SettingsManager(QObject *parent) :
    QObject(parent)
{
    settings = new QSettings("harbour-rpncalc", "harbour-rpncalc");

    if(settings->value("vibration") == QVariant()) settings->setValue("vibration", 1);
    if(settings->value("angle_unit") == QVariant()) settings->setValue("angle_unit", QString("DEG"));
    if(settings->value("reprFloatPrecision") == QVariant()) settings->setValue("reprFloatPrecision", 9);

}

void SettingsManager::setVibration(int on)
{
    if(on) settings->setValue("vibration", 1);
    else settings->setValue("vibration", 0);
}

int SettingsManager::vibration()
{
    return settings->value("vibration").toInt();
}

void SettingsManager::setAngleUnit(QString unit)
{
    if(unit != settings->value("angle_unit").toString()){
        settings->setValue("angle_unit", unit);
        emit angleUnitChanged();
    }
}

QString SettingsManager::angleUnit()
{
    return settings->value("angle_unit").toString();
}

void SettingsManager::setReprFloatPrecision(int prec)
{
    if(prec != reprFloatPrecision()){
        settings->setValue("reprFloatPrecision", prec);
        emit reprFloatPrecisionChanged();
    }
}
