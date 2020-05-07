#include <stdlib.mqh>

#property strict
#property script_show_inputs

//--- input parameters
input double           inpBuyLots=1.0;                    // Number of lots to buy
input double           inpBuySL=1500.0;                       // Buy stop loss level
input double           inpBuyTP=1500.0;                       // Buy take profit level
input int              inpBuySlippage=0;                  // Buy slippage value

input ENUM_BASE_CORNER inpCorner=CORNER_RIGHT_UPPER; // Chart corner for anchoring

input color            inpBackgroundBackColor=clrGray;     // Background color
input ENUM_BORDER_TYPE inpBackgroundBorder=BORDER_FLAT;       // Border type
input color            inpBackgroundBorderColor=clrDarkGray;        // Flat border color (Flat)
input ENUM_LINE_STYLE  inpBackgroundStyle=STYLE_SOLID;        // Flat border style (Flat)
input int              inpBackgroundLineWidth=3;              // Flat border width (Flat)      
input bool             inpBackgroundHidden=true;              // Hidden in the object list
input long             inpBackgroundZOrder=0;                 // Priority for mouse click

input string           inpBuyText="BUY";            // Buy button text
input string           inpBuyFont="Arial";             // Buy button font
input int              inpBuyFontSize=12;              // Buy button font size
input color            inpBuyColor=clrWhiteSmoke;           // Buy button text color
input color            inpBuyBackColor=clrGreen; // Buy button background color
input color            inpBuyBorderColor=clrNONE;      // Buy button border color
input bool             inpBuyState=false;              // Buy button pressed/Released
input bool             inpBuyHidden=true;              // Buy button hidden in the object list
input long             inpBuyZOrder=0;                 // Buy button priority for mouse click

input string           inpSellText="SELL";            // Sell button text
input string           inpSellFont="Arial";             // Sell button font
input int              inpSellFontSize=12;              // Sell button font size
input color            inpSellColor=clrWhiteSmoke;           // Sell button text color
input color            inpSellBackColor=clrRed; // Sell button background color
input color            inpSellBorderColor=clrNONE;      // Sell button border color
input bool             inpSellState=false;              // Sell button pressed/Released
input bool             inpSellHidden=true;              // Sell button hidden in the object list
input long             inpSellZOrder=0;                 // Sell button priority for mouse click

input string           inpCloseText="CLOSE ALL";            // Close button text
input string           inpCloseFont="Arial";             // Close button font
input int              inpCloseFontSize=12;              // Close button font size
input color            inpCloseColor=clrWhiteSmoke;           // Close button text color
input color            inpCloseBackColor=clrBlue; // Close button background color
input color            inpCloseBorderColor=clrNONE;      // Close button border color
input bool             inpCloseState=false;              // Close button pressed/Released
input bool             inpCloseHidden=true;              // Close button hidden in the object list
input long             inpCloseZOrder=0;                 // Close button priority for mouse click

input string           inpSLUPText="SL UP";            // SLUP button text
input string           inpSLUPFont="Arial";             // SLUP button font
input int              inpSLUPFontSize=12;              // SLUP button font size
input color            inpSLUPColor=clrWhiteSmoke;           // SLUP button text color
input color            inpSLUPBackColor=clrLimeGreen; // SLUP button background color
input color            inpSLUPBorderColor=clrNONE;      // SLUP button border color
input bool             inpSLUPState=false;              // SLUP button pressed/Released
input bool             inpSLUPHidden=true;              // SLUP button hidden in the object list
input long             inpSLUPZOrder=0;                 // SLUP button priority for mouse click

input string           inpSLDownText="SL DOWN";            // SLDown button text
input string           inpSLDownFont="Arial";             // SLDown button font
input int              inpSLDownFontSize=12;              // SLDown button font size
input color            inpSLDownColor=clrWhiteSmoke;           // SLDown button text color
input color            inpSLDownBackColor=clrDarkOrange; // SLDown button background color
input color            inpSLDownBorderColor=clrNONE;      // SLDown button border color
input bool             inpSLDownState=false;              // SLDown button pressed/Released
input bool             inpSLDownHidden=true;              // SLDown button hidden in the object list
input long             inpSLDownZOrder=0;                 // SLDown button priority for mouse click

