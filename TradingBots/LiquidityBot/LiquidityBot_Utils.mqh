//+------------------------------------------------------------------+
//|                                             LiquidityBot_Utils.mqh |
//|                        Copyright 2024, Advanced Trading Systems |
//|                                           https://www.example.com |
//+------------------------------------------------------------------+
#property copyright "2024, Advanced Trading Systems"
#property link      "https://www.example.com"
#property version   "3.03"

//+------------------------------------------------------------------+
//| Utility functions for LiquidityBot v3.03                        |
//+------------------------------------------------------------------+

//--- Color constants for drawing
#define COLOR_SUPPORT    clrBlue
#define COLOR_RESISTANCE clrRed
#define COLOR_SWING_HIGH clrOrange
#define COLOR_SWING_LOW  clrGreen

//--- Structure for liquidity levels
struct LiquidityLevel
{
    double price;
    datetime time;
    int touchCount;
    double totalVolume;
    bool isResistance;
    double strength;
};

//--- Structure for performance metrics
struct PerformanceMetrics
{
    double winRate;
    double profitFactor;
    double sharpeRatio;
    double maxDrawdown;
    double recoveryFactor;
    int totalTrades;
    double avgWin;
    double avgLoss;
    double expectancy;
};

//+------------------------------------------------------------------+
//| Calculate Sharpe Ratio                                           |
//+------------------------------------------------------------------+
double CalculateSharpeRatio(const double &returns[], int period = 252)
{
    if (ArraySize(returns) < 2) return 0.0;
    
    double mean = 0;
    double variance = 0;
    int size = ArraySize(returns);
    
    // Calculate mean return
    for (int i = 0; i < size; i++) {
        mean += returns[i];
    }
    mean /= size;
    
    // Calculate variance
    for (int i = 0; i < size; i++) {
        variance += MathPow(returns[i] - mean, 2);
    }
    variance /= (size - 1);
    
    double stdDev = MathSqrt(variance);
    if (stdDev == 0) return 0.0;
    
    // Annualize and calculate Sharpe ratio (assuming risk-free rate = 0)
    double annualizedReturn = mean * period;
    double annualizedStdDev = stdDev * MathSqrt(period);
    
    return annualizedReturn / annualizedStdDev;
}

//+------------------------------------------------------------------+
//| Calculate Recovery Factor                                         |
//+------------------------------------------------------------------+
double CalculateRecoveryFactor(double totalReturn, double maxDrawdown)
{
    if (maxDrawdown == 0) return 0.0;
    return totalReturn / maxDrawdown;
}

//+------------------------------------------------------------------+
//| Advanced Moving Average calculation                               |
//+------------------------------------------------------------------+
double CalculateAdvancedMA(const double &prices[], int period, int maType, int shift = 0)
{
    if (ArraySize(prices) < period + shift) return 0.0;
    
    switch (maType) {
        case 0: // Simple MA
            return CalculateSMA(prices, period, shift);
        case 1: // Exponential MA
            return CalculateEMA(prices, period, shift);
        case 2: // Weighted MA
            return CalculateWMA(prices, period, shift);
        case 3: // Hull MA
            return CalculateHMA(prices, period, shift);
        default:
            return CalculateSMA(prices, period, shift);
    }
}

//+------------------------------------------------------------------+
//| Simple Moving Average                                            |
//+------------------------------------------------------------------+
double CalculateSMA(const double &prices[], int period, int shift = 0)
{
    double sum = 0;
    for (int i = shift; i < period + shift; i++) {
        sum += prices[i];
    }
    return sum / period;
}

//+------------------------------------------------------------------+
//| Exponential Moving Average                                       |
//+------------------------------------------------------------------+
double CalculateEMA(const double &prices[], int period, int shift = 0)
{
    if (ArraySize(prices) < period + shift) return 0.0;
    
    double multiplier = 2.0 / (period + 1);
    double ema = CalculateSMA(prices, period, shift + period - 1);
    
    for (int i = shift + period - 2; i >= shift; i--) {
        ema = (prices[i] * multiplier) + (ema * (1 - multiplier));
    }
    
    return ema;
}

