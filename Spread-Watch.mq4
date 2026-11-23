//+------------------------------------------------------------------+
//| Spread Watch.mq4                                                  |
//| Live spread with its average and maximum, and a high-spread alert.|
//| Free download and guide:                                           |
//| https://mt4indicators.com/mt4-indicator/spread-watch-mt4-indicator/ |
//+------------------------------------------------------------------+
#property copyright   "mt4indicators.com"
#property link        "https://mt4indicators.com/mt4-indicator/spread-watch-mt4-indicator/"
#property version     "1.00"
#property description "Plots the spread of every candle in pips (from the history MT4 stores)"
#property description "with its moving average, and shows the live spread, today's average and"
#property description "maximum in the window title. Alerts when the spread goes above a limit."
#property strict
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_plots   3
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrSilver
#property indicator_width1  2
#property indicator_label1  "Spread (pips)"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrOrangeRed
#property indicator_width2  2
#property indicator_label2  "Above limit"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrDodgerBlue
#property indicator_width3  1
#property indicator_label3  "Average"
#property indicator_minimum 0

input double MaxSpreadPips  = 2.0;   // High-spread limit (pips)
input int    AveragePeriod  = 20;    // Candles in the moving average
input bool   AlertAboveMax  = false; // Alert when the live spread goes above the limit
input bool   PushAboveMax   = false; // Push notification when above the limit
input int    AlertCooldownMin = 15;  // Minutes between alerts

double bufS[], bufHi[], bufAvg[];
datetime lastAlert = 0;
double PipSize() { return (Digits == 3 || Digits == 5) ? Point * 10 : Point; }

int OnInit()
{
   SetIndexBuffer(0, bufS);   SetIndexEmptyValue(0, EMPTY_VALUE);
   SetIndexBuffer(1, bufHi);  SetIndexEmptyValue(1, EMPTY_VALUE);
   SetIndexBuffer(2, bufAvg); SetIndexEmptyValue(2, EMPTY_VALUE);
   IndicatorDigits(1);
   SetLevelValue(0, MaxSpreadPips); SetLevelStyle(STYLE_DOT, 1, clrOrangeRed);
   IndicatorShortName("Spread Watch");
   return INIT_SUCCEEDED;
}

int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[],
                const double &high[], const double &low[], const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[])
{
   ArraySetAsSeries(spread, true); ArraySetAsSeries(time, true);
   double pip = PipSize();
   int limit = (prev_calculated > 0) ? rates_total - prev_calculated + 1 : rates_total;
   if(limit > rates_total) limit = rates_total;
   for(int i = limit - 1; i >= 0; i--)
   {
      double s = (i == 0) ? (Ask - Bid) / pip : spread[i] * Point / pip;   // history stores each bar's spread in points
      bufS[i] = s;
      bufHi[i] = (s > MaxSpreadPips) ? s : EMPTY_VALUE;
   }
   for(int i = limit - 1; i >= 0; i--)
   {
      if(i + AveragePeriod > rates_total) { bufAvg[i] = EMPTY_VALUE; continue; }
      double sum = 0; for(int k = 0; k < AveragePeriod; k++) sum += bufS[i + k];
      bufAvg[i] = sum / AveragePeriod;
   }
   // today's average and maximum
   double sum = 0, mx = 0; int n = 0; int day = TimeDayOfYear(time[0]);
   for(int i = 0; i < rates_total && TimeDayOfYear(time[i]) == day; i++) { sum += bufS[i]; mx = MathMax(mx, bufS[i]); n++; }
   IndicatorShortName(StringFormat("Spread Watch  now %.1f  avg today %.1f  max today %.1f pips", bufS[0], n ? sum / n : 0, mx));
   if((AlertAboveMax || PushAboveMax) && bufS[0] > MaxSpreadPips && TimeCurrent() - lastAlert >= AlertCooldownMin * 60)
   {
      lastAlert = TimeCurrent();
      string msg = StringFormat("%s spread %.1f pips is above %.1f", Symbol(), bufS[0], MaxSpreadPips);
      if(AlertAboveMax) Alert(msg);
      if(PushAboveMax) SendNotification(msg);
   }
   return rates_total;
}
