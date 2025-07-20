//+------------------------------------------------------------------+
//|                                 LiquidityBot_Test.mq5           |
//|                        Copyright 2024, Advanced Trading Systems |
//|                                           https://www.example.com |
//+------------------------------------------------------------------+
#property copyright "2024, Advanced Trading Systems"
#property link      "https://www.example.com"
#property version   "3.03"
#property script_show_inputs

//--- Include necessary files
#include "LiquidityBot_Utils.mqh"
#include "LiquidityBot_Config.mqh"

//--- Input parameters for testing
input group "=== Test Parameters ==="
input bool InpTestAll = true;                         // Run all tests
input bool InpTestUtils = false;                      // Test utility functions only
input bool InpTestConfig = false;                     // Test configuration only
input bool InpTestPerformance = false;                // Test performance calculations only
input int InpTestDataPeriod = 100;                    // Period for test data generation

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    Print("=== LiquidityBot v3.03 Testing Suite Started ===");
    
    if (InpTestAll || InpTestUtils) {
        TestUtilityFunctions();
    }
    
    if (InpTestAll || InpTestConfig) {
        TestConfigurationSystem();
    }
    
    if (InpTestAll || InpTestPerformance) {
        TestPerformanceCalculations();
    }
    
    Print("=== LiquidityBot v3.03 Testing Suite Completed ===");
}

//+------------------------------------------------------------------+
//| Test utility functions                                           |
//+------------------------------------------------------------------+
void TestUtilityFunctions()
{
    Print("--- Testing Utility Functions ---");
    
    // Test moving average calculations
    double prices[10] = {1.1000, 1.1010, 1.1020, 1.1015, 1.1025, 1.1030, 1.1035, 1.1040, 1.1045, 1.1050};
    
    double sma = CalculateSMA(prices, 5, 0);
    double ema = CalculateEMA(prices, 5, 0);
    double wma = CalculateWMA(prices, 5, 0);
    
    Print("SMA(5): ", DoubleToString(sma, 5));
    Print("EMA(5): ", DoubleToString(ema, 5));
    Print("WMA(5): ", DoubleToString(wma, 5));
    
    // Test RSI calculation
    double rsi = CalculateRSI(prices, 5, 0);
    Print("RSI(5): ", DoubleToString(rsi, 2));
    
    // Test ATR calculation
    double highs[10] = {1.1005, 1.1015, 1.1025, 1.1020, 1.1030, 1.1035, 1.1040, 1.1045, 1.1050, 1.1055};
    double lows[10] = {1.0995, 1.1005, 1.1015, 1.1010, 1.1020, 1.1025, 1.1030, 1.1035, 1.1040, 1.1045};
    double closes[10] = {1.1000, 1.1010, 1.1020, 1.1015, 1.1025, 1.1030, 1.1035, 1.1040, 1.1045, 1.1050};
    
    double atr = CalculateATR(highs, lows, closes, 5, 0);
    Print("ATR(5): ", DoubleToString(atr, 5));
    
    // Test correlation calculation
    double x[] = {1, 2, 3, 4, 5};
    double y[] = {2, 4, 6, 8, 10};
    double correlation = CalculateCorrelation(x, y);
    Print("Perfect correlation test: ", DoubleToString(correlation, 4), " (should be ~1.0)");
    
    // Test trend strength
    double trendStrength = CalculateTrendStrength(prices, ArraySize(prices));
    Print("Trend Strength: ", DoubleToString(trendStrength, 2), "%");
    
    // Test market structure
    int structure = AnalyzeMarketStructure(highs, lows, ArraySize(highs));
    string structureStr = (structure == 1) ? "Uptrend" : (structure == -1) ? "Downtrend" : "Sideways";
    Print("Market Structure: ", structureStr);
    
    // Test session detection
    int session = GetCurrentSession();
    string sessionStr = (session == 0) ? "Asian" : (session == 1) ? "London" : 
                       (session == 2) ? "NY" : (session == 3) ? "Overlap" : "Unknown";
    Print("Current Session: ", sessionStr);
    
    // Test volatility multiplier
    double volMultiplier = GetSessionVolatilityMultiplier();
    Print("Session Volatility Multiplier: ", DoubleToString(volMultiplier, 2));
    
    // Test Fibonacci levels
    double fibLevels[];
    GetFibonacciLevels(1.1100, 1.1000, fibLevels);
    Print("Fibonacci Levels (1.1100 - 1.1000):");
    string fibRatios[] = {"23.6%", "38.2%", "50.0%", "61.8%", "78.6%"};
    for (int i = 0; i < ArraySize(fibLevels); i++) {
        Print("  ", fibRatios[i], ": ", DoubleToString(fibLevels[i], 5));
    }
    
    // Test Kelly Criterion
    double kelly = CalculateKellyCriterion(0.6, 100, 50); // 60% win rate, avg win 100, avg loss 50
    Print("Kelly Criterion (60% WR, 2:1 RR): ", DoubleToString(kelly, 4));
    
    // Test Risk of Ruin
    double ror = CalculateRiskOfRuin(0.55, 0.02, 1.5); // 55% win rate, 2% risk, 1.5:1 RR
    Print("Risk of Ruin (55% WR, 2% risk, 1.5:1 RR): ", DoubleToString(ror * 100, 2), "%");
    
    Print("--- Utility Functions Test Completed ---");
}

