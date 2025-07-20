//+------------------------------------------------------------------+
//|                                      LiquidityBot_Config.mqh    |
//|                        Copyright 2024, Advanced Trading Systems |
//|                                           https://www.example.com |
//+------------------------------------------------------------------+
#property copyright "2024, Advanced Trading Systems"
#property link      "https://www.example.com"

//+------------------------------------------------------------------+
//| Configuration presets for different trading styles              |
//+------------------------------------------------------------------+

//--- Trading Style Enumerations
enum ENUM_TRADING_STYLE
{
    STYLE_CONSERVATIVE,     // Conservative - Lower risk, higher selectivity
    STYLE_BALANCED,         // Balanced - Default settings
    STYLE_AGGRESSIVE,       // Aggressive - Higher risk, more trades
    STYLE_SCALPING,         // Scalping - Quick in/out trades
    STYLE_SWING             // Swing - Longer term positions
};

//--- Risk Profile Enumerations
enum ENUM_RISK_PROFILE
{
    RISK_LOW,               // Low risk - 1% per trade
    RISK_MEDIUM,            // Medium risk - 2% per trade
    RISK_HIGH               // High risk - 3% per trade
};

//--- Market Condition Enumerations
enum ENUM_MARKET_CONDITION
{
    MARKET_TRENDING,        // Trending market settings
    MARKET_RANGING,         // Ranging market settings
    MARKET_VOLATILE,        // High volatility settings
    MARKET_QUIET            // Low volatility settings
};

//+------------------------------------------------------------------+
//| Configuration structure                                          |
//+------------------------------------------------------------------+
struct TradingConfig
{
    // Basic Settings
    double riskPercent;
    bool useATRSizing;
    int atrPeriod;
    
    // Multi-timeframe Settings
    bool useD1Filter;
    ENUM_TIMEFRAMES higherTF;
    int trendPeriod;
    double confluenceScore;
    
    // Time Filters
    bool useTimeFilter;
    int startHour;
    int endHour;
    bool avoidNews;
    int newsAvoidanceMinutes;
    
    // Liquidity Settings
    double minLiquidityScore;
    int liquidityLookback;
    double liquidityMinVolume;
    
    // Risk Management
    bool useTrailingStop;
    double maxDailyLoss;
    double maxWeeklyLoss;
    double correlationLimit;
    
    // Entry Logic
    bool useSmartEntry;
    int rsiPeriod;
    double rsiOverBought;
    double rsiOverSold;
    
    // Performance Monitoring
    bool enableMonitoring;
    bool autoAdjustment;
    int monitoringPeriod;
};

//+------------------------------------------------------------------+
//| Get configuration for Conservative style                         |
//+------------------------------------------------------------------+
TradingConfig GetConservativeConfig()
{
    TradingConfig config;
    
    // Basic Settings - Lower risk
    config.riskPercent = 1.0;
    config.useATRSizing = true;
    config.atrPeriod = 14;
    
    // Multi-timeframe - Strict filtering
    config.useD1Filter = true;
    config.higherTF = PERIOD_D1;
    config.trendPeriod = 50;
    config.confluenceScore = 85.0; // Higher threshold
    
    // Time Filters - Limited hours
    config.useTimeFilter = true;
    config.startHour = 9;
    config.endHour = 21;
    config.avoidNews = true;
    config.newsAvoidanceMinutes = 45; // Longer avoidance
    
    // Liquidity Settings - High quality only
    config.minLiquidityScore = 90.0; // Higher threshold
    config.liquidityLookback = 150;
    config.liquidityMinVolume = 1500;
    
    // Risk Management - Strict limits
    config.useTrailingStop = true;
    config.maxDailyLoss = 3.0; // Lower limit
    config.maxWeeklyLoss = 7.0; // Lower limit
    config.correlationLimit = 0.5; // Stricter correlation
    
    // Entry Logic - More selective
    config.useSmartEntry = true;
    config.rsiPeriod = 21; // Longer period
    config.rsiOverBought = 65; // More conservative
    config.rsiOverSold = 35;
    
    // Monitoring
    config.enableMonitoring = true;
    config.autoAdjustment = false;
    config.monitoringPeriod = 200;
    
    return config;
}