//+------------------------------------------------------------------+
//| Weighted Moving Average                                          |
//+------------------------------------------------------------------+
double CalculateWMA(const double &prices[], int period, int shift = 0)
{
    double sum = 0;
    double weightSum = 0;
    
    for (int i = 0; i < period; i++) {
        int weight = period - i;
        sum += prices[shift + i] * weight;
        weightSum += weight;
    }
    
    return (weightSum > 0) ? sum / weightSum : 0;
}

//+------------------------------------------------------------------+
//| Hull Moving Average                                              |
//+------------------------------------------------------------------+
double CalculateHMA(const double &prices[], int period, int shift = 0)
{
    int halfPeriod = period / 2;
    int sqrtPeriod = (int)MathRound(MathSqrt(period));
    
    double wma1 = CalculateWMA(prices, halfPeriod, shift);
    double wma2 = CalculateWMA(prices, period, shift);
    
    // Create difference array for final WMA
    double diff[];
    ArrayResize(diff, sqrtPeriod);
    
    for (int i = 0; i < sqrtPeriod; i++) {
        double w1 = CalculateWMA(prices, halfPeriod, shift + i);
        double w2 = CalculateWMA(prices, period, shift + i);
        diff[i] = 2 * w1 - w2;
    }
    
    return CalculateWMA(diff, sqrtPeriod, 0);
}

//+------------------------------------------------------------------+
//| Calculate Relative Strength Index                                |
//+------------------------------------------------------------------+
double CalculateRSI(const double &prices[], int period, int shift = 0)
{
    if (ArraySize(prices) < period + shift + 1) return 50.0;
    
    double avgGain = 0;
    double avgLoss = 0;
    
    // Initial calculation
    for (int i = 1; i <= period; i++) {
        double change = prices[shift + period - i] - prices[shift + period - i + 1];
        if (change > 0) {
            avgGain += change;
        } else {
            avgLoss += MathAbs(change);
        }
    }
    
    avgGain /= period;
    avgLoss /= period;
    
    if (avgLoss == 0) return 100.0;
    
    double rs = avgGain / avgLoss;
    return 100.0 - (100.0 / (1.0 + rs));
}

//+------------------------------------------------------------------+
//| Calculate Average True Range                                     |
//+------------------------------------------------------------------+
double CalculateATR(const double &highs[], const double &lows[], const double &closes[], int period, int shift = 0)
{
    if (ArraySize(highs) < period + shift + 1) return 0.0;
    
    double atr = 0;
    
    for (int i = 1; i <= period; i++) {
        int idx = shift + i;
        double tr1 = highs[idx] - lows[idx];
        double tr2 = MathAbs(highs[idx] - closes[idx - 1]);
        double tr3 = MathAbs(lows[idx] - closes[idx - 1]);
        
        atr += MathMax(tr1, MathMax(tr2, tr3));
    }
    
    return atr / period;
}

//+------------------------------------------------------------------+
//| Identify Market Sessions                                         |
//+------------------------------------------------------------------+
int GetCurrentSession()
{
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    int hour = dt.hour;
    
    // Return session codes:
    // 0 = Asian (22-8 GMT)
    // 1 = London (8-17 GMT)
    // 2 = NY (13-22 GMT)
    // 3 = Overlap (13-17 GMT)
    
    if (hour >= 13 && hour < 17) return 3; // London-NY Overlap
    if (hour >= 8 && hour < 17) return 1;  // London
    if (hour >= 13 && hour < 22) return 2; // NY
    return 0; // Asian
}

//+------------------------------------------------------------------+
//| Calculate session volatility multiplier                          |
//+------------------------------------------------------------------+
double GetSessionVolatilityMultiplier()
{
    int session = GetCurrentSession();
    
    switch (session) {
        case 0: return 0.7; // Asian - lower volatility
        case 1: return 1.0; // London - normal volatility
        case 2: return 1.0; // NY - normal volatility
        case 3: return 1.3; // Overlap - higher volatility
        default: return 1.0;
    }
}

//+------------------------------------------------------------------+
//| Advanced Fibonacci calculation                                    |
//+------------------------------------------------------------------+
double CalculateFibonacciLevel(double high, double low, double ratio)
{
    return low + (high - low) * ratio;
}

