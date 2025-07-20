# LiquidityBot v3.03 - Installation and Setup Guide

## Prerequisites

### MetaTrader 5 Requirements
- MetaTrader 5 Terminal (build 3060 or higher)
- MetaEditor for compilation
- Active trading account (demo or live)
- Stable internet connection

### Recommended System Requirements
- Windows 10/11 or Windows Server 2016+
- 4GB RAM minimum (8GB recommended)
- Dual-core processor minimum (quad-core recommended)
- VPS recommended for 24/7 operation

## Installation Steps

### 1. File Preparation
1. Download all LiquidityBot v3.03 files:
   - `LiquidityBot_v3.03.mq5` (main EA file)
   - `LiquidityBot_Utils.mqh` (utility functions)
   - `LiquidityBot_Config.mqh` (configuration presets)
   - `LiquidityBot_Test.mq5` (testing script)
   - `README.md` (documentation)

### 2. File Placement
1. Open your MetaTrader 5 data folder:
   - In MT5, go to `File > Open Data Folder`
   - Navigate to `MQL5` folder

2. Copy files to appropriate locations:
   ```
   MQL5/
   ├── Experts/
   │   └── LiquidityBot_v3.03.mq5
   ├── Include/
   │   ├── LiquidityBot_Utils.mqh
   │   └── LiquidityBot_Config.mqh
   └── Scripts/
       └── LiquidityBot_Test.mq5
   ```

### 3. Compilation
1. Open MetaEditor (F4 in MT5 or click MetaEditor icon)
2. Open `LiquidityBot_v3.03.mq5`
3. Press F7 to compile
4. Ensure compilation completes without errors
5. Check "Errors" tab for any issues

### 4. Testing Setup (Recommended)
1. First run the test script:
   - Compile `LiquidityBot_Test.mq5`
   - Attach to any chart and run
   - Verify all tests pass

## Chart Setup

### 1. Chart Configuration
1. Open desired currency pair chart (recommended: EURUSD, GBPUSD)
2. Set timeframe to M5 (recommended primary timeframe)
3. Ensure chart has sufficient history (at least 1000 bars)

### 2. EA Attachment
1. From Navigator panel, locate "LiquidityBot_v3.03" under Expert Advisors
2. Drag and drop onto chart
3. EA parameters dialog will appear

### 3. Parameter Configuration

#### Basic Setup (Recommended for beginners):
```
=== Basic Settings ===
InpRiskPercent = 2.0          // 2% risk per trade
InpMagicNumber = 230303       // Unique identifier
InpUseATRSizing = true        // Enable dynamic sizing
InpATRPeriod = 14             // Standard ATR period

=== Multi-timeframe Settings ===
InpUseD1Filter = true         // Enable D1 filter
InpHigherTF = PERIOD_D1       // Daily timeframe
InpTrendPeriod = 50           // EMA trend period
InpConfluenceScore = 75.0     // Minimum confluence score

=== Time Filters ===
InpUseTimeFilter = true       // Enable session filtering
InpStartHour = 8              // London session start
InpEndHour = 22               // NY session end
InpAvoidNews = true           // Avoid news times
InpNewsAvoidanceMinutes = 30  // 30 min buffer

=== Liquidity Settings ===
InpMinLiquidityScore = 80.0   // Good liquidity threshold
InpLiquidityLookback = 100    // 100 bars lookback
InpLiquidityMinVolume = 1000  // Minimum volume

=== Risk Management ===
InpUseTrailingStop = true     // Enable trailing stops
InpMaxDailyLoss = 5.0         // 5% daily loss limit
InpMaxWeeklyLoss = 10.0       // 10% weekly loss limit
InpCorrelationLimit = 0.7     // 70% max correlation

=== Entry Logic ===
InpUseSmartEntry = true       // Enable smart timing
InpRSIPeriod = 14             // Standard RSI
InpRSIOverBought = 70         // Overbought level
InpRSIOverSold = 30           // Oversold level

=== Performance Monitoring ===
InpEnableMonitoring = true    // Enable live tracking
InpAutoAdjustment = false     // Disable auto-adjustment initially
InpMonitoringPeriod = 100     // Performance period
```

### 4. Enable Trading
1. Ensure "AutoTrading" is enabled (green button in toolbar)
2. Check "Allow DLL imports" in Common tab if required
3. Set "Allow live trading" in Common tab
4. Click "OK" to attach EA

## Initial Testing

### 1. Demo Account Testing
**ALWAYS test on demo account first**
1. Attach EA to demo account chart
2. Use conservative settings initially
3. Monitor for at least 24-48 hours
4. Review trade journal and performance

