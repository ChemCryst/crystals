#ifdef _LIN_ || _GIL_ || _MAC_

#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
//#include <c.h>

#define true 1
#define false 0

static Display* gDisplay = NULL;
static Window gSelectedWindow = NULL;
static GC gGraphicsContext = NULL;

int mapIndexToRGB(const short pIndex)
{
  static int tColors[] = {0x000000, 0xffffff, 0xff0000, 0xffAA00,
			  0x00ff00, 0x00ffff, 0x0000ff, 0xff00ff,
                          0xBBBBBB, 0xBB0000, 0xBB4400, 0x00BB00,
                          0x00BBBB, 0x0000BB, 0xB0FF00, 0xBB00FF};

  return tColors[pIndex];
}

void OpenDisplay(const char* tApp)
{
  if (!gDisplay)
    {
      char * tDisplayName = getenv("DISPLAY");
      if (!(gDisplay = XOpenDisplay(tDisplayName)))
	{
	  fprintf(stderr, "%s: cannot connect to X server '%s'\n",
		  tApp, tDisplayName);
	  exit(1);
	}
    }
}

int createrootwindow_(int *x_pos, int *y_pos, const short *x_size, const short *y_size, const short *bgcolor, const char* title)
{
  Window tWindow;
  XGCValues tGCAttributes;
  XSetWindowAttributes tWindAttr;
  int tScreenNum;
  XColor tTempColor;

  if (!gDisplay)
    OpenDisplay(title);
  tScreenNum = DefaultScreen(gDisplay);
  tWindow = XCreateSimpleWindow(gDisplay, RootWindow(gDisplay, tScreenNum),
		     *x_pos, *y_pos, *x_size, *y_size, 2, BlackPixel(gDisplay, 
		     tScreenNum), *bgcolor);
  tWindAttr.save_under = true;
  XChangeWindowAttributes(gDisplay, tWindow, CWSaveUnder, &tWindAttr);
  XMapWindow(gDisplay, tWindow);
  XSync(gDisplay, False);
  tGCAttributes.background = BlackPixel(gDisplay, tScreenNum);
  tGCAttributes.foreground = WhitePixel(gDisplay, tScreenNum);
  gGraphicsContext = XCreateGC(gDisplay, tWindow, GCBackground | GCForeground, &tGCAttributes);
  XStoreName(gDisplay, tWindow, title);
  XSelectInput(gDisplay, tWindow, ButtonPressMask);

  return (long int) tWindow;
}

void selectwindow_(const int *handle)
{
  gSelectedWindow = (Window)*handle;
}

void destroywindow_(const int *handle)
{
  if (gDisplay && handle)
    XDestroyWindow(gDisplay, (Window)handle);
}

void closedisplay_()
{
  if (gDisplay)
    {
      XCloseDisplay(gDisplay);
      gDisplay = NULL;
    }
}

void draw_text__(const char* string, const short *x_pos, const short *y_pos, const short *colour, const long int string_length)
{
  int direction, ascent, descent;
  XCharStruct font_size;

  XQueryTextExtents(gDisplay, XGContextFromGC(gGraphicsContext), string, string_length, &direction, &ascent, &descent, &font_size);  
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
  XDrawString(gDisplay, gSelectedWindow, gGraphicsContext, *x_pos, (*y_pos)+ascent, string, string_length);
  //XFlush(gDisplay);
}

void rectangle_(const short *x_pos, const short *y_pos, const short *width, const short *height, const short *colour)
{
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
  XDrawRectangle(gDisplay, gSelectedWindow, gGraphicsContext, *x_pos, *y_pos, *width-(*x_pos), *height-(*y_pos));
  // XFlush(gDisplay);
}

void fill_rectangle__(const short *x_pos, const short *y_pos, const short *width, const short *height, const short *colour)
{
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
  XFillRectangle(gDisplay, gSelectedWindow, gGraphicsContext, *x_pos, *y_pos, *width-(*x_pos), *height-(*y_pos));
  //XFlush(gDisplay);
}

void ellipse_(const short *x_pos, const short *y_pos, const short *width, const short *height, const short *colour)
{
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
  XDrawArc(gDisplay, gSelectedWindow, gGraphicsContext, *x_pos, *y_pos, *width, *height, 0, 360*64);
  //XFlush(gDisplay);
}