input string           inpSwapOrderText="SWAP ORDER";            // SwapOrder button text
input string           inpSwapOrderFont="Arial";             // SwapOrder button font
input int              inpSwapOrderFontSize=12;              // SwapOrder button font size
input color            inpSwapOrderColor=clrWhiteSmoke;           // SwapOrder button text color
input color            inpSwapOrderBackColor=clrPurple; // SwapOrder button background color
input color            inpSwapOrderBorderColor=clrNONE;      // SwapOrder button border color
input bool             inpSwapOrderState=false;              // SwapOrder button pressed/Released
input bool             inpSwapOrderHidden=true;              // SwapOrder button hidden in the object list
input long             inpSwapOrderZOrder=0;                 // SwapOrder button priority for mouse click

const string BACKGROUNDID = "Background";
bool backgroundMoveToBack = true;
bool backgroundSelection=false;  

const string BUYBUTTONID = "BuyButton";
bool buyButtonSelection=false;
bool buyButtonMoveToBack=false;

const string SELLBUTTONID = "SellButton";
bool sellButtonSelection=false;
bool sellButtonMoveToBack=false;

const string CLOSEBUTTONID = "CloseButton";
bool closeButtonSelection=false;
bool closeButtonMoveToBack=false;

const string SLUPBUTTONID = "SLUPButton";
bool sLUPButtonSelection=false;
bool sLUPButtonMoveToBack=false;

const string SLDOWNBUTTONID = "SLDownButton";
bool sLDownButtonSelection=false;
bool sLDownButtonMoveToBack=false;