//+------------------------------------------------------------------+
//| Get Fibonacci retracement levels                                 |
//+------------------------------------------------------------------+
void GetFibonacciLevels(double high, double low, double &levels[])
{
    double ratios[] = {0.236, 0.382, 0.500, 0.618, 0.786};
    ArrayResize(levels, ArraySize(ratios));
    
    for (int i = 0; i < ArraySize(ratios); i++) {
        levels[i] = CalculateFibonacciLevel(high, low, ratios[i]);
    }
}

//+------------------------------------------------------------------+
//| Calculate position correlation                                    |
//+------------------------------------------------------------------+
double CalculatePositionCorrelation(string symbol1, string symbol2, int period = 20)
{
    double prices1[], prices2[];
    ArrayResize(prices1, period);
    ArrayResize(prices2, period);
    
    // Get closing prices for both symbols
    for (int i = 0; i < period; i++) {
        prices1[i] = iClose(symbol1, Period(), i);
        prices2[i] = iClose(symbol2, Period(), i);
    }
    
    return CalculateCorrelation(prices1, prices2);
}

//+------------------------------------------------------------------+
//| Calculate correlation coefficient                                 |
//+------------------------------------------------------------------+
double CalculateCorrelation(const double &x[], const double &y[])
{
    int n = MathMin(ArraySize(x), ArraySize(y));
    if (n < 2) return 0.0;
    
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0, sumY2 = 0;
    
    for (int i = 0; i < n; i++) {
        sumX += x[i];
        sumY += y[i];
        sumXY += x[i] * y[i];
        sumX2 += x[i] * x[i];
        sumY2 += y[i] * y[i];
    }
    
    double numerator = n * sumXY - sumX * sumY;
    double denominator = MathSqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));
    
    return (denominator != 0) ? numerator / denominator : 0.0;
}

//+------------------------------------------------------------------+
//| Advanced trend strength calculation                               |
//+------------------------------------------------------------------+
double CalculateTrendStrength(const double &prices[], int period)
{
    if (ArraySize(prices) < period + 1) return 0.0;
    
    double firstPrice = prices[period - 1];
    double lastPrice = prices[0];
    double linearRegression = 0;
    double actualMovement = lastPrice - firstPrice;
    
    // Calculate linear regression slope
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    
    for (int i = 0; i < period; i++) {
        double x = i;
        double y = prices[period - 1 - i];
        
        sumX += x;
        sumY += y;
        sumXY += x * y;
        sumX2 += x * x;
    }
    
    double slope = (period * sumXY - sumX * sumY) / (period * sumX2 - sumX * sumX);
    double trendStrength = MathAbs(slope * period / firstPrice) * 100;
    
    return MathMin(trendStrength, 100);
}

//+------------------------------------------------------------------+
//| Market structure analysis                                        |
//+------------------------------------------------------------------+
int AnalyzeMarketStructure(const double &highs[], const double &lows[], int lookback = 50)
{
    // Return values:
    // 1 = Uptrend (Higher Highs, Higher Lows)
    // -1 = Downtrend (Lower Highs, Lower Lows)
    // 0 = Sideways/Undefined
    
    if (ArraySize(highs) < lookback || ArraySize(lows) < lookback) return 0;
    
    int higherHighs = 0, lowerHighs = 0;
    int higherLows = 0, lowerLows = 0;
    
    for (int i = 1; i < lookback; i++) {
        if (highs[i-1] > highs[i]) higherHighs++;
        else lowerHighs++;
        
        if (lows[i-1] > lows[i]) higherLows++;
        else lowerLows++;
    }
    
    double hhPercentage = (double)higherHighs / (lookback - 1) * 100;
    double hlPercentage = (double)higherLows / (lookback - 1) * 100;
    
    if (hhPercentage > 60 && hlPercentage > 60) return 1;  // Uptrend
    if (hhPercentage < 40 && hlPercentage < 40) return -1; // Downtrend
    
    return 0; // Sideways
}

//+------------------------------------------------------------------+
//| Volume analysis                                                  |
//+------------------------------------------------------------------+
double CalculateVolumeStrength(const long &volumes[], int period)
{
    if (ArraySize(volumes) < period) return 1.0;
    
    double avgVolume = 0;
    for (int i = 1; i < period; i++) {
        avgVolume += volumes[i];
    }
    avgVolume /= (period - 1);
    
    if (avgVolume > 0) {
        return volumes[0] / avgVolume;
    }
    
    return 1.0;
}