void fill_ellipse__(const short *x_pos, const short *y_pos, const short *width, const short *height, const short *colour)
{
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
  XDrawArc(gDisplay, gSelectedWindow, gGraphicsContext, *x_pos, *y_pos, *width, *height, 0, 360*64);
  //XFlush(gDisplay);
}

void clear_screen_area__(const short *x_pos, const short *y_pos, const short *width, const short *height)
{
  XClearArea(gDisplay, gSelectedWindow, *x_pos, *y_pos, *width, *height, false);
  //XFlush(gDisplay);
}

void polyline_(const short x_poss[], const short y_poss[], const short *num_points, const short *colour)
{
  int i;
  XPoint* tPoints = malloc(sizeof(XPoint)*(*num_points));
  for (i = 0; i < *num_points; i++)
    {
      tPoints[i].x = x_poss[i];
      tPoints[i].y = y_poss[i];
    }
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
   XDrawLines(gDisplay, gSelectedWindow, gGraphicsContext, tPoints, *num_points, CoordModeOrigin);
  free(tPoints);
}

void fill_polygon__(const short x_poss[], const short y_poss[], const short *num_points, const short *colour)
{
  int i;
  XPoint* tPoints = malloc(sizeof(XPoint)*(*num_points));

  for (i = 0; i < *num_points; i++)
    {
      tPoints[i].x = x_poss[i];
      tPoints[i].y = y_poss[i];
    }
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
  XFillPolygon(gDisplay, gSelectedWindow, gGraphicsContext, tPoints, *num_points, CoordModeOrigin, Complex);
  free(tPoints);
  //XFlush(gDisplay);
}

void draw_line__(const short *x_pos, const short *y_pos, const short *x_pos2, const short *y_pos2, const short *colour)
{
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
  XDrawLine(gDisplay, gSelectedWindow, gGraphicsContext, *x_pos, *y_pos, *x_pos2, *y_pos2);
  //XFlush(gDisplay);
}

void update_()
{
  if (gDisplay)
    XFlush(gDisplay);
}

void waitonmousepress___(short *x_pos, short *y_pos, short *button)
{
  XEvent tEvent;
  XNextEvent(gDisplay, &tEvent);
  switch (tEvent.type)
    {
    case ButtonPress : 
      {*x_pos = tEvent.xbutton.x;
	*y_pos = tEvent.xbutton.y;
	*button = tEvent.xbutton.button;
      }
      break;
    default :
      break;
    }
}


/*

int main(int argc, char* argv[])
{
  int args[] = {30, 30, 60, 80, 0, 50, 60, 0};
  int args2[] = {100, 100, 300, 300, 1, 50, 50, 200, 200};
  SelectWindow(CreateRootWindow(&(args2[0]), &(args2[1]), &(args2[2]), &(args2[3]), &(args2[4]), "New Window"));
  ellipse(&(args[0]), &(args[1]), &(args[2]), &(args[3]), &(args[4]));
  clear_screen_area(&(args2[5]), &(args2[6]), &(args2[7]), &(args2[8]));
  draw_text("Some string", &(args[5]), &(args[6]), &(args[7])); 
  clear_screen_area(&(args2[5]), &(args2[6]), &(args2[7]), &(args2[8]));
   sleep(5);
  CloseDisplay();
  }*/


#else

#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define true 1
#define false 0

static HWND ourWindow = NULL;

int mapIndexToRGB(const short pIndex)
{
  static int tColors[] = {0x000000, 0xffffff, 0xff0000, 0xffAA00,
			  0x00ff00, 0x00ffff, 0x0000ff, 0xff00ff,
                          0xBBBBBB, 0xBB0000, 0xBB4400, 0x00BB00,
                          0x00BBBB, 0x0000BB, 0xB0FF00, 0xBB00FF};

  return tColors[pIndex];
}

int createrootwindow_(int *x_pos, int *y_pos, const short *x_size, const short *y_size, const short *bgcolor, const char* title)
{

  HWND myWindow;
  WNDCLASS  wc;

  wc.hInstance = thisApplicationInstance;
  wx.lpfnWndProc = (WNDPROC)myCallback;
  RegisterClass( &wc );
  myWindow = CreateWindow();
  ShowWindow(myWindow);
  ourWindow = myWindow;
  return (long int) myWindow;
}

void selectwindow_(const int *handle)
{
}

void destroywindow_(const int *handle)
{
    DestroyWindow(ourWindow);
}

void closedisplay_()
{
}