//+------------------------------------------------------------------+
//| Get configuration for Balanced style (Default)                  |
//+------------------------------------------------------------------+
TradingConfig GetBalancedConfig()
{
    TradingConfig config;
    
    // Basic Settings
    config.riskPercent = 2.0;
    config.useATRSizing = true;
    config.atrPeriod = 14;
    
    // Multi-timeframe
    config.useD1Filter = true;
    config.higherTF = PERIOD_D1;
    config.trendPeriod = 50;
    config.confluenceScore = 75.0;
    
    // Time Filters
    config.useTimeFilter = true;
    config.startHour = 8;
    config.endHour = 22;
    config.avoidNews = true;
    config.newsAvoidanceMinutes = 30;
    
    // Liquidity Settings
    config.minLiquidityScore = 80.0;
    config.liquidityLookback = 100;
    config.liquidityMinVolume = 1000;
    
    // Risk Management
    config.useTrailingStop = true;
    config.maxDailyLoss = 5.0;
    config.maxWeeklyLoss = 10.0;
    config.correlationLimit = 0.7;
    
    // Entry Logic
    config.useSmartEntry = true;
    config.rsiPeriod = 14;
    config.rsiOverBought = 70;
    config.rsiOverSold = 30;
    
    // Monitoring
    config.enableMonitoring = true;
    config.autoAdjustment = false;
    config.monitoringPeriod = 100;
    
    return config;
}

//+------------------------------------------------------------------+
//| Get configuration for Aggressive style                          |
//+------------------------------------------------------------------+
TradingConfig GetAggressiveConfig()
{
    TradingConfig config;
    
    // Basic Settings - Higher risk
    config.riskPercent = 3.0;
    config.useATRSizing = true;
    config.atrPeriod = 10; // Shorter period for quicker response
    
    // Multi-timeframe - Less strict
    config.useD1Filter = true;
    config.higherTF = PERIOD_H4; // Shorter timeframe
    config.trendPeriod = 30;
    config.confluenceScore = 65.0; // Lower threshold
    
    // Time Filters - Extended hours
    config.useTimeFilter = true;
    config.startHour = 6;
    config.endHour = 23;
    config.avoidNews = true;
    config.newsAvoidanceMinutes = 15; // Shorter avoidance
    
    // Liquidity Settings - More permissive
    config.minLiquidityScore = 70.0;
    config.liquidityLookback = 75;
    config.liquidityMinVolume = 800;
    
    // Risk Management - Higher limits
    config.useTrailingStop = true;
    config.maxDailyLoss = 7.0;
    config.maxWeeklyLoss = 15.0;
    config.correlationLimit = 0.8;
    
    // Entry Logic - Less selective
    config.useSmartEntry = true;
    config.rsiPeriod = 10;
    config.rsiOverBought = 75;
    config.rsiOverSold = 25;
    
    // Monitoring
    config.enableMonitoring = true;
    config.autoAdjustment = true; // Enable auto-adjustment
    config.monitoringPeriod = 50;
    
    return config;
}

//+------------------------------------------------------------------+
//| Get configuration for Scalping style                            |
//+------------------------------------------------------------------+
TradingConfig GetScalpingConfig()
{
    TradingConfig config;
    
    // Basic Settings - Quick trades
    config.riskPercent = 1.5;
    config.useATRSizing = true;
    config.atrPeriod = 5; // Very short period
    
    // Multi-timeframe - Current TF focus
    config.useD1Filter = false; // Disable for scalping
    config.higherTF = PERIOD_H1;
    config.trendPeriod = 20;
    config.confluenceScore = 60.0;
    
    // Time Filters - Active sessions only
    config.useTimeFilter = true;
    config.startHour = 13; // London-NY overlap
    config.endHour = 17;
    config.avoidNews = true;
    config.newsAvoidanceMinutes = 60; // Avoid completely during news
    
    // Liquidity Settings - Quick execution focus
    config.minLiquidityScore = 75.0;
    config.liquidityLookback = 50;
    config.liquidityMinVolume = 500;
    
    // Risk Management - Tight stops
    config.useTrailingStop = true;
    config.maxDailyLoss = 4.0;
    config.maxWeeklyLoss = 12.0;
    config.correlationLimit = 0.6;
    
    // Entry Logic - Quick decisions
    config.useSmartEntry = true;
    config.rsiPeriod = 7;
    config.rsiOverBought = 80;
    config.rsiOverSold = 20;
    
    // Monitoring - High frequency
    config.enableMonitoring = true;
    config.autoAdjustment = true;
    config.monitoringPeriod = 25;
    
    return config;
}

