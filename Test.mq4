#include <stdlib.mqh>
#include <button.mqh>
#include <background.mqh>
#include <labels.mqh>
#include <trader.mqh>
#include <Controls/Label.mqh>
#include <Controls/Button.mqh>

#property strict
#property script_show_inputs

//--- input parameters
extern double inpLot = 1.0;                                // Number of lots
extern double inpStopLoss = 1500.0;                        // Stop loss level
extern double inpTakeProfit = 4500.0;                      // Take profit level
extern int inpSlippage = 0;                                // Slippage value
extern int inpMaxNumberOfOrders = 2;                       // Maximum number of open orders
extern int inpBreakEvenOffset = 100;                       // BreakEven offset value
extern int inpLimit = 10;                                  // Daily order limit

extern int inpButtonWidth = 80;                            // Button width
extern int inpButtonHeight = 30;                           // Button height
extern int inpButtonSpacing = 5;                           // Spaces between buttons
extern int inpBackgroundMargin = 10;                       // Background margin
extern int inpBackgroundPositionXOffset = -30;             // Background position X offset
extern int inpBackgroundPositionYOffset = -10;             // Background position Y offset

extern color inpBackgroundBackColor = clrGray;             // Background color
extern ENUM_BORDER_TYPE inpBackgroundBorder = BORDER_FLAT; // Border type
extern color inpBackgroundBorderColor = clrDarkGray;       // Flat border color (Flat)
extern ENUM_LINE_STYLE inpBackgroundStyle = STYLE_SOLID;   // Flat border style (Flat)
extern int inpBackgroundLineWidth = 3;                     // Flat border width (Flat)
extern bool inpBackgroundHidden = true;                    // Hidden in the object list
extern long inpBackgroundZOrder = 0;                       // Priority for mouse click

extern string inpBuyText = "BUY";                          // Buy button text
extern string inpBuyFont = "Arial";                        // Buy button font
extern int inpBuyFontSize = 10;                            // Buy button font size
extern color inpBuyColor = clrWhiteSmoke;                  // Buy button text color
extern color inpBuyBackColor = clrGreen;                   // Buy button background color
extern color inpBuyBorderColor = clrNONE;                  // Buy button border color
extern bool inpBuyState = false;                           // Buy button pressed/Released
extern bool inpBuyHidden = true;                           // Buy button hidden in the object list
extern long inpBuyZOrder = 0;                              // Buy button priority for mouse click

extern string inpSellText = "SELL";                        // Sell button text
extern string inpSellFont = "Arial";                       // Sell button font
extern int inpSellFontSize = 10;                           // Sell button font size
extern color inpSellColor = clrWhiteSmoke;                 // Sell button text color
extern color inpSellBackColor = clrRed;                    // Sell button background color
extern color inpSellBorderColor = clrNONE;                 // Sell button border color
extern bool inpSellState = false;                          // Sell button pressed/Released
extern bool inpSellHidden = true;                          // Sell button hidden in the object list
extern long inpSellZOrder = 0;                             // Sell button priority for mouse click

extern string inpCloseText = "CLOSE ALL";                  // Close button text
extern string inpCloseFont = "Arial";                      // Close button font
extern int inpCloseFontSize = 10;                          // Close button font size
extern color inpCloseColor = clrWhiteSmoke;                // Close button text color
extern color inpCloseBackColor = clrDeepSkyBlue;           // Close button background color
extern color inpCloseBorderColor = clrNONE;                // Close button border color
extern bool inpCloseState = false;                         // Close button pressed/Released
extern bool inpCloseHidden = true;                         // Close button hidden in the object list
extern long inpCloseZOrder = 0;                            // Close button priority for mouse click