void draw_text__(const char* string, const short *x_pos, const short *y_pos,
                 const short *colour, const long int string_length)
{
  hdc = GetDC( ourWindow );
  font = (HFONT)GetStockObject(OEM_FIXED_FONT);
  oldFont = (HFONT)SelectObject( hdc, font ); // save old font
  SetTextColor (hdc, (COLORREF)mapIndexToRGB(*colour));
  SetBkColor   (hdc, (COLORREF)RGB( 0x00,0x00,0x00 ));
  TextOut( hdc, *x_pos, *y_pos, string, string_length);
  SelectObject( hdc, oldfont ); // save old font
  ReleaseDC( ourWindow );
}

void rectangle_(const short *x_pos, const short *y_pos, const short *width, const short *height, const short *colour)
{
  hdc = GetDC( ourWindow );
  RECT i;
  i.Top     = *y_pos;
  i.Left    = *x_pos;
  i.Bottom  = *y_pos + *height;
  i.Right   = *x_pos + *width;

  HBRUSH b = CreateSolidBrush( (COLOREF)mapIndexToRGB(*colour) );

  FrameRect( hdc, &i, b )

  ReleaseDC( ourWindow );

}

void fill_rectangle__(const short *x_pos, const short *y_pos, const short *width, const short *height, const short *colour)
{
  hdc = GetDC( ourWindow );
  RECT i;
  i.Top     = *y_pos;
  i.Left    = *x_pos;
  i.Bottom  = *y_pos + *height;
  i.Right   = *x_pos + *width;

  HBRUSH b = CreateSolidBrush( (COLOREF)mapIndexToRGB(*colour) );

  FillRect( hdc, &i, b )

  ReleaseDC( ourWindow );
}

void ellipse_(const short *x_pos, const short *y_pos, const short *width, const short *height, const short *colour)
{
}

void fill_ellipse__(const short *x_pos, const short *y_pos, const short *width, const short *height, const short *colour)
{
}

void clear_screen_area__(const short *x_pos, const short *y_pos, const short *width, const short *height)
{
  hdc = GetDC( ourWindow );
  RECT i;
  i.Top     = *y_pos;
  i.Left    = *x_pos;
  i.Bottom  = *y_pos + *height;
  i.Right   = *x_pos + *width;

  HBRUSH b = CreateSolidBrush( (COLOREF)RGB( 0x00,0x00,0x00 ) );

  FillRect( hdc, &i, b )

  ReleaseDC( ourWindow );
}

void polyline_(const short x_poss[], const short y_poss[], const short *num_points, const short *colour)
{
/*  int i;
  XPoint* tPoints = malloc(sizeof(XPoint)*(*num_points));
  for (i = 0; i < *num_points; i++)
    {
      tPoints[i].x = x_poss[i];
      tPoints[i].y = y_poss[i];
    }
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
   XDrawLines(gDisplay, gSelectedWindow, gGraphicsContext, tPoints, *num_points, CoordModeOrigin);
  free(tPoints);
  */
}

void fill_polygon__(const short x_poss[], const short y_poss[], const short *num_points, const short *colour)
{
/*  int i;
  XPoint* tPoints = malloc(sizeof(XPoint)*(*num_points));

  for (i = 0; i < *num_points; i++)
    {
      tPoints[i].x = x_poss[i];
      tPoints[i].y = y_poss[i];
    }
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
  XFillPolygon(gDisplay, gSelectedWindow, gGraphicsContext, tPoints, *num_points, CoordModeOrigin, Complex);
  free(tPoints);
  //XFlush(gDisplay);*/
}

void draw_line__(const short *x_pos, const short *y_pos, const short *x_pos2, const short *y_pos2, const short *colour)
{
/*
  XSetForeground(gDisplay, gGraphicsContext, mapIndexToRGB(*colour));
  XDrawLine(gDisplay, gSelectedWindow, gGraphicsContext, *x_pos, *y_pos, *x_pos2, *y_pos2);
  //XFlush(gDisplay);
*/
}

void update_()
{
/*  if (gDisplay)
    XFlush(gDisplay);
*/
}

void waitonmousepress___(short *x_pos, short *y_pos, short *button)
{
/*  XEvent tEvent;
  XNextEvent(gDisplay, &tEvent);
  switch (tEvent.type)
    {
    case ButtonPress : 
      {*x_pos = tEvent.xbutton.x;
	*y_pos = tEvent.xbutton.y;
	*button = tEvent.xbutton.button;
      }
      break;
    default :
      break;
    }
    */
}