//+------------------------------------------------------------------+
//| Get configuration for Swing style                               |
//+------------------------------------------------------------------+
TradingConfig GetSwingConfig()
{
    TradingConfig config;
    
    // Basic Settings - Longer term
    config.riskPercent = 2.5;
    config.useATRSizing = true;
    config.atrPeriod = 21; // Longer period
    
    // Multi-timeframe - Strong trend focus
    config.useD1Filter = true;
    config.higherTF = PERIOD_W1; // Weekly trend
    config.trendPeriod = 100;
    config.confluenceScore = 80.0;
    
    // Time Filters - Less restrictive
    config.useTimeFilter = false; // Allow 24h trading
    config.startHour = 0;
    config.endHour = 23;
    config.avoidNews = false; // Swing trades can handle news
    config.newsAvoidanceMinutes = 0;
    
    // Liquidity Settings - Strong levels
    config.minLiquidityScore = 85.0;
    config.liquidityLookback = 200;
    config.liquidityMinVolume = 2000;
    
    // Risk Management - Wider stops
    config.useTrailingStop = true;
    config.maxDailyLoss = 6.0;
    config.maxWeeklyLoss = 12.0;
    config.correlationLimit = 0.75;
    
    // Entry Logic - Trend confirmation
    config.useSmartEntry = true;
    config.rsiPeriod = 21;
    config.rsiOverBought = 60; // Less extreme levels
    config.rsiOverSold = 40;
    
    // Monitoring - Longer term view
    config.enableMonitoring = true;
    config.autoAdjustment = false;
    config.monitoringPeriod = 300;
    
    return config;
}

//+------------------------------------------------------------------+
//| Get configuration based on market condition                     |
//+------------------------------------------------------------------+
TradingConfig GetMarketConditionConfig(ENUM_MARKET_CONDITION condition)
{
    TradingConfig config = GetBalancedConfig(); // Start with balanced
    
    switch(condition) {
        case MARKET_TRENDING:
            config.confluenceScore = 70.0; // Lower threshold for trends
            config.useD1Filter = true;
            config.minLiquidityScore = 75.0;
            config.useTrailingStop = true;
            break;
            
        case MARKET_RANGING:
            config.confluenceScore = 85.0; // Higher threshold for ranges
            config.useD1Filter = false; // Less relevant in ranges
            config.minLiquidityScore = 90.0; // Need strong levels
            config.maxDailyLoss = 3.0; // Lower risk in ranges
            break;
            
        case MARKET_VOLATILE:
            config.riskPercent = 1.5; // Reduce risk
            config.atrPeriod = 10; // Shorter ATR for quick adaptation
            config.newsAvoidanceMinutes = 45; // Longer avoidance
            config.maxDailyLoss = 4.0;
            break;
            
        case MARKET_QUIET:
            config.riskPercent = 2.5; // Can increase risk slightly
            config.confluenceScore = 70.0; // Lower threshold needed
            config.minLiquidityScore = 75.0;
            config.useTimeFilter = false; // Trade any time in quiet markets
            break;
    }
    
    return config;
}