//+------------------------------------------------------------------+
//| Test configuration system                                        |
//+------------------------------------------------------------------+
void TestConfigurationSystem()
{
    Print("--- Testing Configuration System ---");
    
    // Test different trading styles
    TradingConfig conservativeConfig = GetConservativeConfig();
    Print("Conservative Config - Risk: ", conservativeConfig.riskPercent, 
          "%, Confluence: ", conservativeConfig.confluenceScore);
    
    TradingConfig balancedConfig = GetBalancedConfig();
    Print("Balanced Config - Risk: ", balancedConfig.riskPercent, 
          "%, Confluence: ", balancedConfig.confluenceScore);
    
    TradingConfig aggressiveConfig = GetAggressiveConfig();
    Print("Aggressive Config - Risk: ", aggressiveConfig.riskPercent, 
          "%, Confluence: ", aggressiveConfig.confluenceScore);
    
    TradingConfig scalpingConfig = GetScalpingConfig();
    Print("Scalping Config - Risk: ", scalpingConfig.riskPercent, 
          "%, Trading Hours: ", scalpingConfig.startHour, "-", scalpingConfig.endHour);
    
    TradingConfig swingConfig = GetSwingConfig();
    Print("Swing Config - Risk: ", swingConfig.riskPercent, 
          "%, ATR Period: ", swingConfig.atrPeriod);
    
    // Test market condition configs
    TradingConfig trendingConfig = GetMarketConditionConfig(MARKET_TRENDING);
    Print("Trending Market Config - Confluence: ", trendingConfig.confluenceScore);
    
    TradingConfig rangingConfig = GetMarketConditionConfig(MARKET_RANGING);
    Print("Ranging Market Config - Liquidity: ", rangingConfig.minLiquidityScore);
    
    TradingConfig volatileConfig = GetMarketConditionConfig(MARKET_VOLATILE);
    Print("Volatile Market Config - Risk: ", volatileConfig.riskPercent, 
          "%, News Avoidance: ", volatileConfig.newsAvoidanceMinutes, " min");
    
    // Test account size based config
    TradingConfig smallAccountConfig = GetAccountSizeConfig(500);
    TradingConfig mediumAccountConfig = GetAccountSizeConfig(5000);
    TradingConfig largeAccountConfig = GetAccountSizeConfig(50000);
    
    Print("Small Account Config ($500) - Risk: ", smallAccountConfig.riskPercent, "%");
    Print("Medium Account Config ($5000) - Risk: ", mediumAccountConfig.riskPercent, "%");
    Print("Large Account Config ($50000) - Risk: ", largeAccountConfig.riskPercent, "%");
    
    // Test pair specific config
    TradingConfig eurUsdConfig = GetPairSpecificConfig("EURUSD");
    TradingConfig gbpJpyConfig = GetPairSpecificConfig("GBPJPY");
    
    Print("EURUSD Config - Risk: ", eurUsdConfig.riskPercent, "%");
    Print("GBPJPY Config - Risk: ", gbpJpyConfig.riskPercent, 
          "%, Confluence: ", gbpJpyConfig.confluenceScore);
    
    // Test time based config
    TradingConfig asianConfig = GetTimeBasedConfig(3); // 3 AM GMT
    TradingConfig londonConfig = GetTimeBasedConfig(10); // 10 AM GMT
    TradingConfig overlapConfig = GetTimeBasedConfig(15); // 3 PM GMT
    TradingConfig nyConfig = GetTimeBasedConfig(20); // 8 PM GMT
    
    Print("Asian Session Config (3 AM) - Risk: ", asianConfig.riskPercent, "%");
    Print("London Session Config (10 AM) - Risk: ", londonConfig.riskPercent, "%");
    Print("Overlap Session Config (3 PM) - Risk: ", overlapConfig.riskPercent, "%");
    Print("NY Session Config (8 PM) - Risk: ", nyConfig.riskPercent, "%");
    
    // Test volatility based config
    TradingConfig highVolConfig = GetVolatilityBasedConfig(0.0020, 0.0010); // 2x average ATR
    TradingConfig lowVolConfig = GetVolatilityBasedConfig(0.0005, 0.0010); // 0.5x average ATR
    
    Print("High Volatility Config - Risk: ", DoubleToString(highVolConfig.riskPercent, 2), 
          "%, Confluence: ", highVolConfig.confluenceScore);
    Print("Low Volatility Config - Confluence: ", lowVolConfig.confluenceScore, 
          ", Liquidity: ", lowVolConfig.minLiquidityScore);
    
    Print("--- Configuration System Test Completed ---");
}

