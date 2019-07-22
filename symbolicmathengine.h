#ifndef SYMBOLICMATHENGINE_H
#define SYMBOLICMATHENGINE_H

#include <QObject>
#include "symbolicexpr.h"

#include <stdexcept>

/*
class Erreur: public exception
{
public:
    Erreur() throw() {}

     virtual const char* what() const throw()
     {
         return m_phrase.c_str();
     }

    virtual ~Erreur() throw()
    {}
};
*/

class SymbolicMathEngine : public QObject
{
    Q_OBJECT
    Q_ENUMS(Features)
public:
    explicit SymbolicMathEngine(QObject *parent = nullptr);

    enum Feature {
        NoFeatures = 0,
        StringConversionFeature = 1,
        RationalFeature = 2,
        SymbolicFeature = 4,
        //BasicSettings = 8,
        //ThumbEqualizer = 16,
        //Telephony = 32,
        //TTS = 64,
        //StreetMode = 128,
        //FlightMode = 256,
        //Preset = 512,
        //PresetMultiDevice = 1024,
        //AutoNc = 2048,
        //NcDuringCall = 4096,
        //USBAudio = 8192,
        //USBAudio51 = 16384,
        //ConcertHallSurround = 32768,
        //BluetoothDelay = 65536,
        //BluetoothMultiPoint = 131072,
        //Sport = 262144,
        //BatteryNotification = 524288
    };
    Q_DECLARE_FLAGS(Features, Feature)

    virtual bool operandValid(QString o) {}
    virtual SymbolicExpr * strToExpr(QString e, bool rationalMode = false) { SymbolicExpr * expr = new SymbolicExpr(); return expr;}
    virtual Features features() { return NoFeatures; }
    virtual SymbolicExpr * addSymbol(QString e) {}
    virtual SymbolicExpr * constants(QString e) {}

signals:

public slots:
};


Q_DECLARE_OPERATORS_FOR_FLAGS(SymbolicMathEngine::Features)

#endif // SYMBOLICMATHENGINE_H
