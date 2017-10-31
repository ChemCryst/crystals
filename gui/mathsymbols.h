
// Filename: mathsymbols.h
// header-only defined function to replace strings in wxString with unicode symbols before display.
// e.g. \sigma gets translated to unicode symbol u03C3.


class MathSymbols {
 public:
  MathSymbols() {}; 

  static inline void replaceMarkup(wxString& io) {
      io.Replace("\\theta", L"\u03b8");
      io.Replace("\\sigma", L"\u03c3");
      io.Replace("\\rho", L"\u03c1");
      io.Replace("\\lambda", L"\u03bb");
      io.Replace("\\SUM", L"\u03a3");	
      io.Replace("\\**-1", L"\u207B\u00B9");
      io.Replace("\\**2", L"\u00B2");
      io.Replace("\\**3", L"\u00B3");
      io.Replace("\\sqrt", L"\u221A");
      return ;
  };
  
 };

