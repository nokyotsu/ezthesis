%% ezthesis class for LaTeX2e.
%%
%% A customisable class for thesis writing
%% by Juan Antonio Navarro Perez
%% http://navarroj.com/latex
%% ezlatex@navarroj.com
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ezthesis}[2014/27/03 A customisable class for thesis writing]

\RequirePackage{pgfopts}
\RequirePackage{ezkeys}
\RequirePackage{afterpackage}

\newcommand*\ClassOptions{\pgfqkeys{/ezthesis/options}}
\newcommand*\ifclasstoggle[1]{\iftoggle{/ezthesis/options/#1}}
\newcommand*\setfields{\pgfqkeys{/ezthesis/fields}}
\newcommand*\insertfield[1]{\pgfkeysusevalue{/ezthesis/fields/#1}}

% User options:
%   - final:
%       Version ready for printing. All packages are configured to produce
%       a final version of the document. Graphics are shown, while timestamps
%       and overfull marks are hidden.
%   - preprint:
%       Timestamps and overfull boxes are added to the document, but graphics
%       and features added by other packages remain active unless explicitly
%       disabled.
%   - draft:
%       Timestamps and overfull boxes are added to the document. Also graphics
%       are hidden and packages are requested to disable features for a faster
%       compilation time.
\ClassOptions{
  timestamp/.is toggle,
  quality/.is code choice,
  quality/draft/.code={\PassOptionsToClass{draft}{book}},
  quality/final/.code={\PassOptionsToClass{final}{book}},
  final/.style={quality=final,timestamp=false,open chapter=right},
  draft/.style={quality=draft,timestamp=true,open chapter=any},
  preprint/.style={draft},
}

% User options:
%   - 10pt/11pt/12pt:
%       Select font size. The default is 12pt.
%   - oneside/twoside:
%       Adjust margins for oneside/twoside printing. Default is twoside.
%   - singlespacing/onehalfspacing/doublespacing:
%       Select spacing between lines. Default is onehalfspacing.
\ClassOptions{
  font size/.is code choice,
  font size/10pt/.code={\PassOptionsToClass{10pt}{book}},
  font size/11pt/.code={\PassOptionsToClass{11pt}{book}},
  font size/12pt/.code={\PassOptionsToClass{12pt}{book}},
  10pt/.style={font size=10pt},
  11pt/.style={font size=11pt},
  12pt/.style={font size=12pt},
  page sides/.is code choice,
  page sides/one/.code={\PassOptionsToClass{oneside}{book}},
  page sides/two/.code={\PassOptionsToClass{twoside}{book}},
  oneside/.style={page sides=one},
  twoside/.style={page sides=two},
  open chapter/.is code choice,
  open chapter/any/.code={\PassOptionsToClass{openany}{book}},
  open chapter/right/.code={\PassOptionsToClass{openright}{book}},
  openany/.style={open chapter=any},
  openright/.style={open chapter=right},
}

\ClassOptions{
  spacing/.is code choice,
  spacing/disable/.code={},
  spacing/single/.code={\RequirePackage[singlespacing]{setspace}},
  spacing/one half/.code={\RequirePackage[onehalfspacing]{setspace}},
  spacing/double/.code={\RequirePackage[doublespacing]{setspace}},
  singlespacing/.style={spacing=single},
  onehalfspacing/.style={spacing=one half},
  doublespacing/.style={spacing=double},
}

\ClassOptions{
  language/.is code choice,
  language/none/.code={},
  language/spanish/.code={%
    \RequirePackage[activeacute,spanish]{babel}
    \addto\captionsspanish{\def\draftname{\spanishdraftname}}
    \AfterPackage{hyperref}{%
      \addto\extrasspanish{\def\tableautorefname{\spanishtablename}}
    }
  },
  language/mexico/.code={%
    \PassOptionsToPackage{spanish,es-nodecimaldot,es-tabla,es-noquoting}{babel}
    \pgfkeysalso{language/spanish}
    \PassOptionsToPackage{spanish}{cleveref}
    \AfterPackage{cleveref}{%
      \addto\extrasspanish{
        \Crefname{table}{Tabla}{Tablas}%
        \if@cref@capitalise%  capitalise set
          \crefname{table}{Tabla}{Tablas}%
        \else
          \crefname{table}{tabla}{tablas}%
        \fi
      }
    }
  },
  spanish/.style={language=spanish},
  mexico/.style={language=mexico},
}

\ClassOptions{
  cleveref/.is code choice,
  cleveref/false/.code={},
  cleveref/true/.code={\RequirePackage[nameinlink]{cleveref}}
}
  

\ClassOptions{
  toc/.is code choice,
  toc/minimal/.code={},
  toc/standard/.code={\RequirePackage[nottoc]{tocbibind}},
  toc/complete/.code={\RequirePackage{tocbibind}},
}

\ClassOptions{
  graphics/.is code choice,
  graphics/false/.code={},
  graphics/true/.code={\RequirePackage{graphicx}},
  microtype/.is code choice,
  microtype/false/.code={},
  microtype/true/.code={\RequirePackage{microtype}},
}

\ClassOptions{
  color/.is code choice,
  color/false/.code={},
  color/true/.code={%
    \RequirePackage{xcolor}
    \PassOptionsToPackage{%
      colorlinks,
      linkcolor={red!50!black},
      citecolor={blue!50!black},
      urlcolor={blue!80!black}
    }{hyperref}
  },
}

\ClassOptions{
  links/.is code choice,
  links/disable/.code={},
  links/url/.code={\RequirePackage{url}},
  links/hyperref/.code={%
      \RequirePackage{hyperref}
      \RequirePackage[all]{hypcap}
      \hypersetup{%
        pdfauthor={\insertfield{author}},
        pdftitle={\insertfield{title}},
      }
  },
  hyperlinks/.style={links=hyperref},
}

\ClassOptions{
  font style/.is code choice,
  font style/default/.code={},
  font style/modern/.code={%
    \RequirePackage[T1]{fontenc}
    \RequirePackage{lmodern}\normalfont},
}

% Default options
\ClassOptions{
  final,
  font size=12pt,
  font style=modern,
  page sides=two,
  spacing=one half,
  language=none,
  toc=standard,
  graphics=true,
  microtype=true,
  links=url,
  color=true,
  cleveref=true,
}

% All other options are passed to book class
\ClassOptions{
  .unknown/.code={\PassOptionsToClass{\pgfkeyscurrentname}{book}},
}
\ProcessPgfOptions{/ezthesis/options}
\ClassOptions{
  open chapter/.eval,
  quality/.eval,
  font size/.eval,
  page sides/.eval,
}
\LoadClass{book}

\setfields{
  author/.initial = {Some Person},
  title/.initial = {A Thesis Title},
  date/.initial = {\number\the\year},
  degree/.initial = {Doctor of Philosophy},
  supervisor/.initial = {A. Supervisor},
  institution/.initial = {The University of Somewhere},
  faculty/.initial = {Faculty of Improbability},
  department/.initial = {School of Life},
}

\renewcommand\author{\pgfkeyssetvalue{/ezthesis/fields/author}}
\renewcommand\title{\pgfkeyssetvalue{/ezthesis/fields/title}}
\renewcommand\date{\pgfkeyssetvalue{/ezthesis/fields/date}}
\renewcommand\@author{\insertfield{author}}
\renewcommand\@title{\insertfield{title}}
\renewcommand\@date{\insertfield{date}}

\AtBeginDocument{
  \ClassOptions{
    links/.eval,
    cleveref/.eval,
  }
%  \addto\extrasspanish{
%    \def\tablename{Cuadrito}
%    \def\tableautorefname{Cuadrito}
%    \crefname{table}{cuadrito}{cuadritos}
%    \Crefname{table}{Cuadrito}{Cuadritos}
%  }
}

\ClassOptions{font style/.eval}\normalfont
\ClassOptions{
  color/.eval,
  language/.eval,
  spacing/.eval,
  toc/.eval,
  graphics/.eval,
  microtype/.eval,
}

\newcommand\draftname{Draft}
\newcommand\spanishdraftname{Borrador}

%% title page building blocks
\renewenvironment{titlepage}%
    {\let\ez@blockfill\relax
     \thispagestyle{empty}\centering\null\vskip1in}
    {\vskip.5in\newpage}

\newcommand{\TitleBlock}[2][\ez@blockfill]{#1{#2\par}\let\ez@blockfill\vfill}

\endinput

%% switches
\newif\if@fancyhdr\@fancyhdrtrue
\newif\if@natbib\@natbibtrue
\newif\if@bibnumbers\@bibnumbersfalse

%% class options
\DeclareOption{numbers}{\@bibnumberstrue}
\DeclareOption{authoryear}{\@bibnumbersfalse}
\DeclareOption{nofancyhdr}{\@fancyhdrfalse}
\DeclareOption{nonatbib}{\@natbibfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ExecuteOptions{final,authoryear}
\ProcessOptions\relax
\LoadClass{report}

%% time and date
\newcount\hours \newcount\minutes
\def\SetTime{\hours=\time
        \global\divide\hours by 60
        \minutes=\hours
        \multiply\minutes by 60
        \advance\minutes by-\time
        \global\multiply\minutes by-1 }
\SetTime

\def\shortdate{\@arabic\day/\@arabic\month/\@arabic\year}
\def\shorttime{\number\hours:\ifnum\minutes<10 0\fi\number\minutes\ hrs}

\if@draft
    \def\draftmark{\draftlabel: \shortdate\ -- \shorttime}
\else
    \def\draftmark{}
\fi

%% margins
\RequirePackage[
  top     = 40mm, bottom     = 33mm,
  outer   = 25mm, inner      = 40mm,
  headsep = 10mm, headheight = 15pt,
  marginparwidth = 15mm ]{geometry}

%% page styles
\if@fancyhdr
  \RequirePackage{fancyhdr}

  \if@twoside
    \fancyhf{}
    \fancyhead[RE]{\itshape\nouppercase\leftmark}
    \fancyhead[LO]{\itshape\nouppercase\rightmark}
    \fancyhead[LE,RO]{\itshape\thepage}
    \fancyfoot[C]{\draftmark}

    \fancypagestyle{plain}{%
    \fancyhf{}
    \fancyfoot[LE,RO]{\itshape\thepage}
    \fancyfoot[RE,LO]{\draftmark}}
  \else
    \fancyhf{}
    \fancyhead[L]{\itshape\nouppercase\leftmark}
    \fancyhead[R]{\itshape\thepage}
    \fancyfoot[C]{\draftmark}

    \fancypagestyle{plain}{%
    \fancyhf{}
    \fancyfoot[R]{\itshape\thepage}
    \fancyfoot[L]{\draftmark}}
  \fi

  \fancypagestyle{empty}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \fancyfoot[C]{\draftmark}}

  % setting page style should be done *after* geometry
  \AtBeginDocument{\pagestyle{fancy}}
\else
  \AtBeginDocument{\pagestyle{headings}}
\fi

%% Bibliography - natbib
\if@natbib
  \if@bibnumbers
    \RequirePackage[sort&compress,square,numbers]{natbib}
  \else
    \RequirePackage[sort&compress,round,authoryear]{natbib}
  \fi
  \if@spanish
    \bibliographystyle{ezspanish}
  \else
    \bibliographystyle{plainnat}
  \fi
  \let\cite\citep
\fi

\endinput
