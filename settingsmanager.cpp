#include "settingsmanager.h"

SettingsManager::SettingsManager(QObject *parent) :
    QObject(parent)
{
    settings = new QSettings("harbour-rpncalc", "harbour-rpncalc");

    if(settings->value("vibration") == QVariant()) settings->setValue("vibration", 1);
    if(settings->value("angle_unit") == QVariant()) settings->setValue("angle_unit", QString("DEG"));
    if(settings->value("reprFloatPrecision") == QVariant()) settings->setValue("reprFloatPrecision", 9);

    if(settings->value("symbolicMode") == QVariant()) settings->setValue("symbolicMode", true);
    if(settings->value("rationalMode") == QVariant()) settings->setValue("rationalMode", true);
    if(settings->value("autoSimplify") == QVariant()) settings->setValue("autoSimplify", true);

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

void SettingsManager::setAutoSimplify(bool enabled)
{
    if(enabled != autoSimplify()){
        settings->setValue("autoSimplify", enabled);
        emit autoSimplifyChanged();
    }
}

void SettingsManager::setSymbolicMode(bool enabled)
{
    if(enabled != symbolicMode()){
        settings->setValue("symbolicMode", enabled);
        emit symbolicModeChanged();
    }
}

void SettingsManager::setRationalMode(bool enabled)
{
    if(enabled != rationalMode()){
        settings->setValue("rationalMode", enabled);
        emit rationalModeChanged();
    }
}
