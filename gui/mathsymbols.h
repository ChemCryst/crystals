
// Filename: mathsymbols.h
// header-only defined function to replace strings in wxString with unicode symbols before display.
// e.g. \sigma gets translated to unicode symbol u03C3.


class MathSymbols {
 public:
  MathSymbols() {}; 

  static inline void replaceMarkup(wxString& io) {
// Greek upper case      
      io.Replace("\\Alpha", L"\u0391");
      io.Replace("\\Beta", L"\u0392");
      io.Replace("\\Gamma", L"\u0393");
      io.Replace("\\Delta", L"\u0394");
      io.Replace("\\Epsilon", L"\u0395");
      io.Replace("\\Zeta", L"\u0396");
      io.Replace("\\Eta", L"\u0397");
      io.Replace("\\Theta", L"\u0398");
      io.Replace("\\Iota", L"\u0399");
      io.Replace("\\Kappa", L"\u039A");
      io.Replace("\\Lambda", L"\u039B");
      io.Replace("\\Mu", L"\u039C");
      io.Replace("\\Nu", L"\u039D");
      io.Replace("\\Xi", L"\u039E");
      io.Replace("\\Pi", L"\u03A0");
      io.Replace("\\Rho", L"\u03A1");
      io.Replace("\\Sigma", L"\u03A3");
      io.Replace("\\Tau", L"\u03A4");
      io.Replace("\\Upsilon", L"\u03A5");
      io.Replace("\\Phi", L"\u03A6");
      io.Replace("\\Chi", L"\u03A7");
      io.Replace("\\Psi", L"\u03A8");
      io.Replace("\\Omega", L"\u03A9");
// Greek lower case
      io.Replace("\\alpha", L"\u03B1");
      io.Replace("\\beta", L"\u03B2");
      io.Replace("\\gamma", L"\u03B3");
      io.Replace("\\delta", L"\u03B4");
      io.Replace("\\epsilon", L"\u03B5");
      io.Replace("\\zeta", L"\u03B6");
      io.Replace("\\eta", L"\u03B7");
      io.Replace("\\theta", L"\u03B8");
      io.Replace("\\iota", L"\u03B9");
      io.Replace("\\kappa", L"\u03BA");
      io.Replace("\\lambda", L"\u03BB");
      io.Replace("\\mu", L"\u03BC");
      io.Replace("\\nu", L"\u03BD");
      io.Replace("\\xi", L"\u03BE");
      io.Replace("\\pi", L"\u03C0");
      io.Replace("\\rho", L"\u03C1");
      io.Replace("\\sigma", L"\u03C3");
      io.Replace("\\tau", L"\u03C4");
      io.Replace("\\upsilon", L"\u03C5");
      io.Replace("\\phi", L"\u03C6");
      io.Replace("\\chi", L"\u03C7");
      io.Replace("\\psi", L"\u03C8");
      io.Replace("\\omega", L"\u03C9");
// Math
      io.Replace("\\SUM", L"\u03a3"); 
      io.Replace("\\**-1", L"\u207B\u00B9");
      io.Replace("\\**2", L"\u00B2");
      io.Replace("\\**3", L"\u00B3");
      io.Replace("\\sqrt", L"\u221A");
      io.Replace("\\AA", L"\u212B");
      io.Replace("\\$/", L"\u29F8");
      io.Replace("\\_i", L"\u1D62");
      io.Replace("\\_j", L"\u2C7C");
      io.Replace("\\**t", L"\u1D57");
      return ;
  };
  
 };

