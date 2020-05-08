#include <stdlib.mqh>
#include <button.mqh>
#include <label.mqh>

#property strict
#property script_show_inputs

//--- input parameters
input double inpLots = 1.0;                               // Number of lots
input double inpStopLoss = 1500.0;                        // Stop loss level
input double inpTakeProfit = 1500.0;                      // Take profit level
input int inpSlippage = 0;                                // Slippage value
input int inpMaxNumberOfOrders = 2;                       // Maximum number of open orders
input int inpBreakEvenOffset = 0;                         // BreakEven offset value

input ENUM_BASE_CORNER inpCorner = CORNER_RIGHT_UPPER;    // Chart corner for anchoring
input int inpButtonWidth = 120;                           // Button width
input int inpButtonHeight = 20;                           // Button height
input int inpButtonSpacing = 5;                           // Spaces between buttons
input int inpBackgroundMargin = 10;                       // Background margin
input int inpBackgroundPositionXOffset = 0;               // Background position X offset
input int inpBackgroundPositionYOffset = -10;             // Background position Y offset

input color inpBackgroundBackColor = clrGray;             // Background color
input ENUM_BORDER_TYPE inpBackgroundBorder = BORDER_FLAT; // Border type
input color inpBackgroundBorderColor = clrDarkGray;       // Flat border color (Flat)
input ENUM_LINE_STYLE inpBackgroundStyle = STYLE_SOLID;   // Flat border style (Flat)
input int inpBackgroundLineWidth = 3;                     // Flat border width (Flat)
input bool inpBackgroundHidden = true;                    // Hidden in the object list
input long inpBackgroundZOrder = 0;                       // Priority for mouse click

input string inpBuyText = "BUY";                          // Buy button text
input string inpBuyFont = "Arial";                        // Buy button font
input int inpBuyFontSize = 12;                            // Buy button font size
input color inpBuyColor = clrWhiteSmoke;                  // Buy button text color
input color inpBuyBackColor = clrGreen;                   // Buy button background color
input color inpBuyBorderColor = clrNONE;                  // Buy button border color
input bool inpBuyState = false;                           // Buy button pressed/Released
input bool inpBuyHidden = true;                           // Buy button hidden in the object list
input long inpBuyZOrder = 0;                              // Buy button priority for mouse click

input string inpSellText = "SELL";                        // Sell button text
input string inpSellFont = "Arial";                       // Sell button font
input int inpSellFontSize = 12;                           // Sell button font size
input color inpSellColor = clrWhiteSmoke;                 // Sell button text color
input color inpSellBackColor = clrRed;                    // Sell button background color
input color inpSellBorderColor = clrNONE;                 // Sell button border color
input bool inpSellState = false;                          // Sell button pressed/Released
input bool inpSellHidden = true;                          // Sell button hidden in the object list
input long inpSellZOrder = 0;                             // Sell button priority for mouse click

input string inpCloseText = "CLOSE ALL";                  // Close button text
input string inpCloseFont = "Arial";                      // Close button font
input int inpCloseFontSize = 12;                          // Close button font size
input color inpCloseColor = clrWhiteSmoke;                // Close button text color
input color inpCloseBackColor = clrBlue;                  // Close button background color
input color inpCloseBorderColor = clrNONE;                // Close button border color
input bool inpCloseState = false;                         // Close button pressed/Released
input bool inpCloseHidden = true;                         // Close button hidden in the object list
input long inpCloseZOrder = 0;                            // Close button priority for mouse click

input string inpBreakEvenText = "BREAK EVEN";             // BreakEven button text
input string inpBreakEvenFont = "Arial";                  // BreakEven button font
input int inpBreakEvenFontSize = 12;                      // BreakEven button font size
input color inpBreakEvenColor = clrWhiteSmoke;            // BreakEven button text color
input color inpBreakEvenBackColor = clrLimeGreen;         // BreakEven button background color
input color inpBreakEvenBorderColor = clrNONE;            // BreakEven button border color
input bool inpBreakEvenState = false;                     // BreakEven button pressed/Released
input bool inpBreakEvenHidden = true;                     // BreakEven button hidden in the object list
input long inpBreakEvenZOrder = 0;                        // BreakEven button priority for mouse click

input string inpSLDownText = "";                          // SLDown button text
input string inpSLDownFont = "Arial";                     // SLDown button font
input int inpSLDownFontSize = 12;                         // SLDown button font size
input color inpSLDownColor = clrWhiteSmoke;               // SLDown button text color
input color inpSLDownBackColor = clrDarkOrange;           // SLDown button background color
input color inpSLDownBorderColor = clrNONE;               // SLDown button border color
input bool inpSLDownState = false;                        // SLDown button pressed/Released
input bool inpSLDownHidden = true;                        // SLDown button hidden in the object list
input long inpSLDownZOrder = 0;                           // SLDown button priority for mouse click