//+------------------------------------------------------------------+
//| Test performance calculations                                    |
//+------------------------------------------------------------------+
void TestPerformanceCalculations()
{
    Print("--- Testing Performance Calculations ---");
    
    // Generate sample return data
    double returns[];
    GenerateTestReturns(returns, InpTestDataPeriod);
    
    // Test Sharpe Ratio calculation
    double sharpe = CalculateSharpeRatio(returns, 252);
    Print("Sharpe Ratio: ", DoubleToString(sharpe, 4));
    
    // Test Recovery Factor
    double totalReturn = 0.25; // 25% return
    double maxDrawdown = 0.10; // 10% max drawdown
    double recovery = CalculateRecoveryFactor(totalReturn, maxDrawdown);
    Print("Recovery Factor (25% return, 10% DD): ", DoubleToString(recovery, 2));
    
    // Test volume analysis
    long volumes[];
    GenerateTestVolumes(volumes, 20);
    double volStrength = CalculateVolumeStrength(volumes, ArraySize(volumes));
    Print("Volume Strength: ", DoubleToString(volStrength, 2));
    
    // Test news impact
    datetime newsTime = TimeCurrent() - 900; // 15 minutes ago
    int impact = GetNewsImpact(newsTime, TimeCurrent());
    string impactStr = (impact == 0) ? "None" : (impact == 1) ? "Low" : 
                      (impact == 2) ? "Medium" : (impact == 3) ? "High" : "Unknown";
    Print("News Impact (15 min ago): ", impactStr);
    
    // Test performance metrics calculation
    PerformanceMetrics metrics = CalculatePerformanceMetrics();
    Print("Sample Performance Metrics:");
    Print("  Win Rate: ", DoubleToString(metrics.winRate, 2), "%");
    Print("  Profit Factor: ", DoubleToString(metrics.profitFactor, 2));
    Print("  Max Drawdown: ", DoubleToString(metrics.maxDrawdown, 2), "%");
    Print("  Expectancy: $", DoubleToString(metrics.expectancy, 2));
    
    Print("--- Performance Calculations Test Completed ---");
}

