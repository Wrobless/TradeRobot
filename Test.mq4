#include <stdlib.mqh>
#include <button.mqh>
#include <label.mqh>

#property strict
#property script_show_inputs

//--- input parameters
input double inpLots = 1.0;                               // Number of lots
input double inpStopLoss = 1500.0;                        // Stop loss level
input double inpTakeProfit = 4500.0;                      // Take profit level
input int inpSlippage = 0;                                // Slippage value
input int inpMaxNumberOfOrders = 2;                       // Maximum number of open orders
input int inpBreakEvenOffset = -100;                      // BreakEven offset value

input int inpButtonWidth = 80;                            // Button width
input int inpButtonHeight = 30;                           // Button height
input int inpButtonSpacing = 5;                           // Spaces between buttons
input int inpBackgroundMargin = 10;                       // Background margin
input int inpBackgroundPositionXOffset = -30;             // Background position X offset
input int inpBackgroundPositionYOffset = -10;             // Background position Y offset

// input color inpBackgroundBackColor = clrGray;             // Background color
// input ENUM_BORDER_TYPE inpBackgroundBorder = BORDER_FLAT; // Border type
// input color inpBackgroundBorderColor = clrDarkGray;       // Flat border color (Flat)
// input ENUM_LINE_STYLE inpBackgroundStyle = STYLE_SOLID;   // Flat border style (Flat)
// input int inpBackgroundLineWidth = 3;                     // Flat border width (Flat)
// input bool inpBackgroundHidden = true;                    // Hidden in the object list
// input long inpBackgroundZOrder = 0;                       // Priority for mouse click

input string inpBuyText = "BUY";                          // Buy button text
input string inpBuyFont = "Arial";                        // Buy button font
input int inpBuyFontSize = 10;                            // Buy button font size
input color inpBuyColor = clrWhiteSmoke;                  // Buy button text color
input color inpBuyBackColor = clrGreen;                   // Buy button background color
input color inpBuyBorderColor = clrNONE;                  // Buy button border color
input bool inpBuyState = false;                           // Buy button pressed/Released
input bool inpBuyHidden = true;                           // Buy button hidden in the object list
input long inpBuyZOrder = 0;                              // Buy button priority for mouse click

input string inpSellText = "SELL";                        // Sell button text
input string inpSellFont = "Arial";                       // Sell button font
input int inpSellFontSize = 10;                           // Sell button font size
input color inpSellColor = clrWhiteSmoke;                 // Sell button text color
input color inpSellBackColor = clrRed;                    // Sell button background color
input color inpSellBorderColor = clrNONE;                 // Sell button border color
input bool inpSellState = false;                          // Sell button pressed/Released
input bool inpSellHidden = true;                          // Sell button hidden in the object list
input long inpSellZOrder = 0;                             // Sell button priority for mouse click

input string inpCloseText = "CLOSE ALL";                  // Close button text
input string inpCloseFont = "Arial";                      // Close button font
input int inpCloseFontSize = 10;                          // Close button font size
input color inpCloseColor = clrWhiteSmoke;                // Close button text color
input color inpCloseBackColor = clrDeepSkyBlue;           // Close button background color
input color inpCloseBorderColor = clrNONE;                // Close button border color
input bool inpCloseState = false;                         // Close button pressed/Released
input bool inpCloseHidden = true;                         // Close button hidden in the object list
input long inpCloseZOrder = 0;                            // Close button priority for mouse click

input string inpBreakEvenText = "BE";                     // BreakEven button text
input string inpBreakEvenFont = "Arial";                  // BreakEven button font
input int inpBreakEvenFontSize = 10;                      // BreakEven button font size
input color inpBreakEvenColor = clrWhiteSmoke;            // BreakEven button text color
input color inpBreakEvenBackColor = clrLimeGreen;         // BreakEven button background color
input color inpBreakEvenBorderColor = clrNONE;            // BreakEven button border color
input bool inpBreakEvenState = false;                     // BreakEven button pressed/Released
input bool inpBreakEvenHidden = true;                     // BreakEven button hidden in the object list
input long inpBreakEvenZOrder = 0;                        // BreakEven button priority for mouse click