const string SWAPORDERBUTTONID = "SwapOrderButton";
bool swapOrderButtonSelection=false;
bool swapOrderButtonMoveToBack=false;
   
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   long xWindowSize;
   long yWindowSize;
   int numberOfButtons = 6;
   int margin = 20;
   int spacing = 5;

   if(!ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,xWindowSize))
     {
      Print("Failed to get the chart width! Error code = ",GetLastError());
     }
   if(!ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0,yWindowSize))
     {
      Print("Failed to get the chart width! Error code = ",GetLastError());
     }

   int buttonWidth = ((int)xWindowSize / 8) - 20;
   int buttonHeight = ((int)yWindowSize / 16) - 5;

   int xBackgroundPosition = (int)(xWindowSize / 8) + 5;
   int yBackgroundPosition = (int)(yWindowSize / 16);
   int backgroundWidth = buttonWidth + 20;
   int backgroundHeight = ((buttonHeight + spacing) * numberOfButtons) + margin - spacing;

   if(!RectLabelCreate(0,BACKGROUNDID,0,xBackgroundPosition,yBackgroundPosition,
                       backgroundWidth,backgroundHeight,inpBackgroundBackColor,
                       inpBackgroundBorder,inpCorner,inpBackgroundBorderColor,
                       inpBackgroundStyle,inpBackgroundLineWidth,backgroundMoveToBack,
                       backgroundSelection,inpBackgroundHidden,inpBackgroundZOrder))
     {
      Print(__FUNCTION__,": failed to create the background! Error code = ",GetLastError());
     }

   int xBuyButtonPosition = xBackgroundPosition - 10;
   int yBuyButtonPosition = yBackgroundPosition + 10;
     
   if(!ButtonCreate(0,BUYBUTTONID,0,xBuyButtonPosition,yBuyButtonPosition,buttonWidth,buttonHeight,
                    inpCorner,inpBuyText,inpBuyFont,inpBuyFontSize,inpBuyColor,
                    inpBuyBackColor,inpBuyBorderColor,inpBuyState,buyButtonMoveToBack,
                    buyButtonSelection,inpBuyHidden,inpBuyZOrder))
     {
      Print(__FUNCTION__,": failed to create the buy button! Error code = ",GetLastError());
     }

   int xSellButtonPosition = xBackgroundPosition - 10;
   int ySellButtonPosition = yBuyButtonPosition + buttonHeight + 5;

   if(!ButtonCreate(0,SELLBUTTONID,0,xSellButtonPosition,ySellButtonPosition,buttonWidth,buttonHeight,
                    inpCorner,inpSellText,inpSellFont,inpSellFontSize,inpSellColor,
                    inpSellBackColor,inpSellBorderColor,inpSellState,sellButtonMoveToBack,
                    sellButtonSelection,inpSellHidden,inpSellZOrder))
     {
      Print(__FUNCTION__,": failed to create the sell button! Error code = ",GetLastError());
     }

   int xCloseButtonPosition = xBackgroundPosition - 10;
   int yCloseButtonPosition = ySellButtonPosition + buttonHeight + 5;

   if(!ButtonCreate(0,CLOSEBUTTONID,0,xCloseButtonPosition,yCloseButtonPosition,buttonWidth,buttonHeight,
                    inpCorner,inpCloseText,inpCloseFont,inpCloseFontSize,inpCloseColor,
                    inpCloseBackColor,inpCloseBorderColor,inpCloseState,closeButtonMoveToBack,
                    closeButtonSelection,inpCloseHidden,inpCloseZOrder))
     {
      Print(__FUNCTION__,": failed to create the close button! Error code = ",GetLastError());
     }

   int xSLUPButtonPosition = xBackgroundPosition - 10;
   int ySLUPButtonPosition = yCloseButtonPosition + buttonHeight + 5;

   if(!ButtonCreate(0,SLUPBUTTONID,0,xSLUPButtonPosition,ySLUPButtonPosition,buttonWidth,buttonHeight,
                    inpCorner,inpSLUPText,inpSLUPFont,inpSLUPFontSize,inpSLUPColor,
                    inpSLUPBackColor,inpSLUPBorderColor,inpSLUPState,sLUPButtonMoveToBack,
                    sLUPButtonSelection,inpSLUPHidden,inpSLUPZOrder))
     {
      Print(__FUNCTION__,": failed to create the sl up button! Error code = ",GetLastError());
     }

   int xSLDownButtonPosition = xBackgroundPosition - 10;
   int ySLDownButtonPosition = ySLUPButtonPosition + buttonHeight + 5;

   if(!ButtonCreate(0,SLDOWNBUTTONID,0,xSLDownButtonPosition,ySLDownButtonPosition,buttonWidth,buttonHeight,
                    inpCorner,inpSLDownText,inpSLDownFont,inpSLDownFontSize,inpSLDownColor,
                    inpSLDownBackColor,inpSLDownBorderColor,inpSLDownState,sLDownButtonMoveToBack,
                    sLDownButtonSelection,inpSLDownHidden,inpSLDownZOrder))
     {
      Print(__FUNCTION__,": failed to create the sl down button! Error code = ",GetLastError());
     }

   int xSwapOrderButtonPosition = xBackgroundPosition - 10;
   int ySwapOrderButtonPosition = ySLDownButtonPosition + buttonHeight + 5;

   if(!ButtonCreate(0,SWAPORDERBUTTONID,0,xSwapOrderButtonPosition,ySwapOrderButtonPosition,buttonWidth,buttonHeight,
                    inpCorner,inpSwapOrderText,inpSwapOrderFont,inpSwapOrderFontSize,inpSwapOrderColor,
                    inpSwapOrderBackColor,inpSwapOrderBorderColor,inpSwapOrderState,swapOrderButtonMoveToBack,
                    swapOrderButtonSelection,inpSwapOrderHidden,inpSwapOrderZOrder))
     {
      Print(__FUNCTION__,": failed to create the sl down button! Error code = ",GetLastError());
     }



   ChartRedraw(0);
   return(INIT_SUCCEEDED);
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
   int _ticket = 0;
   int _error = 0;
   if(sparam == BUYBUTTONID)
     {
      
      double stoploss = NormalizeDouble((Bid - inpBuySL) * Point, _Digits);
      double takeprofit = NormalizeDouble((Bid + inpBuyTP) * Point, _Digits);

      _ticket = OrderSend(Symbol(),OP_BUY,inpBuyLots,Ask,inpBuySlippage,stoploss,takeprofit);
      if(_ticket > 0)
        {
         if(OrderSelect(_ticket,SELECT_BY_TICKET) == true)
           {
            Print("Order open price is ", OrderOpenPrice());
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
  }

bool ButtonCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               x=0,                      // X coordinate
                  const int               y=0,                      // Y coordinate
                  const int               width=50,                 // button width
                  const int               height=18,                // button height
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                  const string            text="Button",            // text
                  const string            font="Arial",             // font
                  const int               font_size=10,             // font size
                  const color             clr=clrBlack,             // text color
                  const color             back_clr=C'236,233,216',  // background color
                  const color             border_clr=clrNONE,       // border color
                  const bool              state=false,              // pressed/released
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden=true,              // hidden in the object list
                  const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create the button
   ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0);
//--- set button coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set button size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
//--- enable (true) or disable (false) the mode of moving the button by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the button                                                  |
//+------------------------------------------------------------------+
bool ButtonMove(const long   chart_ID=0,    // chart's ID
                const string name="Button", // button name
                const int    x=0,           // X coordinate
                const int    y=0)           // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the button
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the button! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the button! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change button size                                               |
//+------------------------------------------------------------------+
bool ButtonChangeSize(const long   chart_ID=0,    // chart's ID
                      const string name="Button", // button name
                      const int    width=50,      // button width
                      const int    height=18)     // button height
  {
//--- reset the error value
   ResetLastError();
//--- change the button size
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width))
     {
      Print(__FUNCTION__,
            ": failed to change the button width! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height))
     {
      Print(__FUNCTION__,
            ": failed to change the button height! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change corner of the chart for binding the button                |
//+------------------------------------------------------------------+
bool ButtonChangeCorner(const long             chart_ID=0,               // chart's ID
                        const string           name="Button",            // button name
                        const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER) // chart corner for anchoring
  {
//--- reset the error value
   ResetLastError();
//--- change anchor corner
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner))
     {
      Print(__FUNCTION__,
            ": failed to change the anchor corner! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change button text                                               |
//+------------------------------------------------------------------+
bool ButtonTextChange(const long   chart_ID=0,    // chart's ID
                      const string name="Button", // button name
                      const string text="Text")   // text
  {
//--- reset the error value
   ResetLastError();
//--- change object text
   if(!ObjectSetString(chart_ID,name,OBJPROP_TEXT,text))
     {
      Print(__FUNCTION__,
            ": failed to change the text! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete the button                                                |
//+------------------------------------------------------------------+
bool ButtonDelete(const long   chart_ID=0,    // chart's ID
                  const string name="Button") // button name
  {
//--- reset the error value
   ResetLastError();
//--- delete the button
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete the button! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Create rectangle label                                           |
//+------------------------------------------------------------------+
bool RectLabelCreate(const long             chart_ID=0,               // chart's ID
                     const string           name="RectLabel",         // label name
                     const int              sub_window=0,             // subwindow index
                     const int              x=0,                      // X coordinate
                     const int              y=0,                      // Y coordinate
                     const int              width=50,                 // width
                     const int              height=18,                // height
                     const color            back_clr=C'236,233,216',  // background color
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // border type
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                     const color            clr=clrRed,               // flat border color (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // flat border style
                     const int              line_width=1,             // flat border width
                     const bool             back=false,               // in the background
                     const bool             selection=false,          // highlight to move
                     const bool             hidden=true,              // hidden in the object list
                     const long             z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a rectangle label
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set label size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border type
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set flat border line style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set flat border width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move rectangle label                                             |
//+------------------------------------------------------------------+
bool RectLabelMove(const long   chart_ID=0,       // chart's ID
                   const string name="RectLabel", // label name
                   const int    x=0,              // X coordinate
                   const int    y=0)              // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the rectangle label
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the label! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the label! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change the size of the rectangle label                           |
//+------------------------------------------------------------------+
bool RectLabelChangeSize(const long   chart_ID=0,       // chart's ID
                         const string name="RectLabel", // label name
                         const int    width=50,         // label width
                         const int    height=18)        // label height
  {
//--- reset the error value
   ResetLastError();
//--- change label size
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width))
     {
      Print(__FUNCTION__,
            ": failed to change the label's width! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height))
     {
      Print(__FUNCTION__,
            ": failed to change the label's height! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change rectangle label border type                               |
//+------------------------------------------------------------------+
bool RectLabelChangeBorderType(const long             chart_ID=0,           // chart's ID
                               const string           name="RectLabel",     // label name
                               const ENUM_BORDER_TYPE border=BORDER_SUNKEN) // border type
  {
//--- reset the error value
   ResetLastError();
//--- change border type
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border))
     {
      Print(__FUNCTION__,
            ": failed to change the border type! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete the rectangle label                                       |
//+------------------------------------------------------------------+
bool RectLabelDelete(const long   chart_ID=0,       // chart's ID
                     const string name="RectLabel") // label name
  {
//--- reset the error value
   ResetLastError();
//--- delete the label
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete a rectangle label! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