//+------------------------------------------------------------------+
//| Apply configuration to input parameters                         |
//+------------------------------------------------------------------+
void ApplyConfiguration(TradingConfig &config)
{
    // Note: In actual implementation, these would modify the input parameters
    // This function provides a template for applying configurations
    
    Print("Applying trading configuration:");
    Print("Risk per trade: ", config.riskPercent, "%");
    Print("Confluence score threshold: ", config.confluenceScore);
    Print("Liquidity score threshold: ", config.minLiquidityScore);
    Print("Max daily loss: ", config.maxDailyLoss, "%");
    Print("Trading hours: ", config.startHour, " - ", config.endHour, " GMT");
}

//+------------------------------------------------------------------+
//| Get recommended configuration based on account size             |
//+------------------------------------------------------------------+
TradingConfig GetAccountSizeConfig(double accountBalance)
{
    if (accountBalance < 1000) {
        Print("Small account detected - using conservative settings");
        return GetConservativeConfig();
    } else if (accountBalance < 10000) {
        Print("Medium account detected - using balanced settings");
        return GetBalancedConfig();
    } else {
        Print("Large account detected - using aggressive settings available");
        return GetAggressiveConfig();
    }
}

//+------------------------------------------------------------------+
//| Currency pair specific configurations                            |
//+------------------------------------------------------------------+
TradingConfig GetPairSpecificConfig(string symbol)
{
    TradingConfig config = GetBalancedConfig();
    
    // Major pairs - standard settings
    if (symbol == "EURUSD" || symbol == "GBPUSD" || symbol == "USDJPY") {
        // Keep default balanced config
        return config;
    }
    
    // Volatile pairs - more conservative
    if (symbol == "GBPJPY" || symbol == "EURJPY" || symbol == "GBPCHF") {
        config.riskPercent = 1.5;
        config.confluenceScore = 80.0;
        config.newsAvoidanceMinutes = 45;
        config.maxDailyLoss = 4.0;
        return config;
    }
    
    // Exotic pairs - very conservative
    if (StringFind(symbol, "USD") != 0 && StringFind(symbol, "EUR") != 0 && 
        StringFind(symbol, "GBP") != 0 && StringFind(symbol, "JPY") != 0) {
        config.riskPercent = 1.0;
        config.confluenceScore = 90.0;
        config.minLiquidityScore = 85.0;
        config.maxDailyLoss = 3.0;
        return config;
    }
    
    return config;
}

//+------------------------------------------------------------------+
//| Time-based configuration adjustment                              |
//+------------------------------------------------------------------+
TradingConfig GetTimeBasedConfig(int currentHour)
{
    TradingConfig config = GetBalancedConfig();
    
    // Asian session - more conservative
    if (currentHour >= 22 || currentHour <= 8) {
        config.riskPercent = 1.5;
        config.confluenceScore = 80.0;
        config.minLiquidityScore = 85.0;
    }
    
    // London session - balanced
    else if (currentHour >= 8 && currentHour < 13) {
        // Keep default settings
    }
    
    // Overlap session - can be more aggressive
    else if (currentHour >= 13 && currentHour < 17) {
        config.riskPercent = 2.5;
        config.confluenceScore = 70.0;
    }
    
    // NY session - balanced to conservative
    else if (currentHour >= 17 && currentHour < 22) {
        config.confluenceScore = 75.0;
    }
    
    return config;
}

//+------------------------------------------------------------------+
//| Volatility-based configuration                                  |
//+------------------------------------------------------------------+
TradingConfig GetVolatilityBasedConfig(double currentATR, double avgATR)
{
    TradingConfig config = GetBalancedConfig();
    double atrRatio = (avgATR > 0) ? currentATR / avgATR : 1.0;
    
    // High volatility - reduce risk
    if (atrRatio > 1.5) {
        config.riskPercent *= 0.7;
        config.confluenceScore += 10.0;
        config.newsAvoidanceMinutes = 45;
        config.maxDailyLoss *= 0.8;
    }
    
    // Low volatility - can increase selectivity
    else if (atrRatio < 0.5) {
        config.confluenceScore += 5.0;
        config.minLiquidityScore += 5.0;
    }
    
    return config;
}