input string inpSwapOrderText = "";                       // SwapOrder button text
input string inpSwapOrderFont = "Arial";                  // SwapOrder button font
input int inpSwapOrderFontSize = 12;                      // SwapOrder button font size
input color inpSwapOrderColor = clrWhiteSmoke;            // SwapOrder button text color
input color inpSwapOrderBackColor = clrPurple;            // SwapOrder button background color
input color inpSwapOrderBorderColor = clrNONE;            // SwapOrder button border color
input bool inpSwapOrderState = false;                     // SwapOrder button pressed/Released
input bool inpSwapOrderHidden = true;                     // SwapOrder button hidden in the object list
input long inpSwapOrderZOrder = 0;                        // SwapOrder button priority for mouse click

const string BACKGROUNDID = "Background";
const string BUTTONID1 = "BuyButton";
const string BUTTONID2 = "SellButton";
const string BUTTONID3 = "CloseButton";
const string BUTTONID4 = "BreakEvenButton";
const string BUTTONID5 = "SLDownButton";
const string BUTTONID6 = "SwapOrderButton";

bool backgroundMoveToBack = false;
bool backgroundSelection = false;
bool buttonSelection = false;
bool buttonMoveToBack = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   long windowWidth = GetWindowWidth();
   long windowHeight = GetWindowHeight();
   int numberOfButtons = 6;
   int xBackgroundPosition = (int)(windowWidth / 8) + inpBackgroundPositionXOffset + inpBackgroundMargin;
   int yBackgroundPosition = (int)(windowHeight / 16) + inpBackgroundPositionYOffset;
   
   CreateBackground(BACKGROUNDID, xBackgroundPosition, yBackgroundPosition, inpBackgroundBackColor, inpBackgroundBorder, inpCorner, inpBackgroundBorderColor, 
                  inpBackgroundStyle, inpBackgroundLineWidth, backgroundMoveToBack, backgroundSelection, inpBackgroundHidden, inpBackgroundZOrder, 
                  numberOfButtons, inpButtonWidth, inpButtonHeight, inpButtonSpacing, inpBackgroundMargin);

   int xBuyButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int yBuyButtonPosition = yBackgroundPosition + inpBackgroundMargin;

   CreateButton(BUTTONID1, xBuyButtonPosition, yBuyButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpBuyText, inpBuyFont, inpBuyFontSize, 
               inpBuyColor, inpBuyBackColor, inpBuyBorderColor, inpBuyState, buttonMoveToBack, buttonSelection, inpBuyHidden, inpBuyZOrder); 

   int xSellButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int ySellButtonPosition = yBuyButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(BUTTONID2, xSellButtonPosition, ySellButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpSellText, inpSellFont, inpSellFontSize, 
               inpSellColor, inpSellBackColor, inpSellBorderColor, inpSellState, buttonMoveToBack, buttonSelection, inpSellHidden, inpSellZOrder);

   int xCloseButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int yCloseButtonPosition = ySellButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(BUTTONID3, xCloseButtonPosition, yCloseButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpCloseText, inpCloseFont, inpCloseFontSize, 
               inpCloseColor, inpCloseBackColor, inpCloseBorderColor, inpCloseState, buttonMoveToBack, buttonSelection, inpCloseHidden, inpCloseZOrder);

   int xBreakEvenButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int yBreakEvenButtonPosition = yCloseButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(BUTTONID4, xBreakEvenButtonPosition, yBreakEvenButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpBreakEvenText, inpBreakEvenFont, inpBreakEvenFontSize, 
               inpBreakEvenColor, inpBreakEvenBackColor, inpBreakEvenBorderColor, inpBreakEvenState, buttonMoveToBack, buttonSelection, inpBreakEvenHidden, inpBreakEvenZOrder);

   int xSLDownButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int ySLDownButtonPosition = yBreakEvenButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(BUTTONID5, xSLDownButtonPosition, ySLDownButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpSLDownText, inpSLDownFont, inpSLDownFontSize, 
               inpSLDownColor, inpSLDownBackColor, inpSLDownBorderColor, inpSLDownState, buttonMoveToBack, buttonSelection, inpSLDownHidden, inpSLDownZOrder);

   int xSwapOrderButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int ySwapOrderButtonPosition = ySLDownButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(BUTTONID6, xSwapOrderButtonPosition, ySwapOrderButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpSwapOrderText, inpSwapOrderFont, 
               inpSwapOrderFontSize, inpSwapOrderColor, inpSwapOrderBackColor, inpSwapOrderBorderColor, inpSwapOrderState, buttonMoveToBack, 
               buttonSelection, inpSwapOrderHidden, inpSwapOrderZOrder);

   ChartRedraw(0);
   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if (sparam == BUTTONID1)
   {
      int openOrders = CountOpenOrders();
      if (openOrders < inpMaxNumberOfOrders)
      {
         BuyOrder(inpLots, inpStopLoss, inpTakeProfit, inpSlippage);
      }
      else
      {
         Print("Maximum number of opened orders has been reached!");
      }
   }
   if (sparam == BUTTONID2)
   {
      int openOrders = CountOpenOrders();
      if (openOrders < inpMaxNumberOfOrders)
      {
         SellOrder(inpLots, inpStopLoss, inpTakeProfit, inpSlippage);
      }
      else
      {
         Print("Maximum number of opened orders has been reached!");
      }
   }
   if (sparam == BUTTONID3)
   {
      CloseAllOrders();
   }
   if (sparam == BUTTONID4)
   {
      BreakEven(inpBreakEvenOffset);
   }
   
}

