%% ezthesis class for LaTeX2e.
%%
%% A custom thesis class
%% by Juan Antonio Navarro Perez
%% http://navarroj.com/latex
%% ezlatex@navarroj.com
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ezthesis}[2007/08/08 A custom thesis class]

%% switches
\newif\if@spanish\@spanishfalse
\newif\if@draft\@draftfalse
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
\DeclareOption{draft}{%
	\@drafttrue\PassOptionsToClass{draft}{report}
	\PassOptionsToClass{draft}{graphicx}}
\DeclareOption{draftmarks}{\@drafttrue\PassOptionsToClass{draft}{report}}
\DeclareOption{spanish}{\@spanishtrue}
\DeclareOption{final}{\@draftfalse}
\DeclareOption{letterpaper}{\PassLayoutOptions{letterpaper}}
\DeclareOption{a4paper}{\PassLayoutOptions{a4paper}}
\DeclareOption{twoside}{\PassLayoutOptions{twoside}}
\DeclareOption{oneside}{%
	\PassOptionsToClass{oneside}{report}%
	\PassOptionsToPackage{twoside=false}{geometry}}
\DeclareOption{singlespace}{\gdef\select@spacing{\singlespacing}}
\DeclareOption{onehalfspace}{\gdef\select@spacing{\onehalfspacing}}
\DeclareOption{doublespace}{\gdef\select@spacing{\doublespacing}}
\DeclareOption{10pt}{\gdef\select@fontsz{\PassOptionsToClass{10pt}{report}}}
\DeclareOption{11pt}{\gdef\select@fontsz{\PassOptionsToClass{11pt}{report}}}
\DeclareOption{12pt}{\gdef\select@fontsz{\PassOptionsToClass{12pt}{report}}}
\DeclareOption{numbers}{\@bibnumberstrue}
\DeclareOption{authoryear}{\@bibnumbersfalse}
\DeclareOption{nobibtoc}{\@bibfixfalse}
\DeclareOption{nofancyhdr}{\@fancyhdrfalse}
\DeclareOption{nocolors}{\@colorsfalse}
\DeclareOption{nographicx}{\@graphicxfalse}
\DeclareOption{nonatbib}{\@natbibfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

\ExecuteOptions{final,twoside,letterpaper,onehalfspace,12pt,authoryear}
\ProcessOptions\relax
\select@fontsz
\LoadClass{report}

%% spanish
\if@spanish
  \RequirePackage[activeacute,spanish]{babel}
\fi

%% fields
\def\author#1{\gdef\insertauthor{#1}\gdef\@author{#1}}
\def\title#1{\gdef\inserttitle{#1}\gdef\@title{#1}}
\def\supervisor#1{\gdef\insertsupervisor{#1}}
\def\institution#1{\gdef\insertinstitution{#1}}
\def\degree#1{\gdef\insertdegree{#1}}
\def\faculty#1{\gdef\insertfaculty{#1}}
\def\department#1{\gdef\insertdepartment{#1}}
\def\submitdate#1{\gdef\insertsubmitdate{#1}}

% some defaults and labels
\if@spanish
  \author{Falta nombre de autor}
  \title{Falta t\'itulo de la tesis}
  \degree{Doctorado}
  \supervisor{Falta nombre del supervisor}
  \institution{Universidad de Alg\'un Sitio}
  \faculty{Facultad de Ingenier\'ia y Ciencias}
  \department{Escuela de C\'omputo}
  \def\draftlabel{BORRADOR}
\else
  \author{Author name missing}
  \title{Thesis title missing}
  \degree{Doctor of Philosophy}
  \supervisor{Supervisor name missing}
  \institution{The University of Somewhere}
  \faculty{Faculty of Engineering and Physical Sciences}
  \department{School of Computer Science}
  \def\draftlabel{DRAFT}
\fi
\submitdate{\number\the\year}

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

%% spacing
\RequirePackage{setspace}
\select@spacing

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

%% sectioning commands
\def\prefacesection#1{\clearpage\phantomsection
	\addcontentsline{toc}{chapter}{#1}\chapter*{#1}\markboth{#1}{}}

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

%% title page building blocks
\renewenvironment{titlepage}%
	{\let\ez@blockfill\relax
	 \thispagestyle{empty}\centering\null\vskip1in}
	{\vskip.5in\newpage}

\newcommand{\TitleBlock}[2][\ez@blockfill]{#1{#2\par}\let\ez@blockfill\vfill}

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
\let\phantomsection\@empty
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
