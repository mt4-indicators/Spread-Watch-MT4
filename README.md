# Spread Watch Indicator MT4

Plots the spread of every candle in pips (from the history MT4 stores) with its moving average, and shows the live spread, today's average and maximum in the window title. Alerts when the spread goes above a limit.

**Full guide, settings explained and strategy examples:** [Spread Watch Indicator MT4 on mt4indicators.com](https://mt4indicators.com/mt4-indicator/spread-watch-mt4-indicator/)

## Features
- Free and open source (MIT licence), MQL4 source included
- Non-repainting: signals are calculated on closed candles and do not move once drawn.
- Works on any symbol and timeframe in MetaTrader 4 (build 600 or later)

## Inputs
| Input | Default | What it does |
|---|---|---|
| `MaxSpreadPips` | `2.0` | High-spread limit (pips) |
| `AveragePeriod` | `20` | Candles in the moving average |
| `AlertAboveMax` | `false` | Alert when the live spread goes above the limit |
| `PushAboveMax` | `false` | Push notification when above the limit |
| `AlertCooldownMin` | `15` | Minutes between alerts |

## Installation
1. Download `Spread-Watch.mq4` from this repository.
2. In MetaTrader 4 open **File → Open Data Folder → MQL4 → Indicators** and copy the file there.
3. Right-click **Indicators** in the Navigator and choose **Refresh** (or restart MT4).
4. Drag the indicator onto a chart.

Step-by-step screenshots: [How to install indicators in MT4](https://mt4indicators.com/how-to-install-indicators-mt4/).

## More free indicators
Browse 70+ free MetaTrader indicators, each checked for repainting, at [mt4indicators.com](https://mt4indicators.com/mt4-indicators/).

## Disclaimer
Trading foreign exchange on margin carries a high level of risk. This indicator is a charting tool, not trading advice. Test it on a demo account first.
