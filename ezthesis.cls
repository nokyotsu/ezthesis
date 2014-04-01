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
  quality/draft/.code={\PassOptionsToClass{draft}{report}},
  quality/final/.code={\PassOptionsToClass{final}{report}},
  final/.style={quality=final,timestamp=false},
  draft/.style={quality=draft,timestamp=true},
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
  font size/10pt/.code={\PassOptionsToClass{10pt}{report}},
  font size/11pt/.code={\PassOptionsToClass{11pt}{report}},
  font size/12pt/.code={\PassOptionsToClass{12pt}{report}},
  10pt/.style={font size=10pt},
  11pt/.style={font size=11pt},
  12pt/.style={font size=12pt},
  page sides/.is code choice,
  page sides/one/.code={\PassOptionsToClass{oneside}{report}},
  page sides/two/.code={\PassOptionsToClass{twoside}{report}},
  oneside/.style={page sides=one},
  twoside/.style={page sides=two},
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
  language/disable/.code={},
  language/spanish/.code={%
    \RequirePackage[activeacute,spanish]{babel}
    \def\draftlabel{BORRADOR}
  },
  language/mexico/.code={%
    \PassOptionsToPackage{spanish,es-nodecimaldot,es-tabla,es-noquoting}{babel}
    \pgfkeysalso{language/spanish}
  },
  language=disable,
  spanish/.style={language=spanish},
  mexico/.style={language=mexico},
}

% Default options
\ClassOptions{
  timestamp=false,
  quality=final,
  font size=12pt,
  page sides=two,
  spacing=one half,
}

% All other options are passed to report class
\ClassOptions{
  .unknown/.code={\PassOptionsToClass{\pgfkeyscurrentname}{report}},
}
\ProcessPgfOptions{/ezthesis/options}
\ClassOptions{
  quality/.eval,
  font size/.eval,
  page sides/.eval,
}
\LoadClass{report}

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

\def\draftlabel{DRAFT}

\ClassOptions{
  spacing/.eval,
  language/.eval,
}


%% title page building blocks
\renewenvironment{titlepage}%
	{\let\ez@blockfill\relax
	 \thispagestyle{empty}\centering\null\vskip1in}
	{\vskip.5in\newpage}

\newcommand{\TitleBlock}[2][\ez@blockfill]{#1{#2\par}\let\ez@blockfill\vfill}

%% sectioning commands
\def\prefacesection#1{\clearpage\phantomsection
	\addcontentsline{toc}{chapter}{#1}\chapter*{#1}\markboth{#1}{}}
\let\phantomsection\@empty

\endinput

%% switches
\newif\if@bibfix\@bibfixtrue
\newif\if@fancyhdr\@fancyhdrtrue
\newif\if@colors\@colorstrue
\newif\if@graphicx\@graphicxtrue
\newif\if@natbib\@natbibtrue
\newif\if@bibnumbers\@bibnumbersfalse

\def\PassLayoutOptions#1{%
	\PassOptionsToClass{#1}{report}
	\PassOptionsToPackage{#1}{geometry}}

%% class options
\DeclareOption{numbers}{\@bibnumberstrue}
\DeclareOption{authoryear}{\@bibnumbersfalse}
\DeclareOption{nobibtoc}{\@bibfixfalse}
\DeclareOption{nofancyhdr}{\@fancyhdrfalse}
\DeclareOption{nocolors}{\@colorsfalse}
\DeclareOption{nographicx}{\@graphicxfalse}
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

\pagenumbering{arabic}

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

%% bibliography fix - makes bibliography appear
%% in table of contents, and makes it work nice
%% with hyperref
\def\bibliographyfix{%
	\let\old@bibliography\bibliography
	\def\bibliography{%
		\clearpage
		\phantomsection
		\addcontentsline{toc}{chapter}{\bibname}%
		\old@bibliography}}

\if@bibfix
	\AtBeginDocument{\bibliographyfix}
\fi

%% Graphics and colors
\if@graphicx
	\RequirePackage{graphicx}
\fi

\if@colors
	\RequirePackage{xcolor}
	\definecolor{dark-red}{rgb}{0.4,0.15,0.15}
	\definecolor{dark-blue}{rgb}{0.15,0.15,0.4}
	\definecolor{medium-blue}{rgb}{0,0,0.5}
\fi

% Linking and pdf options
\def\hyperlinking{%
	\providecommand\theHalgorithm{\thealgorithm}
	\providecommand\theHdefinition{\thedefinition}
	\providecommand\theHexample{\theexample}
	\providecommand\theHlemma{\thelemma}
	\providecommand\theHproposition{\theproposition}
	\providecommand\theHcorollary{\thecorollary}

	\RequirePackage[final,breaklinks,bookmarks]{hyperref}

	% properties of pdf file
	\hypersetup{%
		pdftitle={\inserttitle},pdfauthor={\insertauthor},
		pdfsubject={\insertdegree\ Thesis, \insertdepartment}}

	% color links
	\if@colors
		\hypersetup{%
			colorlinks,linkcolor={dark-red},citecolor={dark-blue},
			urlcolor={medium-blue}}
	\fi

	\renewcommand{\chapterautorefname}{Chapter}
	\renewcommand{\sectionautorefname}{Section}
	\renewcommand{\subsectionautorefname}{Section}
	\renewcommand{\subsubsectionautorefname}{Section}
	\RequirePackage[all]{hypcap}
}

\endinput
