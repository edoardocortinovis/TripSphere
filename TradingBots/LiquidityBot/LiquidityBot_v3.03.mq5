//+------------------------------------------------------------------+
//|                                           LiquidityBot_v3.03.mq5 |
//|                        Copyright 2024, Advanced Trading Systems |
//|                                           https://www.example.com |
//+------------------------------------------------------------------+
#property copyright "2024, Advanced Trading Systems"
#property link      "https://www.example.com"
#property version   "3.03"
#property strict
#property description "Advanced Liquidity Bot with Multi-timeframe Analysis and Risk Management"

//--- Input Parameters
input group "=== Basic Settings ==="
input double InpRiskPercent = 2.0;                    // Risk per trade (%)
input int InpMagicNumber = 230303;                    // Magic Number
input bool InpUseATRSizing = true;                    // Use ATR-based lot sizing
input int InpATRPeriod = 14;                          // ATR Period for lot sizing

input group "=== Multi-Timeframe Settings ==="
input bool InpUseD1Filter = true;                     // Use D1 trend filter
input ENUM_TIMEFRAMES InpHigherTF = PERIOD_D1;        // Higher timeframe for confluence
input int InpTrendPeriod = 50;                        // Period for trend analysis
input double InpConfluenceScore = 75.0;               // Minimum confluence score

input group "=== Time Filters ==="
input bool InpUseTimeFilter = true;                   // Use time-based filters
input int InpStartHour = 8;                           // Trading start hour (GMT)
input int InpEndHour = 22;                            // Trading end hour (GMT)
input bool InpAvoidNews = true;                       // Avoid trading before/after news
input int InpNewsAvoidanceMinutes = 30;               // Minutes to avoid around news

input group "=== Liquidity Settings ==="
input double InpMinLiquidityScore = 80.0;             // Minimum liquidity strength score
input int InpLiquidityLookback = 100;                 // Bars to look back for liquidity levels
input double InpLiquidityMinVolume = 1000;            // Minimum volume for liquidity level

input group "=== Risk Management ==="
input bool InpUseTrailingStop = true;                 // Use swing-based trailing stop
input double InpMaxDailyLoss = 5.0;                   // Maximum daily loss (%)
input double InpMaxWeeklyLoss = 10.0;                 // Maximum weekly loss (%)
input double InpCorrelationLimit = 0.7;               // Maximum correlation between positions

input group "=== Entry Logic ==="
input bool InpUseSmartEntry = true;                   // Use smart entry timing
input int InpRSIPeriod = 14;                          // RSI period for momentum
input double InpRSIOverBought = 70;                   // RSI overbought level
input double InpRSIOverSold = 30;                     // RSI oversold level

input group "=== Performance Monitoring ==="
input bool InpEnableMonitoring = true;                // Enable real-time monitoring
input bool InpAutoAdjustment = false;                 // Auto-adjust parameters based on performance
input int InpMonitoringPeriod = 100;                  // Period for performance analysis

//--- Global Variables
double g_dailyPnL = 0;
double g_weeklyPnL = 0;
double g_maxDrawdown = 0;
double g_peakEquity = 0;
int g_totalTrades = 0;
int g_winningTrades = 0;
double g_totalProfit = 0;
double g_totalLoss = 0;
datetime g_lastTradeTime = 0;
datetime g_dailyReset = 0;
datetime g_weeklyReset = 0;