//+------------------------------------------------------------------+
//| Generate test return data                                        |
//+------------------------------------------------------------------+
void GenerateTestReturns(double &returns[], int period)
{
    ArrayResize(returns, period);
    
    // Generate random returns with slight positive bias
    MathSrand((int)TimeCurrent());
    for (int i = 0; i < period; i++) {
        double random = (MathRand() - 16383.5) / 16383.5; // -1 to 1
        returns[i] = random * 0.02 + 0.0005; // ±2% with 0.05% positive bias
    }
}

//+------------------------------------------------------------------+
//| Generate test volume data                                        |
//+------------------------------------------------------------------+
void GenerateTestVolumes(long &volumes[], int period)
{
    ArrayResize(volumes, period);
    
    MathSrand((int)TimeCurrent() + 1000);
    for (int i = 0; i < period; i++) {
        volumes[i] = 1000 + (MathRand() % 5000); // Random volume 1000-6000
    }
}

//+------------------------------------------------------------------+
//| Calculate sample performance metrics                             |
//+------------------------------------------------------------------+
PerformanceMetrics CalculatePerformanceMetrics()
{
    PerformanceMetrics metrics;
    
    // Sample data for demonstration
    metrics.totalTrades = 100;
    int winningTrades = 65;
    double totalProfit = 15000;
    double totalLoss = -8000;
    
    metrics.winRate = (double)winningTrades / metrics.totalTrades * 100;
    metrics.profitFactor = totalProfit / MathAbs(totalLoss);
    metrics.avgWin = totalProfit / winningTrades;
    metrics.avgLoss = totalLoss / (metrics.totalTrades - winningTrades);
    metrics.expectancy = (metrics.winRate / 100 * metrics.avgWin) + 
                        ((100 - metrics.winRate) / 100 * metrics.avgLoss);
    metrics.maxDrawdown = 12.5; // Sample max drawdown
    metrics.recoveryFactor = (totalProfit + totalLoss) / (metrics.maxDrawdown / 100);
    
    // Calculate Sharpe ratio with sample data
    double returns[];
    GenerateTestReturns(returns, 50);
    metrics.sharpeRatio = CalculateSharpeRatio(returns, 252);
    
    return metrics;
}

//+------------------------------------------------------------------+
//| Test specific EA functions                                       |
//+------------------------------------------------------------------+
void TestEAFunctions()
{
    Print("--- Testing EA-specific Functions ---");
    
    // Test lot size calculation
    double balance = 10000;
    double riskPercent = 2.0;
    double atr = 0.0015;
    
    double riskAmount = balance * (riskPercent / 100.0);
    double stopDistance = atr * 2.0;
    double valuePerPip = 1.0; // Simplified for testing
    double lotSize = riskAmount / (stopDistance * 100000);
    
    Print("Balance: $", balance);
    Print("Risk per trade: ", riskPercent, "%");
    Print("Risk amount: $", riskAmount);
    Print("ATR: ", DoubleToString(atr, 5));
    Print("Stop distance: ", DoubleToString(stopDistance, 5));
    Print("Calculated lot size: ", DoubleToString(lotSize, 2));
    
    // Test confluence scoring
    double currentTrend = 0.7; // Strong uptrend
    double higherTrend = 0.5;  // Medium uptrend
    double confluenceScore = (currentTrend * 40) + (higherTrend * 60);
    if (MathAbs(currentTrend - higherTrend) < 0.3) {
        confluenceScore += 10; // Alignment bonus
    }
    confluenceScore = MathAbs(confluenceScore);
    
    Print("Current TF trend: ", DoubleToString(currentTrend, 2));
    Print("Higher TF trend: ", DoubleToString(higherTrend, 2));
    Print("Confluence score: ", DoubleToString(confluenceScore, 2));
    
    // Test liquidity scoring
    double currentPrice = 1.1050;
    double resistance = 1.1100;
    double support = 1.1000;
    
    double distanceToResistance = (resistance - currentPrice) / 0.00001; // Points
    double distanceToSupport = (currentPrice - support) / 0.00001;
    
    double resistanceStrength = 75; // Sample strength
    double supportStrength = 80;
    
    double liquidityScore = 0;
    liquidityScore += resistanceStrength * (1000 / MathMax(distanceToResistance, 10));
    liquidityScore += supportStrength * (1000 / MathMax(distanceToSupport, 10));
    liquidityScore = MathMin(liquidityScore, 100);
    
    Print("Current price: ", DoubleToString(currentPrice, 5));
    Print("Resistance: ", DoubleToString(resistance, 5), " (strength: ", resistanceStrength, ")");
    Print("Support: ", DoubleToString(support, 5), " (strength: ", supportStrength, ")");
    Print("Distance to resistance: ", DoubleToString(distanceToResistance, 0), " points");
    Print("Distance to support: ", DoubleToString(distanceToSupport, 0), " points");
    Print("Liquidity score: ", DoubleToString(liquidityScore, 2));
    
    Print("--- EA Functions Test Completed ---");
}