//+------------------------------------------------------------------+
//| News impact assessment (placeholder)                             |
//+------------------------------------------------------------------+
int GetNewsImpact(datetime newsTime, datetime currentTime)
{
    // Return impact levels:
    // 0 = No impact
    // 1 = Low impact
    // 2 = Medium impact
    // 3 = High impact
    
    int timeDiff = (int)MathAbs(currentTime - newsTime) / 60; // Minutes
    
    if (timeDiff <= 15) return 3;      // High impact - within 15 minutes
    if (timeDiff <= 30) return 2;      // Medium impact - within 30 minutes
    if (timeDiff <= 60) return 1;      // Low impact - within 1 hour
    
    return 0; // No impact
}

//+------------------------------------------------------------------+
//| Money management utilities                                        |
//+------------------------------------------------------------------+
double CalculateKellyCriterion(double winRate, double avgWin, double avgLoss)
{
    if (avgLoss <= 0 || winRate <= 0 || winRate >= 1) return 0.0;
    
    double lossRate = 1 - winRate;
    double payoffRatio = avgWin / avgLoss;
    
    return (winRate * payoffRatio - lossRate) / payoffRatio;
}

//+------------------------------------------------------------------+
//| Risk of Ruin calculation                                         |
//+------------------------------------------------------------------+
double CalculateRiskOfRuin(double winRate, double riskPerTrade, double winLossRatio)
{
    if (winRate <= 0 || winRate >= 1 || riskPerTrade <= 0) return 1.0;
    
    double lossRate = 1 - winRate;
    double a = lossRate / winRate;
    double b = winLossRatio;
    
    if (a * b == 1) return 1.0;
    
    double numerator = MathPow(a / b, 1.0 / riskPerTrade) - 1;
    double denominator = MathPow(a / b, 1.0 / riskPerTrade) - a / b;
    
    return MathMax(0, MathMin(1, numerator / denominator));
}

//+------------------------------------------------------------------+
//| Utility function to format time                                  |
//+------------------------------------------------------------------+
string FormatTime(datetime time)
{
    MqlDateTime dt;
    TimeToStruct(time, dt);
    
    return StringFormat("%04d.%02d.%02d %02d:%02d:%02d",
                       dt.year, dt.mon, dt.day, dt.hour, dt.min, dt.sec);
}

//+------------------------------------------------------------------+
//| Utility function to format price                                 |
//+------------------------------------------------------------------+
string FormatPrice(double price, int digits = 5)
{
    return DoubleToString(price, digits);
}

//+------------------------------------------------------------------+
//| Draw support/resistance levels                                   |
//+------------------------------------------------------------------+
void DrawLiquidityLevel(double price, datetime time, bool isResistance, string prefix = "Level")
{
    string objectName = prefix + "_" + TimeToString(time, TIME_DATE | TIME_MINUTES);
    
    ObjectCreate(0, objectName, OBJ_HLINE, 0, time, price);
    ObjectSetInteger(0, objectName, OBJPROP_COLOR, isResistance ? COLOR_RESISTANCE : COLOR_SUPPORT);
    ObjectSetInteger(0, objectName, OBJPROP_STYLE, STYLE_DASH);
    ObjectSetInteger(0, objectName, OBJPROP_WIDTH, 1);
    ObjectSetString(0, objectName, OBJPROP_TOOLTIP, 
                   (isResistance ? "Resistance: " : "Support: ") + FormatPrice(price));
}

//+------------------------------------------------------------------+
//| Clean up old objects                                            |
//+------------------------------------------------------------------+
void CleanupOldObjects(string prefix, int maxAge = 86400)
{
    datetime currentTime = TimeCurrent();
    
    for (int i = ObjectsTotal(0) - 1; i >= 0; i--) {
        string objName = ObjectName(0, i);
        if (StringFind(objName, prefix) == 0) {
            datetime objTime = (datetime)ObjectGetInteger(0, objName, OBJPROP_TIME);
            if (currentTime - objTime > maxAge) {
                ObjectDelete(0, objName);
            }
        }
    }
}