//--- Arrays for market structure analysis
double g_swingHighs[];
double g_swingLows[];
datetime g_swingHighTimes[];
datetime g_swingLowTimes[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    Print("LiquidityBot v3.03 - Initializing Advanced Optimizations...");
    
    // Initialize arrays
    ArraySetAsSeries(g_swingHighs, true);
    ArraySetAsSeries(g_swingLows, true);
    ArraySetAsSeries(g_swingHighTimes, true);
    ArraySetAsSeries(g_swingLowTimes, true);
    
    // Reset performance counters
    ResetPerformanceCounters();
    
    // Initialize swing point analysis
    InitializeSwingPoints();
    
    Print("LiquidityBot v3.03 initialized successfully!");
    Print("Risk per trade: ", InpRiskPercent, "%");
    Print("Using D1 filter: ", InpUseD1Filter ? "Yes" : "No");
    Print("ATR lot sizing: ", InpUseATRSizing ? "Enabled" : "Disabled");
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    Print("LiquidityBot v3.03 shutting down. Final statistics:");
    PrintPerformanceReport();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Update performance monitoring
    UpdatePerformanceMetrics();
    
    // Check for daily/weekly reset
    CheckTimeResets();
    
    // Check risk limits
    if (!CheckRiskLimits()) {
        return; // Stop trading if risk limits exceeded
    }
    
    // Time filter check
    if (InpUseTimeFilter && !IsGoodTimeToTrade()) {
        return;
    }
    
    // News avoidance check
    if (InpAvoidNews && IsNewsTime()) {
        return;
    }
    
    // Multi-timeframe confluence analysis
    double confluenceScore = CalculateConfluenceScore();
    if (confluenceScore < InpConfluenceScore) {
        return;
    }
    
    // Liquidity analysis
    double liquidityScore = CalculateLiquidityScore();
    if (liquidityScore < InpMinLiquidityScore) {
        return;
    }
    
    // Smart entry logic
    if (InpUseSmartEntry && !IsSmartEntryConditionMet()) {
        return;
    }
    
    // Main trading logic
    ProcessTradingSignals(confluenceScore, liquidityScore);
    
    // Update trailing stops
    if (InpUseTrailingStop) {
        UpdateTrailingStops();
    }
}

//+------------------------------------------------------------------+
//| Calculate Multi-timeframe Confluence Score                       |
//+------------------------------------------------------------------+
double CalculateConfluenceScore()
{
    double score = 0;
    
    // Current timeframe trend
    double currentTrend = GetTrendDirection(Period(), InpTrendPeriod);
    score += currentTrend * 40; // 40% weight
    
    // Higher timeframe trend
    if (InpUseD1Filter) {
        double higherTrend = GetTrendDirection(InpHigherTF, InpTrendPeriod);
        score += higherTrend * 60; // 60% weight
        
        // Bonus for alignment
        if (MathAbs(currentTrend - higherTrend) < 0.3) {
            score += 10; // Alignment bonus
        }
    }
    
    return MathAbs(score);
}

//+------------------------------------------------------------------+
//| Get Trend Direction for specific timeframe                       |
//+------------------------------------------------------------------+
double GetTrendDirection(ENUM_TIMEFRAMES tf, int period)
{
    double ma1 = iMA(_Symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE, 1);
    double ma2 = iMA(_Symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE, period/2);
    double close = iClose(_Symbol, tf, 1);
    
    double trend = 0;
    
    // Price vs MA
    if (close > ma1) trend += 0.5;
    else if (close < ma1) trend -= 0.5;
    
    // MA slope
    double ma1_prev = iMA(_Symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE, period/4);
    if (ma1 > ma1_prev) trend += 0.5;
    else if (ma1 < ma1_prev) trend -= 0.5;
    
    return trend;
}

//+------------------------------------------------------------------+
//| Calculate Liquidity Strength Score                               |
//+------------------------------------------------------------------+
double CalculateLiquidityScore()
{
    double score = 0;
    double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    
    // Find nearest liquidity levels
    double resistance = FindNearestResistance(currentPrice);
    double support = FindNearestSupport(currentPrice);
    
    if (resistance > 0) {
        double distanceToResistance = (resistance - currentPrice) / _Point;
        score += CalculateLevelStrength(resistance, true) * (1000 / MathMax(distanceToResistance, 10));
    }
    
    if (support > 0) {
        double distanceToSupport = (currentPrice - support) / _Point;
        score += CalculateLevelStrength(support, false) * (1000 / MathMax(distanceToSupport, 10));
    }
    
    return MathMin(score, 100);
}