//+------------------------------------------------------------------+
//| Validate parameter ranges                                        |
//+------------------------------------------------------------------+
bool ValidateParameters()
{
    Print("--- Validating Parameters ---");
    
    bool valid = true;
    
    // Test parameter bounds
    if (InpTestDataPeriod <= 0 || InpTestDataPeriod > 1000) {
        Print("ERROR: InpTestDataPeriod out of range (1-1000)");
        valid = false;
    }
    
    // Validate configuration values
    TradingConfig config = GetBalancedConfig();
    
    if (config.riskPercent <= 0 || config.riskPercent > 10) {
        Print("ERROR: Risk percent out of range (0-10%)");
        valid = false;
    }
    
    if (config.confluenceScore < 0 || config.confluenceScore > 100) {
        Print("ERROR: Confluence score out of range (0-100)");
        valid = false;
    }
    
    if (config.minLiquidityScore < 0 || config.minLiquidityScore > 100) {
        Print("ERROR: Liquidity score out of range (0-100)");
        valid = false;
    }
    
    if (config.startHour < 0 || config.startHour > 23 || 
        config.endHour < 0 || config.endHour > 23) {
        Print("ERROR: Trading hours out of range (0-23)");
        valid = false;
    }
    
    if (valid) {
        Print("All parameters validated successfully");
    }
    
    Print("--- Parameter Validation Completed ---");
    return valid;
}

//+------------------------------------------------------------------+
//| Performance benchmark test                                       |
//+------------------------------------------------------------------+
void BenchmarkPerformance()
{
    Print("--- Running Performance Benchmark ---");
    
    datetime startTime = GetMicrosecondCount();
    
    // Benchmark moving average calculation
    double prices[1000];
    for (int i = 0; i < 1000; i++) {
        prices[i] = 1.1000 + (MathRand() % 1000) * 0.00001;
    }
    
    for (int i = 0; i < 100; i++) {
        CalculateSMA(prices, 20, 0);
        CalculateEMA(prices, 20, 0);
        CalculateWMA(prices, 20, 0);
    }
    
    datetime endTime = GetMicrosecondCount();
    double elapsedMs = (endTime - startTime) / 1000.0;
    
    Print("MA calculations (300 iterations): ", DoubleToString(elapsedMs, 2), " ms");
    
    // Benchmark correlation calculation
    startTime = GetMicrosecondCount();
    
    double x[100], y[100];
    for (int i = 0; i < 100; i++) {
        x[i] = MathRand() / 32767.0;
        y[i] = MathRand() / 32767.0;
    }
    
    for (int i = 0; i < 50; i++) {
        CalculateCorrelation(x, y);
    }
    
    endTime = GetMicrosecondCount();
    elapsedMs = (endTime - startTime) / 1000.0;
    
    Print("Correlation calculations (50 iterations): ", DoubleToString(elapsedMs, 2), " ms");
    
    Print("--- Performance Benchmark Completed ---");
}