input string inpMoveSLText = "MOVE SL";                   // MoveSL button text
input string inpMoveSLFont = "Arial";                     // MoveSL button font
input int inpMoveSLFontSize = 10;                         // MoveSL button font size
input color inpMoveSLColor = clrWhiteSmoke;               // MoveSL button text color
input color inpMoveSLBackColor = clrDarkOrange;           // MoveSL button background color
input color inpMoveSLBorderColor = clrNONE;               // MoveSL button border color
input bool inpMoveSLState = false;                        // MoveSL button pressed/Released
input bool inpMoveSLHidden = true;                        // MoveSL button hidden in the object list
input long inpMoveSLZOrder = 0;                           // MoveSL button priority for mouse click

// input string inpSwapOrderText = "";                       // SwapOrder button text
// input string inpSwapOrderFont = "Arial";                  // SwapOrder button font
// input int inpSwapOrderFontSize = 10;                      // SwapOrder button font size
// input color inpSwapOrderColor = clrWhiteSmoke;            // SwapOrder button text color
// input color inpSwapOrderBackColor = clrPurple;            // SwapOrder button background color
// input color inpSwapOrderBorderColor = clrNONE;            // SwapOrder button border color
// input bool inpSwapOrderState = false;                     // SwapOrder button pressed/Released
// input bool inpSwapOrderHidden = true;                     // SwapOrder button hidden in the object list
// input long inpSwapOrderZOrder = 0;                        // SwapOrder button priority for mouse click

const ENUM_BASE_CORNER inpCorner = CORNER_RIGHT_UPPER;       // Chart corner for anchoring

const string BACKGROUNDID = "Background";
const string BUTTONID1 = "BuyButton";
const string BUTTONID2 = "SellButton";
const string BUTTONID3 = "CloseButton";
const string BUTTONID4 = "BreakEvenButton";
const string BUTTONID5 = "MoveSLButton";
const string BUTTONID6 = "";

bool backgroundMoveToBack = false;
bool backgroundSelection = false;
bool buttonSelection = false;
bool buttonMoveToBack = false;

int xMoveSLButtonPosition;
int yMoveSLButtonPosition;