extern string inpBreakEvenText = "BE";                     // BreakEven button text
extern string inpBreakEvenFont = "Arial";                  // BreakEven button font
extern int inpBreakEvenFontSize = 10;                      // BreakEven button font size
extern color inpBreakEvenColor = clrWhiteSmoke;            // BreakEven button text color
extern color inpBreakEvenBackColor = clrLimeGreen;         // BreakEven button background color
extern color inpBreakEvenBorderColor = clrNONE;            // BreakEven button border color
extern bool inpBreakEvenState = false;                     // BreakEven button pressed/Released
extern bool inpBreakEvenHidden = true;                     // BreakEven button hidden in the object list
extern long inpBreakEvenZOrder = 0;                        // BreakEven button priority for mouse click

extern string inpMoveSLText = "MOVE SL";                   // MoveSL button text
extern string inpMoveSLFont = "Arial";                     // MoveSL button font
extern int inpMoveSLFontSize = 10;                         // MoveSL button font size
extern color inpMoveSLColor = clrWhiteSmoke;               // MoveSL button text color
extern color inpMoveSLBackColor = clrDarkOrange;           // MoveSL button background color
extern color inpMoveSLBorderColor = clrNONE;               // MoveSL button border color
extern bool inpMoveSLState = false;                        // MoveSL button pressed/Released
extern bool inpMoveSLHidden = true;                        // MoveSL button hidden in the object list
extern long inpMoveSLZOrder = 0;                           // MoveSL button priority for mouse click

const ENUM_BASE_CORNER inpCorner = CORNER_RIGHT_UPPER;     // Chart corner for anchoring

const string BACKGROUNDID = "Background";
const string BUTTONID1 = "BuyButton";
const string BUTTONID2 = "SellButton";
const string BUTTONID3 = "CloseButton";
const string BUTTONID4 = "BreakEvenButton";
const string BUTTONID5 = "MoveSLButton";

bool backgroundMoveToBack = false;
bool backgroundSelection = false;
bool buttonSelection = false;
bool buttonMoveToBack = false;

int xMoveSLButtonPosition;
int yMoveSLButtonPosition;

CLabel ProfitLabel;
CLabel PipsLabel;
CLabel SpreadLabel;
CLabel SwapLabel;
CLabel ExpTimeLabel;

string profitLabel = "Profit: ";
string pipsLabel = "Pips: ";
string spreadLabel = "Spread: ";
string swapLabel = "Swap: ";
string timeLabel = "Nxt bar in: ";
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

   CreateTextLabel(PipsLabel, "label1", pipsLabel, 10, 20);
   CreateTextLabel(ProfitLabel, "label2", profitLabel, 10, 40);
   CreateTextLabel(SpreadLabel, "label3", spreadLabel, 10, 60);
   CreateTextLabel(SwapLabel, "label4", swapLabel, 10, 80);
   CreateTextLabel(ExpTimeLabel, "label5", timeLabel, 10, 100);
   
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
   LabelSetText(PipsLabel, pipsLabel, GetPips(2));
   LabelSetText(ProfitLabel, profitLabel, GetProfit(2));
   LabelSetText(SpreadLabel, spreadLabel, GetSpread(2));
   LabelSetText(SwapLabel, swapLabel, GetSwap(2), false);
   LabelSetText(ExpTimeLabel, timeLabel, GetTimeToNextBar(), false);
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
         OpenOrder(BUTTONID1, OP_BUY, inpLot, inpStopLoss, inpTakeProfit, inpSlippage, inpLimit);
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
         OpenOrder(BUTTONID2, OP_SELL, inpLot, inpStopLoss, inpTakeProfit, inpSlippage, inpLimit);
      else
      {
         Print("Maximum number of opened orders has been reached!");
         ObjectSetInteger(0, BUTTONID2, OBJPROP_STATE, false);
      }
   }

   if (id == CHARTEVENT_OBJECT_CLICK && sparam == BUTTONID3)
      CloseAllOrders(BUTTONID3);

   if (id == CHARTEVENT_OBJECT_CLICK && sparam == BUTTONID4)
      BreakEven(BUTTONID4, inpBreakEvenOffset);

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