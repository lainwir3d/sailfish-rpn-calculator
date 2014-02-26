#include "settingsmanager.h"

SettingsManager::SettingsManager(QObject *parent) :
    QObject(parent)
{
    settings = new QSettings("harbour-rpncalc", "harbour-rpncalc");

    if(settings->value("vibration") == QVariant()) settings->setValue("vibration", 1);
    if(settings->value("angle_unit") == QVariant()) settings->setValue("angle_unit", QString("DEG"));


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
    settings->setValue("angle_unit", unit);
}

QString SettingsManager::angleUnit()
{
    return settings->value("angle_unit").toString();
}