//+------------------------------------------------------------------+
//| Find nearest resistance level                                    |
//+------------------------------------------------------------------+
double FindNearestResistance(double price)
{
    double nearest = 0;
    double minDistance = DBL_MAX;
    
    for (int i = 1; i <= InpLiquidityLookback; i++) {
        double high = iHigh(_Symbol, Period(), i);
        if (high > price) {
            double distance = high - price;
            if (distance < minDistance) {
                minDistance = distance;
                nearest = high;
            }
        }
    }
    
    return nearest;
}

//+------------------------------------------------------------------+
//| Find nearest support level                                       |
//+------------------------------------------------------------------+
double FindNearestSupport(double price)
{
    double nearest = 0;
    double minDistance = DBL_MAX;
    
    for (int i = 1; i <= InpLiquidityLookback; i++) {
        double low = iLow(_Symbol, Period(), i);
        if (low < price) {
            double distance = price - low;
            if (distance < minDistance) {
                minDistance = distance;
                nearest = low;
            }
        }
    }
    
    return nearest;
}

//+------------------------------------------------------------------+
//| Calculate level strength                                         |
//+------------------------------------------------------------------+
double CalculateLevelStrength(double level, bool isResistance)
{
    int touchCount = 0;
    double totalVolume = 0;
    double levelTolerance = 10 * _Point; // 10 pips tolerance
    
    for (int i = 1; i <= InpLiquidityLookback; i++) {
        double high = iHigh(_Symbol, Period(), i);
        double low = iLow(_Symbol, Period(), i);
        long volume = iVolume(_Symbol, Period(), i);
        
        bool touched = false;
        if (isResistance && MathAbs(high - level) <= levelTolerance) {
            touched = true;
        } else if (!isResistance && MathAbs(low - level) <= levelTolerance) {
            touched = true;
        }
        
        if (touched) {
            touchCount++;
            totalVolume += volume;
        }
    }
    
    // Strength based on touches and volume
    double strength = touchCount * 10 + (totalVolume / InpLiquidityMinVolume);
    return MathMin(strength, 100);
}

