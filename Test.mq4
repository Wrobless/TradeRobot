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

input string inpSLUPText = "SL UP";                       // SLUP button text
input string inpSLUPFont = "Arial";                       // SLUP button font
input int inpSLUPFontSize = 12;                           // SLUP button font size
input color inpSLUPColor = clrWhiteSmoke;                 // SLUP button text color
input color inpSLUPBackColor = clrLimeGreen;              // SLUP button background color
input color inpSLUPBorderColor = clrNONE;                 // SLUP button border color
input bool inpSLUPState = false;                          // SLUP button pressed/Released
input bool inpSLUPHidden = true;                          // SLUP button hidden in the object list
input long inpSLUPZOrder = 0;                             // SLUP button priority for mouse click

input string inpSLDownText = "SL DOWN";                   // SLDown button text
input string inpSLDownFont = "Arial";                     // SLDown button font
input int inpSLDownFontSize = 12;                         // SLDown button font size
input color inpSLDownColor = clrWhiteSmoke;               // SLDown button text color
input color inpSLDownBackColor = clrDarkOrange;           // SLDown button background color
input color inpSLDownBorderColor = clrNONE;               // SLDown button border color
input bool inpSLDownState = false;                        // SLDown button pressed/Released
input bool inpSLDownHidden = true;                        // SLDown button hidden in the object list
input long inpSLDownZOrder = 0;                           // SLDown button priority for mouse click

input string inpSwapOrderText = "SWAP ORDER";             // SwapOrder button text
input string inpSwapOrderFont = "Arial";                  // SwapOrder button font
input int inpSwapOrderFontSize = 12;                      // SwapOrder button font size
input color inpSwapOrderColor = clrWhiteSmoke;            // SwapOrder button text color
input color inpSwapOrderBackColor = clrPurple;            // SwapOrder button background color
input color inpSwapOrderBorderColor = clrNONE;            // SwapOrder button border color
input bool inpSwapOrderState = false;                     // SwapOrder button pressed/Released
input bool inpSwapOrderHidden = true;                     // SwapOrder button hidden in the object list
input long inpSwapOrderZOrder = 0;                        // SwapOrder button priority for mouse click

const string BACKGROUNDID = "Background";
bool backgroundMoveToBack = true;
bool backgroundSelection = false;

const string BUYBUTTONID = "BuyButton";
bool buyButtonSelection = false;
bool buyButtonMoveToBack = false;

const string SELLBUTTONID = "SellButton";
bool sellButtonSelection = false;
bool sellButtonMoveToBack = false;

const string CLOSEBUTTONID = "CloseButton";
bool closeButtonSelection = false;
bool closeButtonMoveToBack = false;

const string SLUPBUTTONID = "SLUPButton";
bool sLUPButtonSelection = false;
bool sLUPButtonMoveToBack = false;

const string SLDOWNBUTTONID = "SLDownButton";
bool sLDownButtonSelection = false;
bool sLDownButtonMoveToBack = false;

const string SWAPORDERBUTTONID = "SwapOrderButton";
bool swapOrderButtonSelection = false;
bool swapOrderButtonMoveToBack = false;

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

   CreateButton(BUYBUTTONID, xBuyButtonPosition, yBuyButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpBuyText, inpBuyFont, inpBuyFontSize, 
               inpBuyColor, inpBuyBackColor, inpBuyBorderColor, inpBuyState, buyButtonMoveToBack, buyButtonSelection, inpBuyHidden, inpBuyZOrder); 

   int xSellButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int ySellButtonPosition = yBuyButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(SELLBUTTONID, xSellButtonPosition, ySellButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpSellText, inpSellFont, inpSellFontSize, 
               inpSellColor, inpSellBackColor, inpSellBorderColor, inpSellState, sellButtonMoveToBack, sellButtonSelection, inpSellHidden, inpSellZOrder);

   int xCloseButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int yCloseButtonPosition = ySellButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(CLOSEBUTTONID, xCloseButtonPosition, yCloseButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpCloseText, inpCloseFont, inpCloseFontSize, 
               inpCloseColor, inpCloseBackColor, inpCloseBorderColor, inpCloseState, closeButtonMoveToBack, closeButtonSelection, inpCloseHidden, inpCloseZOrder);

   int xSLUPButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int ySLUPButtonPosition = yCloseButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(SLUPBUTTONID, xSLUPButtonPosition, ySLUPButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpSLUPText, inpSLUPFont, inpSLUPFontSize, 
               inpSLUPColor, inpSLUPBackColor, inpSLUPBorderColor, inpSLUPState, sLUPButtonMoveToBack, sLUPButtonSelection, inpSLUPHidden, inpSLUPZOrder);

   int xSLDownButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int ySLDownButtonPosition = ySLUPButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(SLDOWNBUTTONID, xSLDownButtonPosition, ySLDownButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpSLDownText, inpSLDownFont, inpSLDownFontSize, 
               inpSLDownColor, inpSLDownBackColor, inpSLDownBorderColor, inpSLDownState, sLDownButtonMoveToBack, sLDownButtonSelection, inpSLDownHidden, inpSLDownZOrder);

   int xSwapOrderButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   int ySwapOrderButtonPosition = ySLDownButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(SWAPORDERBUTTONID, xSwapOrderButtonPosition, ySwapOrderButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpSwapOrderText, inpSwapOrderFont, 
               inpSwapOrderFontSize, inpSwapOrderColor, inpSwapOrderBackColor, inpSwapOrderBorderColor, inpSwapOrderState, swapOrderButtonMoveToBack, 
               swapOrderButtonSelection, inpSwapOrderHidden, inpSwapOrderZOrder);

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
   if (sparam == BUYBUTTONID)
   {
      int openOrders = CountOpenOrders(OP_BUY);
      if (openOrders < inpMaxNumberOfOrders)
      {
         BuyOrder(inpLots, inpStopLoss, inpTakeProfit, inpSlippage);
      }
      else
      {
         Print("Maximum number of opened orders has been reached!");
      }
   }
   if (sparam == SELLBUTTONID)
   {
      int openOrders = CountOpenOrders(OP_SELL);
      if (openOrders < inpMaxNumberOfOrders)
      {
         SellOrder(inpLots, inpStopLoss, inpTakeProfit, inpSlippage);
      }
      else
      {
         Print("Maximum number of opened orders has been reached!");
      }
   }
   if (sparam == CLOSEBUTTONID)
   {
      CloseAllOrders();
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
         ObjectSetInteger(0,BUYBUTTONID, OBJPROP_STATE, false);
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
         ObjectSetInteger(0, SELLBUTTONID, OBJPROP_STATE, false);
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

int CountOpenOrders(int orderType)
{
   int type;
   int count = 0;
   int total = OrdersTotal();

   for (int pos = 0; pos < total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS))
      {
         type = OrderType();
         if (type == orderType)
         {
            count++;
         }
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
            Print("Closed all orders.");
         }
         else
         {
            Print("Error = ", GetLastError());
         }
      }
   }
   ObjectSetInteger(0, CLOSEBUTTONID, OBJPROP_STATE, false);
}