bool flag = false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   long windowWidth = GetWindowWidth();
   long windowHeight = GetWindowHeight();
   int numberOfButtons = 5;
   int xBackgroundPosition = (int)(windowWidth / 8) + inpBackgroundPositionXOffset + inpBackgroundMargin;
   int yBackgroundPosition = (int)(windowHeight / 16) + inpBackgroundPositionYOffset;
   
   // CreateBackground(BACKGROUNDID, xBackgroundPosition, yBackgroundPosition, inpBackgroundBackColor, inpBackgroundBorder, inpCorner, inpBackgroundBorderColor, 
   //                inpBackgroundStyle, inpBackgroundLineWidth, backgroundMoveToBack, backgroundSelection, inpBackgroundHidden, inpBackgroundZOrder, 
   //                numberOfButtons, inpButtonWidth, inpButtonHeight, inpButtonSpacing, inpBackgroundMargin);

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

   xMoveSLButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   yMoveSLButtonPosition = yBreakEvenButtonPosition + inpButtonHeight + inpButtonSpacing;

   CreateButton(BUTTONID5, xMoveSLButtonPosition, yMoveSLButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpMoveSLText, inpMoveSLFont, inpMoveSLFontSize, 
               inpMoveSLColor, inpMoveSLBackColor, inpMoveSLBorderColor, inpMoveSLState, buttonMoveToBack, buttonSelection, inpMoveSLHidden, inpMoveSLZOrder);

   // int xSwapOrderButtonPosition = xBackgroundPosition - inpBackgroundMargin;
   // int ySwapOrderButtonPosition = yMoveSLButtonPosition + inpButtonHeight + inpButtonSpacing;

   // CreateButton(BUTTONID6, xSwapOrderButtonPosition, ySwapOrderButtonPosition, inpButtonWidth, inpButtonHeight, inpCorner, inpSwapOrderText, inpSwapOrderFont, 
   //             inpSwapOrderFontSize, inpSwapOrderColor, inpSwapOrderBackColor, inpSwapOrderBorderColor, inpSwapOrderState, buttonMoveToBack, 
   //             buttonSelection, inpSwapOrderHidden, inpSwapOrderZOrder);

   ChartRedraw(0);
   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll();
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
   if (id == CHARTEVENT_OBJECT_CLICK && sparam == BUTTONID1)
   {
      int openOrders = CountOpenOrders();
      if (openOrders < inpMaxNumberOfOrders)
         OpenOrder(BUTTONID1, OP_BUY, inpLots, inpStopLoss, inpTakeProfit, inpSlippage);
      else
      {
         Print("Maximum number of opened orders has been reached!");
         ObjectSetInteger(0, BUTTONID1, OBJPROP_STATE, false);
      }
   }

   if (id == CHARTEVENT_OBJECT_CLICK && sparam == BUTTONID2)
   {
      int openOrders = CountOpenOrders();
      if (openOrders < inpMaxNumberOfOrders)
         OpenOrder(BUTTONID2, OP_SELL, inpLots, inpStopLoss, inpTakeProfit, inpSlippage);
      else
      {
         Print("Maximum number of opened orders has been reached!");
         ObjectSetInteger(0, BUTTONID2, OBJPROP_STATE, false);
      }
   }

   if (id == CHARTEVENT_OBJECT_CLICK && sparam == BUTTONID3)
      CloseAllOrders();

   if (id == CHARTEVENT_OBJECT_CLICK && sparam == BUTTONID4)
      BreakEven(inpBreakEvenOffset);

   if (id == CHARTEVENT_CLICK && sparam != BUTTONID5)
   {
      MoveSL(BUTTONID5, lparam, dparam);
   } 
}

long GetWindowWidth()
{
   long width = 0;
   if (!ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0, width))
      Print("Failed to get the chart width! Error code = ", GetLastError());
   return width;   
}

long GetWindowHeight()
{
   long height = 0;
   if (!ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0, height))
      Print("Failed to get the chart width! Error code = ", GetLastError());
   return height;
}

void OpenOrder(string buttonID, int cmd, double lots, double stopLoss, double takeProfit, int slippage)
{
   RefreshRates();
   int ticket = 0;
   int error = 0;
   static int orderCount;
   int price = (cmd == OP_BUY) ? Ask : Bid;

   double _stopLoss = (cmd == OP_BUY) ? NormalizeDouble(Bid - stopLoss * _Point, _Digits) : NormalizeDouble(Ask + stopLoss * _Point, _Digits);
   double _takeProfit = (cmd == OP_BUY) ? NormalizeDouble(Bid + takeProfit * _Point, _Digits) : NormalizeDouble(Ask - takeProfit * _Point, _Digits);

   if (!OrderLimit(orderCount))
   {
      ticket = OrderSend(Symbol(), cmd, lots, price, slippage, _stopLoss, _takeProfit);
   
      if (ticket > 0)
      {
         if (OrderSelect(ticket, SELECT_BY_TICKET) == true)
         {
            ObjectSetInteger(0, buttonID, OBJPROP_STATE, false);
            OrderPrint();
            orderCount = OrderCounter();
         }
         else
            Print("Error = ", GetLastError());
      }
      else
      {
         error = GetLastError();
         Print("Error = ", ErrorDescription(error));
      }
   }
   else
   {
      MessageBox("You've reached order limit (10) for today!", "Warning!");
      ObjectSetInteger(0, buttonID, OBJPROP_STATE, false);
   }
}