//+------------------------------------------------------------------+
//| Check if it's good time to trade                                 |
//+------------------------------------------------------------------+
bool IsGoodTimeToTrade()
{
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    
    int currentHour = dt.hour;
    
    // Basic session filter
    if (currentHour < InpStartHour || currentHour > InpEndHour) {
        return false;
    }
    
    // Session overlap bonus (London-NY: 13-17 GMT)
    if (currentHour >= 13 && currentHour <= 17) {
        return true; // Prime time
    }
    
    // Asian session (less preferred)
    if (currentHour >= 0 && currentHour <= 7) {
        return false; // Low volatility
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Check if it's news time                                          |
//+------------------------------------------------------------------+
bool IsNewsTime()
{
    // This would ideally connect to a news calendar API
    // For now, implement basic logic for major news times
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    
    // Avoid trading around major news times (simplified)
    // 8:30, 10:00, 14:00, 16:00 GMT are common high-impact news times
    int newsHours[] = {8, 10, 14, 16};
    int currentHour = dt.hour;
    int currentMinute = dt.min;
    
    for (int i = 0; i < ArraySize(newsHours); i++) {
        int newsHour = newsHours[i];
        if (currentHour == newsHour) {
            if (currentMinute <= InpNewsAvoidanceMinutes || 
                currentMinute >= (60 - InpNewsAvoidanceMinutes)) {
                return true;
            }
        }
        if (currentHour == newsHour - 1 && currentMinute >= (60 - InpNewsAvoidanceMinutes)) {
            return true;
        }
        if (currentHour == newsHour + 1 && currentMinute <= InpNewsAvoidanceMinutes) {
            return true;
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check smart entry conditions                                     |
//+------------------------------------------------------------------+
bool IsSmartEntryConditionMet()
{
    // RSI momentum check
    double rsi = iRSI(_Symbol, Period(), InpRSIPeriod, PRICE_CLOSE, 1);
    
    // Avoid extreme RSI levels
    if (rsi > InpRSIOverBought || rsi < InpRSIOverSold) {
        return false;
    }
    
    // Check for pullback after structure shift
    if (!IsPullbackConditionMet()) {
        return false;
    }
    
    // Market structure confirmation
    if (!IsMarketStructureValid()) {
        return false;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Check for pullback condition                                     |
//+------------------------------------------------------------------+
bool IsPullbackConditionMet()
{
    double ema20 = iMA(_Symbol, Period(), 20, 0, MODE_EMA, PRICE_CLOSE, 1);
    double ema50 = iMA(_Symbol, Period(), 50, 0, MODE_EMA, PRICE_CLOSE, 1);
    double close = iClose(_Symbol, Period(), 1);
    
    // Look for price between EMAs (pullback zone)
    if (ema20 > ema50) { // Uptrend
        return (close > ema50 && close < ema20);
    } else { // Downtrend
        return (close < ema50 && close > ema20);
    }
}

//+------------------------------------------------------------------+
//| Check market structure validity                                   |
//+------------------------------------------------------------------+
bool IsMarketStructureValid()
{
    // Update swing points
    UpdateSwingPoints();
    
    // Check for clear market structure
    if (ArraySize(g_swingHighs) < 2 || ArraySize(g_swingLows) < 2) {
        return false;
    }
    
    // Look for higher highs/higher lows or lower highs/lower lows
    bool upTrend = (g_swingHighs[0] > g_swingHighs[1]) && (g_swingLows[0] > g_swingLows[1]);
    bool downTrend = (g_swingHighs[0] < g_swingHighs[1]) && (g_swingLows[0] < g_swingLows[1]);
    
    return (upTrend || downTrend);
}

//+------------------------------------------------------------------+
//| Process trading signals                                          |
//+------------------------------------------------------------------+
void ProcessTradingSignals(double confluenceScore, double liquidityScore)
{
    // Check for existing positions
    if (PositionsTotal() > 0) {
        return; // Limit one position at a time for now
    }
    
    // Calculate lot size
    double lotSize = CalculateLotSize();
    if (lotSize <= 0) {
        return;
    }
    
    // Determine signal direction
    int signal = GetTradingSignal(confluenceScore, liquidityScore);
    
    if (signal == 1) { // Buy signal
        double entry = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        double sl = CalculateStopLoss(true);
        double tp = CalculateTakeProfit(true, entry, sl);
        
        if (tp > entry && sl < entry && (entry - sl) > 0) {
            OpenPosition(ORDER_TYPE_BUY, lotSize, entry, sl, tp);
        }
    } else if (signal == -1) { // Sell signal
        double entry = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        double sl = CalculateStopLoss(false);
        double tp = CalculateTakeProfit(false, entry, sl);
        
        if (tp < entry && sl > entry && (sl - entry) > 0) {
            OpenPosition(ORDER_TYPE_SELL, lotSize, entry, sl, tp);
        }
    }
}

//+------------------------------------------------------------------+
//| Get trading signal                                               |
//+------------------------------------------------------------------+
int GetTradingSignal(double confluenceScore, double liquidityScore)
{
    double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    double resistance = FindNearestResistance(currentPrice);
    double support = FindNearestSupport(currentPrice);
    
    // Look for breakout or bounce setups
    double breakoutThreshold = 20 * _Point;
    
    // Bullish setup: bounce from support
    if (support > 0 && (currentPrice - support) <= breakoutThreshold) {
        double trendDirection = GetTrendDirection(Period(), InpTrendPeriod);
        if (trendDirection > 0.3 && confluenceScore > InpConfluenceScore) {
            return 1; // Buy signal
        }
    }
    
    // Bearish setup: rejection from resistance
    if (resistance > 0 && (resistance - currentPrice) <= breakoutThreshold) {
        double trendDirection = GetTrendDirection(Period(), InpTrendPeriod);
        if (trendDirection < -0.3 && confluenceScore > InpConfluenceScore) {
            return -1; // Sell signal
        }
    }
    
    return 0; // No signal
}

//+------------------------------------------------------------------+
//| Calculate dynamic lot size based on ATR                          |
//+------------------------------------------------------------------+
double CalculateLotSize()
{
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = balance * (InpRiskPercent / 100.0);
    
    double lotSize;
    
    if (InpUseATRSizing) {
        double atr = iATR(_Symbol, Period(), InpATRPeriod, 1);
        double stopDistance = atr * 2.0; // 2x ATR stop
        
        double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
        double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
        
        if (tickValue > 0 && tickSize > 0) {
            double pointsToRisk = stopDistance / _Point;
            double valuePerLot = (tickValue / tickSize) * _Point;
            lotSize = riskAmount / (pointsToRisk * valuePerLot);
        } else {
            lotSize = riskAmount / (stopDistance * 100000); // Fallback calculation
        }
    } else {
        // Fixed lot size calculation
        lotSize = riskAmount / (100 * _Point * 100000);
    }
    
    // Normalize lot size
    double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    
    lotSize = MathMax(lotSize, minLot);
    lotSize = MathMin(lotSize, maxLot);
    lotSize = MathFloor(lotSize / stepLot) * stepLot;
    
    return lotSize;
}

//+------------------------------------------------------------------+
//| Calculate stop loss level                                        |
//+------------------------------------------------------------------+
double CalculateStopLoss(bool isBuy)
{
    if (InpUseATRSizing) {
        double atr = iATR(_Symbol, Period(), InpATRPeriod, 1);
        double currentPrice = isBuy ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
        
        return isBuy ? (currentPrice - atr * 2.0) : (currentPrice + atr * 2.0);
    } else {
        // Use swing points for stop loss
        if (isBuy && ArraySize(g_swingLows) > 0) {
            return g_swingLows[0] - 5 * _Point;
        } else if (!isBuy && ArraySize(g_swingHighs) > 0) {
            return g_swingHighs[0] + 5 * _Point;
        }
    }
    
    // Fallback to fixed stop
    double currentPrice = isBuy ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
    return isBuy ? (currentPrice - 50 * _Point) : (currentPrice + 50 * _Point);
}

//+------------------------------------------------------------------+
//| Calculate take profit level                                      |
//+------------------------------------------------------------------+
double CalculateTakeProfit(bool isBuy, double entry, double stopLoss)
{
    double stopDistance = MathAbs(entry - stopLoss);
    double riskRewardRatio = 2.0; // 1:2 risk reward
    
    return isBuy ? (entry + stopDistance * riskRewardRatio) : (entry - stopDistance * riskRewardRatio);
}

//+------------------------------------------------------------------+
//| Open position                                                    |
//+------------------------------------------------------------------+
void OpenPosition(ENUM_ORDER_TYPE type, double lots, double price, double sl, double tp)
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.symbol = _Symbol;
    request.volume = lots;
    request.type = type;
    request.price = price;
    request.sl = sl;
    request.tp = tp;
    request.magic = InpMagicNumber;
    request.comment = "LiquidityBot_v3.03";
    
    if (!OrderSend(request, result)) {
        Print("Order failed: ", GetLastError(), " - ", result.retcode_external);
    } else {
        Print("Order opened successfully: ", result.order);
        g_totalTrades++;
        g_lastTradeTime = TimeCurrent();
    }
}

//+------------------------------------------------------------------+
//| Update trailing stops                                           |
//+------------------------------------------------------------------+
void UpdateTrailingStops()
{
    for (int i = 0; i < PositionsTotal(); i++) {
        if (PositionGetSymbol(i) == _Symbol && PositionGetInteger(POSITION_MAGIC) == InpMagicNumber) {
            double positionType = PositionGetInteger(POSITION_TYPE);
            double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            double currentSL = PositionGetDouble(POSITION_SL);
            double currentPrice = positionType == POSITION_TYPE_BUY ? 
                                 SymbolInfoDouble(_Symbol, SYMBOL_BID) : 
                                 SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            
            double newSL = CalculateTrailingStop(positionType == POSITION_TYPE_BUY, currentPrice, currentSL);
            
            if (newSL != currentSL) {
                ModifyPosition(PositionGetInteger(POSITION_TICKET), newSL, PositionGetDouble(POSITION_TP));
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Calculate trailing stop based on swing points                    |
//+------------------------------------------------------------------+
double CalculateTrailingStop(bool isBuy, double currentPrice, double currentSL)
{
    UpdateSwingPoints();
    
    if (isBuy && ArraySize(g_swingLows) > 0) {
        double newSL = g_swingLows[0] - 5 * _Point;
        return (newSL > currentSL) ? newSL : currentSL;
    } else if (!isBuy && ArraySize(g_swingHighs) > 0) {
        double newSL = g_swingHighs[0] + 5 * _Point;
        return (newSL < currentSL || currentSL == 0) ? newSL : currentSL;
    }
    
    return currentSL;
}

//+------------------------------------------------------------------+
//| Modify position                                                  |
//+------------------------------------------------------------------+
void ModifyPosition(ulong ticket, double sl, double tp)
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_SLTP;
    request.position = ticket;
    request.sl = sl;
    request.tp = tp;
    
    if (!OrderSend(request, result)) {
        Print("Position modification failed: ", GetLastError());
    }
}

//+------------------------------------------------------------------+
//| Initialize swing points                                          |
//+------------------------------------------------------------------+
void InitializeSwingPoints()
{
    ArrayResize(g_swingHighs, 0);
    ArrayResize(g_swingLows, 0);
    ArrayResize(g_swingHighTimes, 0);
    ArrayResize(g_swingLowTimes, 0);
    
    UpdateSwingPoints();
}

//+------------------------------------------------------------------+
//| Update swing points                                              |
//+------------------------------------------------------------------+
void UpdateSwingPoints()
{
    int swingStrength = 5; // Minimum bars on each side for swing point
    
    for (int i = swingStrength; i < 50; i++) { // Look back 50 bars max
        bool isSwingHigh = true;
        bool isSwingLow = true;
        
        double currentHigh = iHigh(_Symbol, Period(), i);
        double currentLow = iLow(_Symbol, Period(), i);
        
        // Check if it's a swing high
        for (int j = 1; j <= swingStrength; j++) {
            if (iHigh(_Symbol, Period(), i - j) >= currentHigh || 
                iHigh(_Symbol, Period(), i + j) >= currentHigh) {
                isSwingHigh = false;
                break;
            }
        }
        
        // Check if it's a swing low
        for (int j = 1; j <= swingStrength; j++) {
            if (iLow(_Symbol, Period(), i - j) <= currentLow || 
                iLow(_Symbol, Period(), i + j) <= currentLow) {
                isSwingLow = false;
                break;
            }
        }
        
        if (isSwingHigh) {
            AddSwingPoint(currentHigh, iTime(_Symbol, Period(), i), true);
        }
        
        if (isSwingLow) {
            AddSwingPoint(currentLow, iTime(_Symbol, Period(), i), false);
        }
    }
}

//+------------------------------------------------------------------+
//| Add swing point                                                  |
//+------------------------------------------------------------------+
void AddSwingPoint(double price, datetime time, bool isHigh)
{
    if (isHigh) {
        ArrayResize(g_swingHighs, ArraySize(g_swingHighs) + 1);
        ArrayResize(g_swingHighTimes, ArraySize(g_swingHighTimes) + 1);
        
        g_swingHighs[ArraySize(g_swingHighs) - 1] = price;
        g_swingHighTimes[ArraySize(g_swingHighTimes) - 1] = time;
        
        // Keep only latest 10 swing points
        if (ArraySize(g_swingHighs) > 10) {
            ArrayResize(g_swingHighs, 10);
            ArrayResize(g_swingHighTimes, 10);
        }
    } else {
        ArrayResize(g_swingLows, ArraySize(g_swingLows) + 1);
        ArrayResize(g_swingLowTimes, ArraySize(g_swingLowTimes) + 1);
        
        g_swingLows[ArraySize(g_swingLows) - 1] = price;
        g_swingLowTimes[ArraySize(g_swingLowTimes) - 1] = time;
        
        // Keep only latest 10 swing points
        if (ArraySize(g_swingLows) > 10) {
            ArrayResize(g_swingLows, 10);
            ArrayResize(g_swingLowTimes, 10);
        }
    }
}

//+------------------------------------------------------------------+
//| Check risk limits                                               |
//+------------------------------------------------------------------+
bool CheckRiskLimits()
{
    UpdatePerformanceMetrics();
    
    // Check daily loss limit
    if (g_dailyPnL < -(AccountInfoDouble(ACCOUNT_BALANCE) * InpMaxDailyLoss / 100.0)) {
        Print("Daily loss limit exceeded: ", g_dailyPnL);
        return false;
    }
    
    // Check weekly loss limit
    if (g_weeklyPnL < -(AccountInfoDouble(ACCOUNT_BALANCE) * InpMaxWeeklyLoss / 100.0)) {
        Print("Weekly loss limit exceeded: ", g_weeklyPnL);
        return false;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Update performance metrics                                       |
//+------------------------------------------------------------------+
void UpdatePerformanceMetrics()
{
    double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    
    // Update peak equity and drawdown
    if (currentEquity > g_peakEquity) {
        g_peakEquity = currentEquity;
    } else {
        double currentDrawdown = (g_peakEquity - currentEquity) / g_peakEquity * 100.0;
        if (currentDrawdown > g_maxDrawdown) {
            g_maxDrawdown = currentDrawdown;
        }
    }
    
    // Update daily P&L
    if (TimeCurrent() > g_dailyReset) {
        g_dailyPnL = 0; // Reset daily P&L
        MqlDateTime dt;
        TimeToStruct(TimeCurrent(), dt);
        dt.hour = 0; dt.min = 0; dt.sec = 0;
        g_dailyReset = StructToTime(dt) + 86400; // Next day
    }
    
    // Update weekly P&L
    if (TimeCurrent() > g_weeklyReset) {
        g_weeklyPnL = 0; // Reset weekly P&L
        MqlDateTime dt;
        TimeToStruct(TimeCurrent(), dt);
        int daysToMonday = (dt.day_of_week == 0) ? 1 : 8 - dt.day_of_week;
        g_weeklyReset = TimeCurrent() + daysToMonday * 86400;
    }
    
    // Calculate current session P&L
    double sessionPnL = 0;
    for (int i = 0; i < PositionsTotal(); i++) {
        if (PositionGetSymbol(i) == _Symbol && PositionGetInteger(POSITION_MAGIC) == InpMagicNumber) {
            sessionPnL += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
        }
    }
    
    g_dailyPnL += sessionPnL;
    g_weeklyPnL += sessionPnL;
}

//+------------------------------------------------------------------+
//| Check time resets                                               |
//+------------------------------------------------------------------+
void CheckTimeResets()
{
    if (g_dailyReset == 0 || g_weeklyReset == 0) {
        ResetPerformanceCounters();
    }
}

//+------------------------------------------------------------------+
//| Reset performance counters                                       |
//+------------------------------------------------------------------+
void ResetPerformanceCounters()
{
    g_dailyPnL = 0;
    g_weeklyPnL = 0;
    g_maxDrawdown = 0;
    g_peakEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    g_totalTrades = 0;
    g_winningTrades = 0;
    g_totalProfit = 0;
    g_totalLoss = 0;
    
    // Set reset times
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    dt.hour = 0; dt.min = 0; dt.sec = 0;
    g_dailyReset = StructToTime(dt) + 86400;
    
    int daysToMonday = (dt.day_of_week == 0) ? 1 : 8 - dt.day_of_week;
    g_weeklyReset = TimeCurrent() + daysToMonday * 86400;
}

//+------------------------------------------------------------------+
//| Print performance report                                         |
//+------------------------------------------------------------------+
void PrintPerformanceReport()
{
    double winRate = (g_totalTrades > 0) ? (double)g_winningTrades / g_totalTrades * 100.0 : 0;
    double profitFactor = (g_totalLoss > 0) ? g_totalProfit / MathAbs(g_totalLoss) : 0;
    
    Print("=== LiquidityBot v3.03 Performance Report ===");
    Print("Total Trades: ", g_totalTrades);
    Print("Win Rate: ", DoubleToString(winRate, 2), "%");
    Print("Profit Factor: ", DoubleToString(profitFactor, 2));
    Print("Max Drawdown: ", DoubleToString(g_maxDrawdown, 2), "%");
    Print("Daily P&L: $", DoubleToString(g_dailyPnL, 2));
    Print("Weekly P&L: $", DoubleToString(g_weeklyPnL, 2));
}

//+------------------------------------------------------------------+
//| OnTrade function for monitoring                                  |
//+------------------------------------------------------------------+
void OnTrade()
{
    // Update trade statistics when positions close
    if (InpEnableMonitoring) {
        UpdateTradeStatistics();
    }
}

//+------------------------------------------------------------------+
//| Update trade statistics                                          |
//+------------------------------------------------------------------+
void UpdateTradeStatistics()
{
    // Get the last trade result
    HistorySelect(0, TimeCurrent());
    int totalDeals = HistoryDealsTotal();
    
    if (totalDeals > 0) {
        ulong ticket = HistoryDealGetTicket(totalDeals - 1);
        if (HistoryDealGetInteger(ticket, DEAL_MAGIC) == InpMagicNumber) {
            double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
            
            if (profit > 0) {
                g_winningTrades++;
                g_totalProfit += profit;
            } else {
                g_totalLoss += profit;
            }
            
            // Print trade result
            Print("Trade closed. Profit: $", DoubleToString(profit, 2));
        }
    }
}

//+------------------------------------------------------------------+
//| OnTimer function for auto-adjustment                            |
//+------------------------------------------------------------------+
void OnTimer()
{
    if (InpAutoAdjustment && InpEnableMonitoring) {
        PerformAutoAdjustment();
    }
}

//+------------------------------------------------------------------+
//| Perform parameter auto-adjustment based on performance           |
//+------------------------------------------------------------------+
void PerformAutoAdjustment()
{
    // This would implement adaptive parameter adjustment
    // based on recent performance metrics
    
    double recentWinRate = CalculateRecentWinRate();
    double recentProfitFactor = CalculateRecentProfitFactor();
    
    // Example: If win rate is low, increase confluence score requirement
    if (recentWinRate < 50 && g_totalTrades > 10) {
        Print("Auto-adjustment: Performance below target, increasing selectivity");
        // Note: In a real implementation, you'd modify global parameters
        // For this example, we'll just log the recommendation
    }
}

//+------------------------------------------------------------------+
//| Calculate recent win rate                                        |
//+------------------------------------------------------------------+
double CalculateRecentWinRate()
{
    // Implement logic to calculate win rate for recent trades
    return (g_totalTrades > 0) ? (double)g_winningTrades / g_totalTrades * 100.0 : 0;
}

//+------------------------------------------------------------------+
//| Calculate recent profit factor                                   |
//+------------------------------------------------------------------+
double CalculateRecentProfitFactor()
{
    // Implement logic to calculate profit factor for recent trades
    return (g_totalLoss < 0) ? g_totalProfit / MathAbs(g_totalLoss) : 0;
}