### 2. Parameter Optimization
1. Use Strategy Tester for historical backtesting
2. Test different parameter combinations
3. Focus on reducing drawdown first
4. Optimize for consistent performance, not maximum profit

### 3. Forward Testing
1. Run EA on demo for at least 2 weeks
2. Monitor all market conditions
3. Verify risk management is working
4. Check performance during news events

## Live Account Transition

### 1. Pre-Live Checklist
- [ ] Successful demo testing completed
- [ ] Parameters optimized for your risk tolerance
- [ ] Risk management limits set appropriately
- [ ] VPS setup if required
- [ ] Account balance sufficient for minimum lot sizes

### 2. Live Account Setup
1. Start with smallest position sizes
2. Monitor closely for first week
3. Gradually increase risk if performance is satisfactory
4. Keep detailed records of all trades

### 3. Ongoing Monitoring
1. Check EA status daily
2. Monitor drawdown levels
3. Review performance weekly
4. Adjust parameters based on market conditions

## Troubleshooting Common Issues

### EA Not Opening Trades
**Possible Causes & Solutions:**
1. **Confluence score too high**: Reduce `InpConfluenceScore` to 65-70
2. **Liquidity threshold too strict**: Reduce `InpMinLiquidityScore` to 75
3. **Time filters too restrictive**: Check trading hours match your timezone
4. **Insufficient account balance**: Ensure adequate funds for minimum lot size
5. **Market conditions**: EA may wait for proper setups

### Compilation Errors
**Common Issues:**
1. **Missing include files**: Ensure all .mqh files are in Include folder
2. **Wrong MT5 version**: Update to latest build
3. **Syntax errors**: Check for any manual modifications

### Unexpected Behavior
**Debugging Steps:**
1. Check Expert tab in Terminal for error messages
2. Enable detailed logging in parameters
3. Verify magic number is unique
4. Check account trading permissions

### Performance Issues
**Optimization Tips:**
1. **High drawdown**: Increase confluence score, reduce risk
2. **Too few trades**: Reduce thresholds, extend trading hours
3. **Poor win rate**: Increase liquidity requirements
4. **Large losses**: Check stop loss calculations and risk management

## Advanced Configuration

### 1. Using Configuration Presets
The EA includes pre-built configurations for different trading styles:

```mql5
// In LiquidityBot_Config.mqh
TradingConfig config = GetConservativeConfig();  // Low risk
TradingConfig config = GetAggressiveConfig();    // Higher risk
TradingConfig config = GetScalpingConfig();      // Quick trades
TradingConfig config = GetSwingConfig();         // Longer trades
```

### 2. Market Condition Adaptation
```mql5
TradingConfig config = GetMarketConditionConfig(MARKET_TRENDING);
TradingConfig config = GetMarketConditionConfig(MARKET_RANGING);
TradingConfig config = GetMarketConditionConfig(MARKET_VOLATILE);
```

### 3. Multiple Timeframes
- Primary: M5 (recommended for entries)
- Secondary: H1 (for confluence)
- Trend Filter: D1 (for overall direction)

### 4. Multiple Pairs
When running on multiple pairs:
1. Use different magic numbers
2. Monitor correlation between pairs
3. Adjust total risk across all pairs
4. Consider market overlap times

## Monitoring and Maintenance

### Daily Tasks
- [ ] Check EA status and error log
- [ ] Review overnight trades
- [ ] Monitor drawdown levels
- [ ] Verify risk limits are respected

### Weekly Tasks
- [ ] Analyze performance metrics
- [ ] Review win rate and profit factor
- [ ] Check for any system issues
- [ ] Update market condition settings if needed

### Monthly Tasks
- [ ] Complete performance review
- [ ] Consider parameter adjustments
- [ ] Backup trading history
- [ ] Review and update risk limits

## Support and Updates

### Getting Help
1. Check this documentation first
2. Review error logs in MT5 terminal
3. Test with demo account to isolate issues
4. Check parameter settings against recommendations

### Performance Optimization
1. Focus on consistency over maximum profit
2. Prioritize drawdown control
3. Adapt to changing market conditions
4. Regular backtesting with updated data

### Best Practices
1. Never risk more than you can afford to lose
2. Always test on demo first
3. Keep detailed trading records
4. Regular monitoring and adjustment
5. Stay informed about market conditions

---

**RISK WARNING**: Trading foreign exchange on margin carries a high level of risk and may not be suitable for all investors. The high degree of leverage can work against you as well as for you. Before deciding to invest in foreign exchange, you should carefully consider your investment objectives, level of experience, and risk appetite.