int CountOpenOrders()
{
   int count = 0;
   int total = OrdersTotal();

   for (int pos = 0; pos < total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS))
         count++;
   }
   return count;
}

void CloseAllOrders()
{
   int ticket = 0;
   int total = OrdersTotal();

   for (int pos = total; pos >= 0; pos--)
   {
      if (OrderSelect(pos, SELECT_BY_POS) && OrderSymbol() == _Symbol)
      {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL)
         {
            ticket = OrderClose(OrderTicket(), OrderLots(), MarketInfo(_Symbol,MODE_ASK), 0);
            ticket = OrderClose(OrderTicket(), OrderLots(), MarketInfo(_Symbol,MODE_BID), 0);
         }
         if (ticket > 0)
            Print("Order closed");
         else
            Print("Error = ", GetLastError());
      }
   }
   ObjectSetInteger(0, BUTTONID3, OBJPROP_STATE, false);
   Print("Closed all orders");
}

void BreakEven(int offset)
{
   int total = OrdersTotal();
   double openPrice, stopLoss = 0;

   for (int pos = 0; pos < total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS))
      {
         openPrice = OrderOpenPrice();
         stopLoss = NormalizeDouble(openPrice + (offset * _Point), _Digits);
         if (OrderModify(OrderTicket(), OrderOpenPrice(), stopLoss, OrderTakeProfit(), 0))
            Print("Stoploss modified");
         else
            Print("Error = ", GetLastError());
      }
   }
   ObjectSetInteger(0, BUTTONID4, OBJPROP_STATE, false);
}

bool IsLegal(int x, int y, string buttonID)
{
   bool result = true;
   int windowWidth = (int)GetWindowWidth();
   int buttonX = windowWidth - (int)ObjectGetInteger(0, buttonID, OBJPROP_XDISTANCE);
   int buttonY = (int)ObjectGetInteger(0, buttonID, OBJPROP_YDISTANCE);
   int buttonWidth = (int) ObjectGetInteger(0, buttonID, OBJPROP_XSIZE);
   int buttonHeight = (int)ObjectGetInteger(0, buttonID, OBJPROP_YSIZE);

   if (x >= buttonX && x <= (buttonX + buttonWidth))
      if (y >= buttonY && y <= (buttonY + buttonHeight))
         result = false;
   return result;
}

bool OrderLimit(int count)
{
   const int limit = 10;

   if (count >= limit)
      return true;
   else
      return false;  
}

int OrderCounter()
{
   static int counter;

   if (IsNewDay())
      counter = 0;
   else
      counter++;
   
   return counter;
}

bool IsNewDay()
{
   string midnight = "00:00:00";
   string currentTime = TimeToString(TimeCurrent(), TIME_SECONDS);

   if (currentTime == midnight)
      return true;
   else
      return false;
}

void MoveSL(string buttonID, double lparam, double dparam)
{
   long pressed = 0;

   ObjectGetInteger(0, buttonID, OBJPROP_STATE, 0, pressed);
   if ((bool)pressed && IsLegal((int)lparam, (int)dparam, buttonID))
   {
      int x = (int)lparam;
      int y = (int)dparam;
      datetime dt = 0;
      double price = 0;
      int window = 0;
      double stopLoss = 0;
      int total = OrdersTotal();

      if (ChartXYToTimePrice(0, x, y, window, dt, price))
      {
         stopLoss = NormalizeDouble(price, _Digits);
         for (int pos = 0; pos < total; pos++)
         {
            if (OrderSelect(pos, SELECT_BY_POS))
            {
               if (OrderModify(OrderTicket(), OrderOpenPrice(), stopLoss, OrderTakeProfit(), 0))
               {
                  OrderPrint();
               }
               else
               {
                  Print("Error = ", GetLastError());
               }
            }
         }
      }
      else
      {
         Print("Error in conversion of mouse position to price");
      }
      ObjectSetInteger(0, buttonID, OBJPROP_STATE, false);
      Print("Moved all SLs to mouse position");
   } 
}