long GetWindowWidth()
{
   long width = 0;
   if (!ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0, width))
   {
      Print("Failed to get the chart width! Error code = ", GetLastError());
   }
   return width;   
}

long GetWindowHeight()
{
   long height = 0;
   if (!ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0, height))
   {
      Print("Failed to get the chart width! Error code = ", GetLastError());
   }
   return height;
}

void BuyOrder(double lots, double stopLoss, double takeProfit, int slippage)
{
   int _ticket = 0;
   int _error = 0;
   RefreshRates();
   double _stoploss = NormalizeDouble(Bid - stopLoss * Point, _Digits);
   double _takeprofit = NormalizeDouble(Bid + takeProfit * Point, _Digits);
   _ticket = OrderSend(Symbol(), OP_BUY, lots, Ask, slippage, _stoploss, _takeprofit);
   if (_ticket > 0)
   {
      if (OrderSelect(_ticket, SELECT_BY_TICKET) == true)
      {
         ObjectSetInteger(0,BUTTONID1, OBJPROP_STATE, false);
         Print("Buy order price is ", OrderOpenPrice());
      }
      else
      {
         Print("Error = ", GetLastError());
      }
      OrderPrint();
   }
   else
   {
      _error = GetLastError();
      Print("Error = ", ErrorDescription(_error));
   }
}

void SellOrder(double lots, double stopLoss, double takeProfit, int slippage)
{
   int _ticket = 0;
   int _error = 0;
   RefreshRates();
   double _stoploss = NormalizeDouble(Ask + stopLoss * Point, _Digits);
   double _takeprofit = NormalizeDouble(Ask - takeProfit * Point, _Digits);
   _ticket = OrderSend(Symbol(), OP_SELL, lots, Bid, slippage, _stoploss, _takeprofit);
   if (_ticket > 0)
   {
      if (OrderSelect(_ticket, SELECT_BY_TICKET) == true)
      {
         ObjectSetInteger(0, BUTTONID2, OBJPROP_STATE, false);
         Print("Sell order price is ", OrderOpenPrice());
      }
      else
      {
         Print("Error = ", GetLastError());
      }
      OrderPrint();
   }
   else
   {
      _error = GetLastError();
      Print("Error = ", ErrorDescription(_error));
   }
}

int CountOpenOrders()
{
   int count = 0;
   int total = OrdersTotal();

   for (int pos = 0; pos < total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS))
      {
         count++;
      }
   }
   return count;
}

void CloseAllOrders()
{
   int _ticket = 0;
   int total = OrdersTotal();

   for (int pos = total; pos >= 0; pos--)
   {
      if (OrderSelect(pos, SELECT_BY_POS) && OrderSymbol() == _Symbol)
      {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL)
         {
            _ticket = OrderClose(OrderTicket(), OrderLots(), MarketInfo(_Symbol,MODE_ASK), 0);
            _ticket = OrderClose(OrderTicket(), OrderLots(), MarketInfo(_Symbol,MODE_BID), 0);
         }
         if (_ticket > 0)
         {
            Print("Order closed");
         }
         else
         {
            Print("Error = ", GetLastError());
         }
      }
   }
   ObjectSetInteger(0, BUTTONID3, OBJPROP_STATE, false);
   Print("Closed all orders");
}

void BreakEven(int offset)
{
   int total = OrdersTotal();
   double _openPrice, _stoploss = 0;

   for (int pos = 0; pos < total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS))
      {
         _openPrice = OrderOpenPrice();
         _stoploss = NormalizeDouble(_openPrice + offset * _Point, _Digits);
         if (OrderModify(OrderTicket(), OrderOpenPrice(), _stoploss, OrderTakeProfit(), 0))
         {
            Print("Stoploss modified");
         }
         else
         {
            Print("Error = ", GetLastError());
         }
      }
   }
   ObjectSetInteger(0, BUTTONID4, OBJPROP_STATE, false);
   Print("Modified all orders");
}