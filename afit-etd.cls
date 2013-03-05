\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{afit-etd}[2012/05/31 version 1.5 Air Force Institute of
Technology Electronic Thesis and Dissertation Class]

% This is a full rewrite of the AFIT class file to clean up the code and 
% remove some inconsistencies caused by references to older packages.  The
% entire class is now contained within this one file.  The format was made
% to be consistent with the AFIT Style Guide with only minor differences as
% were present in the existing class file.  This version is fully compatible
% with pdfLaTeX.
%
% According to the documentation, the previous templates were maintained by 
% Mark Roth and others, Joel Young, and Maj Todd Hale.
%
% Send bug reports to the author at: Michael.Stepaniak@us.af.mil
%
% Changes: v1.1: fully incorporated the SF298 and the acronym package
%                brought into compliance with the 2011 AFIT Style Guide
%          v1.2: chapter numbers changed to roman numerals
%                chapter title fixed for use with natbib and a single appendix
%                added space after chapters in TOC
%          v1.3: removed SF298 generation from the report document type
%                requires totpages.sty (needed to calculate SF298 page count)
%                changes cover page to page number 0
%          v1.4: added \boxtowidth to support headers on List of Symbols, etc
%                added provision to shrink abstract font size on SF298
%          v1.5: fixed the code for the SF298 responsible person block


% define some macros that allow the class to pass options to the underlying
% article.cls without causing erroneous error messages about unused options

\newcommand* \afit@leqno{\@gobble} 
\newcommand* \afit@fleqn{\@gobble} 
\newcommand* \afit@draft{\@gobble} 
\newcommand* \afit@fontsize{12pt}

\newif \if@AFITnonumbers 
\newif \if@AFITdraft             
\newif \if@AFITsstables 
\newif \if@AFITcmfont
\newif \if@AFITflyleafframe

\DeclareOption  {draft}     {\renewcommand*\afit@draft{draft}\@drafttrue}
\DeclareOption  {leqno}     {\renewcommand*\afit@fleqn{fleqn}}
\DeclareOption  {fleqn}     {\renewcommand*\afit@leqno{leqno}}
\DeclareOption  {11pt}      {\renewcommand*\afit@fontsize{11pt}}
\DeclareOption  {12pt}      {\renewcommand*\afit@fontsize{12pt}}
\DeclareOption  {cmfont}    {\@AFITcmfonttrue}
\DeclareOption  {nonumbers} {\@AFITnonumberstrue}
\DeclareOption  {sstables}  {\@AFITsstablestrue}
\ExecuteOptions {12pt}
\ProcessOptions\relax

% This class is built on the traditional article class.
\LoadClass[\afit@draft,\afit@fleqn,\afit@leqno,\afit@fontsize]{article}

\RequirePackage {url}       % intelligent line breaks for URLs and DOIs
\RequirePackage {graphicx}  % standard package for including graphics
\RequirePackage {totpages}  % required to calculate page count on SF298
\RequirePackage {refcount}  % used to extract the page numbers from TotPages
\RequirePackage {ifpdf}     % provides for testing for pdfLaTeX
\RequirePackage[noconfig,floatlongboxes]{sf298} % produces the SF 298 page
\RequirePackage{amsmath,amsthm} % AMS math/thm must be defined prior to txfonts
\if@AFITcmfont\else\RequirePackage{txfonts}\fi % Times fonts versus Computer Modern
\urlstyle{same}

\AtEndOfClass{%
  \ifpdf
    %\RequirePackage[bookmarks, breaklinks, colorlinks,%
    %                linkcolor=black, urlcolor=black, citecolor=black]{hyperref}%
  \else                    
    \RequirePackage[bookmarks, colorlinks,%
                    linkcolor=black, urlcolor=black,
                    citecolor=black]{hyperref}%
  \fi
}

% provide the means to switch back and forth between single and double spacing, 
\newcommand* \singlespace{\renewcommand*\baselinestretch{1.0}\large\normalsize}
\newcommand* \afit@doublespace{\renewcommand*\baselinestretch{1.655}\large\normalsize}

\newlength \afit@lineskip   \setlength \afit@lineskip   {1.000\baselineskip}
\newlength \afit@doubleskip \setlength \afit@doubleskip {1.655\baselineskip}
\newlength \afit@fracskip   \setlength \afit@fracskip   {0.655\baselineskip}
\newlength \afit@partskip   \setlength \afit@partskip   {0.345\baselineskip}
\newlength \afit@halfskip   \setlength \afit@halfskip   {1.345\baselineskip}

\newcommand*\draftmode{\@AFITdrafttrue}


\AtBeginDocument{%
  \if@AFITdraft\singlespace\else\afit@doublespace\fi
  % adjust the acronym package's list format to conform to the AFIT style guide
  \@ifpackageloaded{acronym}{%
    \newcommand\afit@acronymwidth{Acronym}
    \renewcommand{\bflabel}[1]{{#1\hfill}}%
    \newlength\afit@acronymlabelsep
    \settowidth\afit@acronymlabelsep{\qquad}%
    \renewenvironment{AC@deflist}[1]{%
      \ifAC@nolist\else
        \newwrite\aftfile
        \immediate\openout\aftfile=\jobname.aft%
        \immediate\write\aftfile{\string\renewcommand\string\afit@acronymwidth{#1}}%
        \immediate\closeout\aftfile
        \raggedright\begin{list}{}{%
          \singlespace
          \setlength{\topsep}{\afit@fracskip}%
          \setlength{\itemsep}{\afit@fracskip}%
          \setlength{\parsep}{0pt}%
          \setlength{\partopsep}{0pt}%
          \setlength{\parskip}{0pt}%
          \settowidth{\labelwidth}{#1}%
          \setlength{\labelsep}{\afit@acronymlabelsep}%
          \setlength{\leftmargin}{\labelwidth}%
          \addtolength{\leftmargin}{\labelsep}%
          \renewcommand{\makelabel}{\bflabel}%
        }%
      \fi%
    }{%
      \ifAC@nolist\else
        \end{list}%
      \fi
    }%
    \newcommand\listofacronyms[1]{%
      \IfFileExists{\jobname.aft}{\makeatletter\input{\jobname.aft}\makeatother}{}%
      \newlength\afit@acronymleftmargin
      \settowidth\afit@acronymleftmargin{\afit@acronymwidth}%
      \addtolength\afit@acronymleftmargin{\afit@acronymlabelsep}%
      \addlistof{Acronyms}{\makebox[\afit@acronymleftmargin][l]{Acronym}Definition}{#1}%
    }
  }{}%
}

\newcounter{@appcount}
\AtEndDocument{%
  \if@AFITappendix
    \ifnum \c@chapter=\c@@appcount \else 
    \ClassWarningNoLine{afit-etd}{appendix count has changed.%
                            Rerun to get labels right}%
    \fi
    \immediate\write\@auxout{\string\setcounter{@appcount}{\number\c@chapter}}%
  \else
    \immediate\write\@auxout{\string\setcounter{@appcount}{0}}%
  \fi    

  % Definitions required for the SF298
  \ReportDate{\afit@gradday--\afit@sfmonth--\afit@gradyear}
  \Title\@title
  \ifx\afit@doctype\afit@thesis\ReportType{Master's Thesis}
  \else
    \ifx\afit@doctype\afit@dissertation\ReportType{Doctoral Dissertation}
    \else\ReportType{Graduate Research Project}
    \fi
  \fi
  \Author{\sf@author, \afit@rank}
  \PerformingOrg{Air Force Institute of Technology\\Graduate School of Engineering and Management (AFIT/EN)\\2950 Hobson Way\\WPAFB, OH 45433-7765}
  \POReportNumber{\afit@designator} 
  \DistributionStatement{\afit@distribution}
  \SupplementaryNotes{This work is declared a work of the U.S. Government and
    is not subject to copyright protection in the United
    States. \sf@AddlSupplementaryNotes}
  \newcommand\AbstractSize\relax
  \Abstract{\AbstractSize\sf@abstract}
  \NumberPages{\getrefnumber{TotPages}}

  \afit@vita
  \if@isAFITreport\else\MakeRptDocPage\fi
  }

\setlength\paperheight    {11.0in}
\setlength\paperwidth     { 8.5in}
                          
\setlength\hoffset        {0in}
\setlength\voffset        {0in}
\setlength\marginparwidth {0in}     % no marginal notes
\setlength\marginparsep   {0in}
\setlength\marginparpush  {0in}

\setlength\oddsidemargin  {0.25in}   % (in addition to the 1in default)
\setlength\evensidemargin {0.25in}   % (in addition to the 1in default)
\setlength\topmargin      {0in}      % (in addition to the 1in default)
\setlength\headheight     {0in} 
\setlength\headsep        {0in} 

\setlength\footskip{.5in} % set page number .75" from bottom
                          
\setlength\textwidth {\paperwidth}
\setlength\textheight{\paperheight}

\addtolength \textwidth {-2.5in}    % 1.25" for left and right margins
\addtolength \textheight{-2.25in}   % 1" top and 1.25" bottom margins
\addtolength \textheight{-\headheight}
\addtolength \textheight{-\headsep}

\renewcommand \topfraction      {1} % allow floats to cover full page
\renewcommand \textfraction     {0}
\renewcommand \floatpagefraction{.5}

\def\ps@headings{%
  \def\@oddhead {}%
  \def\@evenhead{}%
  \def\@oddfoot {\hfil\thepage\hfil}%
  \def\@evenfoot{}%
  \let\@mkboth\markboth
}

% MACROS FOR THE PREFATORY PAGES

\newcommand*\graduation[3]{%
  \newcommand*\afit@gradday{#1}%
  \begingroup
    \def\month{#2}%
    \def\monthMar{March}%
    \def\monthJun{June}%
    \def\monthSep{September}%
    \def\monthDec{December}%
    \ifx\month\monthMar\endgroup\newcommand*\afit@gradmonth{#2}
                                \newcommand*\afit@sfmonth{03}
    \else\ifx\month\monthJun\endgroup\newcommand*\afit@gradmonth{#2}
                                     \newcommand*\afit@sfmonth{06}
    \else\ifx\month\monthSep\endgroup\newcommand*\afit@gradmonth{#2}
                                     \newcommand*\afit@sfmonth{09}
    \else\ifx\month\monthDec\endgroup\newcommand*\afit@gradmonth{#2}
                                     \newcommand*\afit@sfmonth{12}
    \else
      \ClassWarning{afit-etd}{graduation month not recognized (expecting March,%
        June, September, or December)}%
    \fi\fi\fi\fi
  \newcommand*\afit@gradyear{#3}%
}

\global\let\afit@coauthor\@empty
\global\let\afit@committeeSignedDates\@empty
\global\let\afit@deanSignedDate\@empty
\global\let\sf@AddlSupplementaryNotes\@empty

\newif\if@isAFITreport

\newcommand*\department[1]  {\newcommand*\afit@department{#1}}
\newcommand*\school[1]      {\newcommand*\afit@school{#1}}

\newcommand*\dean[1]          {\newcommand*\afit@dean{#1}}
\newcommand*\deanSignedDate[1]{\renewcommand*\afit@deanSignedDate{#1}}

\newcommand\committee[1]    {\newcommand\afit@committee{#1}}
\newcommand*\committeeSignedDates[1]  {\renewcommand*\afit@committeeSignedDates{#1}}

\renewcommand\title[1]      {\renewcommand\@title{#1}}
\renewcommand*\author[2]    {\renewcommand*\@author{#1 #2}
                             \newcommand\sf@author{#2, #1}}
\newcommand*\rank[1]        {\newcommand*\afit@rank{#1}}
\newcommand*\previousdegrees[1]{\newcommand\afit@previousdegrees{#1}}

\newcommand*\coauthor[1]    {\renewcommand*\afit@coauthor{#1}}
\newcommand*\corank[1]      {\newcommand*\afit@corank{#1}}
\newcommand*\copreviousdegrees[1]{\newcommand\afit@coprevdegrees{#1}}

\newcommand*\afit@dissertation{DISSERTATION}
\newcommand*\afit@thesis{THESIS}
\newcommand*\afit@grp{GRADUATE RESEARCH PAPER}
\newcommand*\afit@report{REPORT}
\newcommand*\afit@PhD{Doctor of Philosophy}
\newcommand*\degree[1]{\newcommand*\afit@degree{#1}}
\newcommand*\doctype[1]{\newcommand*\afit@doctype{#1}
                        \ifx\afit@doctype\afit@report\@isAFITreporttrue\fi}

\newcommand*\designator[1]{\newcommand*\afit@designator{#1}}
\newcommand*\distribution[1]{\newcommand\afit@distribution{\textbf{#1}}}

\newcommand*\flyleafframe{\@AFITflyleafframetrue} 
\newcommand*\AddlSupplementaryNotes[1]  {\renewcommand\sf@AddlSupplementaryNotes{#1}}

% PREFATORY PAGES

\newcommand{\afit@centeredpage}[1]{%
  \newpage
  \vbox to \textheight{%
    \singlespace
    \vfil
    \noindent #1 \par
    \vfil
  }
}

\newcommand\makePrefatoryPages{%
  
  % error checking
  \begingroup
    \newif\if@ferr
    \@ferrfalse
    \@ifundefined{afit@gradmonth}{%
      \@ferrtrue\ClassWarningNoLine{afit-etd}{missing graduation month}}{}%
    \@ifundefined{afit@committee}{%
      \@ferrtrue\ClassWarningNoLine{afit-etd}{missing committee members}}{}%
    \@ifundefined{afit@department}{%
      \@ferrtrue\ClassWarningNoLine{afit-etd}{missing department name}}{}%
    \@ifundefined{@author}{%
      \@ferrtrue\ClassWarningNoLine{afit-etd}{missing author's name}}{}%
    \@ifundefined{afit@doctype}{%
      \@ferrtrue\ClassWarningNoLine{afit-etd}{missing document type}}{%
        \ifx\afit@doctype\afit@dissertation\else
        \ifx\afit@doctype\afit@grp\else
        \ifx\afit@doctype\afit@thesis\else
        \ifx\afit@doctype\afit@report\else
          \@ferrtrue\ClassWarningNoLine{afit-etd}{document type must be DISSERTATION, THESIS, GRADUATE RESEARCH PAPER, or REPORT}
        \fi\fi\fi\fi
      }%
    \@ifundefined{@title}{%
      \@ferrtrue\ClassWarningNoLine{afit-etd}{missing document's ttle}}{}%
    \if@ferr%
      \ClassError{afit-etd}{missing required prefatory definitions}%
                 {All prefatory macros must be defined in the preamble}%
    \fi
  \endgroup

  \ifpdf
    \ifx\afit@coauthor\@empty
      \hypersetup{pdftitle={\@title},pdfauthor={\@author}}%
    \else
      \hypersetup{pdftitle={\@title},pdfauthor={\@author and \afit@coauthor}}%
    \fi
    % The following line accomodates transparency in PDF files
    \pdfpageattr {/Group << /S /Transparency /I true /CS /DeviceRGB>>}%
  \fi
  
  % print the prefatory pages
  \pagenumbering{roman}%
  \afit@cover
  \if@isAFITreport\else
    \afit@disclaimer 
    \afit@titlepage      
    \afit@approvalpage   
    \afit@abstract       
    \afit@dedication     
    \afit@acknowledgments
  \fi
  
  \newlength\afit@headheight
  \newlength\afit@headsep
  \setlength\afit@headheight   {\afit@lineskip}%
  \addtolength\afit@headheight {-.5\afit@partskip}% Exact positioning of header
  \setlength\afit@headsep      {\afit@fracskip}%
  \addtolength\afit@headsep    {.5\afit@partskip}% Exact positioning of header

  \addtolength\textheight {-\afit@headheight}%
  \addtolength\textheight {-\afit@headsep}%
  \clearpage
  \setlength\headheight   {\afit@headheight}%
  \setlength\headsep      {\afit@headsep}%
  \tableofcontents
  \setcounter{tocdepth}{1}% Needed to print the following lists
  \@listoffigures  
  \@listoftables   
  \@listofsymbols   
  \@listofabbreviations   
  \@makelist
  \addtolength\textheight {\afit@headheight}%
  \addtolength\textheight {\afit@headsep}%

  \newpage
  \setlength\headheight {0pt}% 
  \setlength\headsep    {0pt}%
  \pagestyle{headings}%
  \pagenumbering{arabic}%

  % free up some memory
  \global\let\afit@centeredpage    \@empty
  \global\let\afit@titlepage       \@empty
  \global\let\afit@disclaimer      \@empty
  \global\let\afit@approvalpage    \@empty
  \global\let\afit@abstract        \@empty
  \global\let\afit@dedication      \@empty
  \global\let\afit@acknowledgments \@empty
  \global\let\@listoftables        \@empty
  \global\let\@listoffigures       \@empty
  \global\let\afit@gradmonth       \@empty
  \global\let\afit@department      \@empty
  \global\let\afit@dean            \@empty    
  \global\let\disclaimer           \relax
  \global\let\abstract             \relax
  \global\let\dedication           \relax
  \global\let\acknowledgments      \relax
  \global\let\acknowledgements     \relax
  \global\let\tableofcontents      \relax
  \global\let\graduation           \relax
  \global\let\department           \relax
  \global\let\dean                 \relax    
}
  
\newcommand\afit@cover{%
  \setcounter{page}{0}%
  \thispagestyle{empty}%
  \begingroup
  \singlespace
    \if@AFITflyleafframe\else\setlength\fboxrule{0pt}\fi
    \begin{center}%
      \addvspace{1in}%
      \includegraphics[width=3in]{afitlogo}\par
      \vfill
      \framebox[4in]{%
        \vbox to 2in{%
          \vspace{\fboxsep}%
          {\afit@doublespace\bfseries\expandafter\uppercase\expandafter{\@title}\par}%
          \vfill
          \afit@doctype
          \vfill
          \ifx\afit@coauthor\@empty
          \@author, \afit@rank
          \else
          \begin{minipage}[t]{2in}%
            \begin{center}%
              \@author\\%
              \afit@rank
            \end{center}%
          \end{minipage}%
          \begin{minipage}[t]{2in}%
            \begin{center}%
              \afit@coauthor\\%
              \afit@corank
            \end{center}%
          \end{minipage}%
          \fi\\[1\afit@lineskip minus 1\afit@fracskip]%
          \afit@designator
          \vspace{\fboxsep}%
        }% vbox
      }\\% framebox
      \vfill
      {\bfseries
        {\sffamily DEPARTMENT OF THE AIR FORCE\\AIR UNIVERSITY}\\[\afit@fracskip]%
        {\itshape\Large% 
          \newlength{\@afitwidth}%
          \settowidth{\@afitwidth}{AIR FORCE INSTITUTE OF TECHNOLOGY }%
          AIR FORCE INSTITUTE OF TECHNOLOGY\par
          \vspace{-1.1\afit@lineskip}%
          \rule{\@afitwidth}{2pt}\par
          \vspace{-1.3\afit@lineskip}%
          \rule{\@afitwidth}{1pt}\\[.5\afit@lineskip]%
        }%
        {\sffamily Wright-Patterson Air Force Base, Ohio}\\[\afit@doubleskip]%
      }%
      {\singlespace\afit@distribution}%
    \end{center}%
  \endgroup
  \newpage\thispagestyle{empty}%
}

\newcommand\afit@disclaimer{ \afit@centeredpage{The views expressed in
    this \expandafter\lowercase\expandafter{\afit@doctype} are those
    of the author\ifx\afit@coauthor\@empty\else{s}\fi{} and do
    not reflect the official policy or position of the United States
    Air Force, the Department of Defense, or the United
    States Government.\\[\afit@lineskip]
    \noindent This material is declared a work of the U.S. Government
    and is not subject to copyright protection in the United States.}
}
\newcommand\disclaimer[1]{\renewcommand\afit@disclaimer{\afit@centeredpage{#1}}}


\newcommand\afit@titlepage{%
  \newpage
  \thispagestyle{empty}%
  \noindent\afit@designator
  \begin{center}%
    \vspace{3\afit@lineskip}%
    {\expandafter\uppercase\expandafter{\@title}}\par
    \vspace{\afit@doubleskip}%
    \afit@doctype\par
    \vspace{1.5\afit@doubleskip}%
    Presented to the Faculty\par
    \ifx\afit@doctype\afit@dissertation\else\afit@department\par\fi
    \afit@school\par
    Air Force Institute of Technology\par
    Air University\par
    Air Education and Training Command\par
    in Partial Fulfillment of the Requirements for the\par
    Degree of \afit@degree\par
    \vspace{1.5\afit@doubleskip}%
    \ifx\afit@coauthor\@empty
      \@author, \afit@previousdegrees\par
      \afit@rank\par
    \else
      \begin{minipage}[t]{.5\textwidth}%
        \begin{center}%
          \singlespace
          \@author, \afit@previousdegrees\par
          \afit@rank\par
        \end{center}%
      \end{minipage}%
      \begin{minipage}[t]{.5\textwidth}%
        \begin{center}%
          \singlespace
          \afit@coauthor, \afit@coprevdegrees\par
          \afit@corank\par
        \end{center}%
      \end{minipage}\\[\afit@lineskip]% accounts for second line in minipage
    \fi
    \vspace{\afit@doubleskip}%
    \afit@gradmonth\ \afit@gradyear\\[\afit@doubleskip]%
    \vfill
    {\singlespace\afit@distribution\par}%
  \end{center}%
  \setcounter{footnote}{0}%
}


% Comma delimited list of committee members is the parameter.
% e.g.
%\committee{{Iam N. Charge, PhD (Chairman)},
%           {Maj Painin Deass, PhD (Member)},
%           {Howcomb I. Last, PhD (Member)}}
%

\newcommand\sign@lines[2]{% parameters are lists of: names, dates
  % Create an empty list of dates corresponding to the number of committee 
  % members.  This allows the following code to generate the blank date lines
  \let\afit@signdate#2%
  \ifx\afit@signdate\@empty
    \@for\@comem:=#1\do{%
      \ifx\afit@signdate\@empty\renewcommand\afit@signdate\relax
      \else\expandafter\renewcommand\expandafter\afit@signdate
           \expandafter{\afit@signdate,}%
      \fi
    }%
  \fi
  \begin{minipage}[t]{4.25in}%
    \@for\@comem:=#1\do{%
      \vspace{\afit@doubleskip}% add additional space for signature
      \ifx#2\@empty\vspace{\afit@lineskip}%
      \else\makebox[3.25in][c]{/signed/}\par
      \fi
      \vspace{-\afit@fracskip}% force the /signed/ mark to be on the line
      \rule{3.25in}{0.5pt}\par%
      \@comem\par
    }%
  \end{minipage}%
  \begin{minipage}[t]{1.25in}%
    \@for\@date:=\afit@signdate\do{%
      \vspace{\afit@doubleskip}% add additional space for signature
      \ifx\@date\@empty\vspace{\afit@lineskip}%
      \else\makebox[1.25in][c]{\@date}\par
      \fi
      \vspace{-\afit@fracskip}% force the /signed/ mark to be on the line
      \rule{1.25in}{0.5pt}\par%
      Date\par
    }%
  \end{minipage}
  \par
}

\newcommand{\afit@approvalpage}{%
  \newpage
  \thispagestyle{empty}%
  \noindent\afit@designator
  \begin{center}%
    \vspace{3\afit@lineskip}%
    {\expandafter\uppercase\expandafter{\@title}}\par
    \vspace{\afit@doubleskip}%
    \singlespace
    \vspace{\afit@lineskip}%
    \vfill
    \ifx\afit@coauthor\@empty
      \@author, \afit@previousdegrees\par
      \afit@rank
    \else
    \begin{minipage}[t]{.5\textwidth}%
      \begin{center}%
        \@author, \afit@previousdegrees\par
        \afit@rank
      \end{center}%
    \end{minipage}%
    \hfill
    \begin{minipage}[t]{.5\textwidth}%
      \begin{center}%
        \afit@coauthor, \afit@coprevdegrees\par
        \afit@corank
      \end{center}%
    \end{minipage}%
    \fi
    \vfill
  \end{center}%
  \begingroup
    \singlespace
    \noindent Approved:\par
	\IfFileExists{signatures.png}{%
		\includegraphics[width=5.5in]{signatures.png}
		}{%
		\sign@lines\afit@committee\afit@committeeSignedDates\par
		\addvspace{2\afit@lineskip}%
		\ifx\afit@doctype\afit@dissertation
		  \noindent Accepted:\par
		  \sign@lines{\afit@dean\\Dean{,} \afit@school}\afit@deanSignedDate\par
		\fi%
		}
  \endgroup
}

\renewcommand\abstract[2][]{\newcommand\afit@abstract{\@sabstracttoc{Abstract} #2}
                                   \newcommand\sf@abstract{%
								       \ifx&#1&%
                                           #2%
									   \else%
                                           #1%
									   \fi%
								   }}

\newcommand\afit@dedication{\relax}
\newcommand\dedication[1]{%
    \renewcommand\afit@dedication{%
        \clearpage
        \refstepcounter{schapter}%
        \addcontentsline{toc}{chapter}{Dedication}%
        \afit@centeredpage{\textit{#1\\}}%
      }%
}

\newcommand\afit@vita{\relax}
\newcommand\vita[1]{\renewcommand\afit@vita{\@schaptertoc{Vita}#1}}

\let\afit@acknowledgments\relax
\newcommand\acknowledgments[1]{%
  \@ifundefined{@acknowledgments}%
    {\newcommand\afit@acknowledgments{\@schaptertoc{Acknowledgments}#1\par\addvspace{\afit@doubleskip}\hspace{.55\linewidth}\@author}}%
    {\ClassWarning{afit-etd}{ignoring subsequent \protect\acknowledgments}}%
}
\newcommand\acknowledgements[1]{%
  \@ifundefined{@acknowledgments}%
    {\newcommand\afit@acknowledgments{\@schaptertoc{Acknowledgements}#1\par\addvspace{\afit@doubleskip}\hspace{.55\linewidth}\@author}}%
    {\ClassWarning{afit-etd}{ignoring subsequent \protect\acknowledgements}}%
}

\newcounter{listctr}
\newcounter{listcnt}
\renewcommand\thelistcnt{\@Alph\c@listcnt}
\renewcommand\thelistctr{\@Alph\c@listctr}

\newcommand\@makelist{%
  \ifnum \c@listcnt>\c@listctr
    \refstepcounter{listctr}%
    \csname @listof\thelistctr \endcsname
    \@makelist
  \fi
}

\newcommand\boxtowidth[2]{\settowidth\@tempdima{#1}\makebox[\@tempdima][l]{#2}}

\newcommand\addlistof[3]{%
  \refstepcounter{listcnt}%
  \expandafter\gdef\csname @listof\thelistcnt\endcsname{%
    \afit@listof{List of #1}{#2}{\relax}{#3}%
  }%
}

% \@addlistof{Name in Title}{Left Header}{Right Header}{Contents}
% e.g. \@addlistof{Figures}{Figure}{Page}{\@starttoc{lof}}
\newcommand\afit@listof[4]{%
  \clearpage
  \def\ps@addlistof{\renewcommand\@oddhead{#2\hfill #3}}%
  \thispagestyle{headings}%
  \pagestyle{addlistof}%
  \global\@topnum\z@
  \@afterindenttrue
  \refstepcounter{schapter}%
  \addcontentsline{toc}{chapter}{#1}%
  \vspace*{-\afit@lineskip}% compensate for the vertical space added by the 
  \vspace*{-\afit@fracskip}% header for these lists
  \@makechapterhead{#1}%
  \noindent#2\hfill#3\par%
 #4%
}

\renewcommand\tableofcontents{\afit@listof{Table of Contents}{\relax}{Page}{\vspace{-\afit@halfskip}\@starttoc{toc}}}
\newcommand\@listoffigures   {\afit@listof{List of Figures}  {Figure}{Page}{\@starttoc{lof}}}
\newcommand\@listoftables    {\afit@listof{List of Tables}   {Table} {Page}{\@starttoc{lot}}}

\newcommand\@listofsymbols{\relax}
\newcommand\listofsymbols[1][2.3em]{%
  \newcommand*\l@symbol{\@dottedtocline{1}{0em}{#1}}%
  \renewcommand\@listofsymbols{\afit@listof{List of Symbols}{Symbol}{Page}{\@starttoc{los}}}%
}
\newcommand\addsymbol[2]{#2\addcontentsline{los}{symbol}{\numberline{#2}{#1}}}

\newcommand\@listofabbreviations{\relax}
\newcommand\listabbrevname{List of Abbreviations}
\newcommand\listofabbreviations[1][2.3em]{%
  \newcommand*\l@abbrev{\@dottedtocline{1}{0em}{#1}}%
  \renewcommand\@listofabbreviations{\afit@listof{List of Abbreviations}{Abbreviation}{Page}{\@starttoc{loa}}}%
}
\newcommand\addabbrev[2]{#2\addcontentsline{loa}{abbrev}{\numberline{#2}{#1}}}

\newcommand\notables {\renewcommand\@listoftables{}}
\newcommand\nofigures{\renewcommand\@listoffigures{}}

% a wrapper to fix formatting while largely keeping the bibliography
% environment intact to protect packages that might rely on that environment to
% make modifications 
\newcommand\references[1]{%
  \begingroup
    \singlespace
    % the following lines restore the correct vertical spacing for the
    % chapter title, i.e. "Bibliography", in the singlespaced environment and
    % start the new chapter.  These are implemented here rather than in the
    % Bibliography environment to maintain compatibility with packages such as
    % natbib which redefine the Bibliography environment.
    \clearpage
    \global\@topnum\z@
    \@afterindenttrue
    \refstepcounter{schapter}%
    \addcontentsline{toc}{chapter}{\bibname}%
    \let\afit@bibname\bibname
    \renewcommand\bibname{
      \vspace{\afit@fracskip}%
      \afit@bibname
      \vspace{\afit@fracskip}%
    }%
    #1%
  \endgroup
}

\newcommand*{\bibname}{Bibliography}
% The bibliography environment is largely carried over from the article class.
% The change being that the bibliography is now contained in a separate chapter
% rather than in a section.
\renewenvironment{thebibliography}[1]{% 
  \@schapter{\bibname}% change from article.cls where it was a section
  \list{ \@biblabel{\@arabic\c@enumiv}}%
       { \settowidth\labelwidth{\@biblabel{#1}}%
         \leftmargin\labelwidth
         \advance\leftmargin\labelsep
         \usecounter{enumiv}%
         \let\p@enumiv\@empty
         \renewcommand\theenumiv{\@arabic\c@enumiv}%
       }%
   \sloppy
   \clubpenalty4000%
   \@clubpenalty \clubpenalty
   \widowpenalty4000%
   \sfcode`\.\@m
}
{\def\@noitemerr
  {\@latex@warning{Empty `thebibliography' environment}}%
  \endlist
}

\newif\if@AFITappendix 
\renewcommand\appendix{%
  \@AFITappendixtrue
  \setcounter{chapter}{0}%
  \renewcommand\thechapter {\@Alph\c@chapter}%
  \ifnum \c@@appcount>1%
    \newcommand*\@appname{Appendix\space\thechapter}%
  \else
    \newcommand*\@appname{Appendix}%
  \fi
  % restrict toc to Appendix title only (no sections within the Appedix)
  \addtocontents{toc}{\protect\setcounter{tocdepth}{0}}%
}

\newcounter{chapter}
\newcounter{schapter}
\renewcommand\thesection  {\thechapter.\@arabic\c@section}

\newcommand\chapter{%
  \clearpage
   \global\@topnum\z@
   \@afterindenttrue
   \secdef\@chapter\@schapter
}

\def\@schapter#1{% used by some bibliography packages
  \@makechapterhead{#1}%
}

\newcommand\@sabstracttoc[2][schapter]{%
  \clearpage
  \global\@topnum\z@
  \@afterindenttrue
  \refstepcounter{#1}%
  \addcontentsline{toc}{chapter}{#2}%
  \noindent\afit@designator\par
  \@makechapterhead{#2}%
}

\newcommand{\@schaptertoc}[2][schapter]{%
  \clearpage
  \global\@topnum\z@
  \@afterindenttrue
  \refstepcounter{#1}%
  \addcontentsline{toc}{chapter}{#2}%
  \@makechapterhead{#2}%
}

\if@AFITnonumbers\setcounter{secnumdepth}{0}\fi
\def\@chapter[#1]#2{%
  \refstepcounter{chapter}%
  \if@AFITappendix
    \typeout{Appendix \thechapter.}%
    \addcontentsline{toc}{chapter}{\@appname:\space#1}%
    \@makechapterhead{\@appname:\space#2}%
  \else
    \typeout{Chapter\space\@Roman\c@chapter.}%
    \addcontentsline{toc}{chapter}{\protect\numberline{\@Roman\c@chapter.}#1}%
    \@makechapterhead{\@Roman\c@chapter.\quad#2}%
  \fi
}

\def\@makechapterhead#1{%
  \begingroup
    \ifnum\value{chapter}=1% add the title to the first chapter
      \if@AFITappendix
        \setlength\@tempdima{.25in}% chapter titles start 1.25 in from the top
        \addtolength\@tempdima{-\afit@doubleskip}% 
        \addtolength\@tempdima{-\afit@partskip}%
        \vspace*{\@tempdima}%
      \else
        \begin{center}%
          \vspace*{\afit@lineskip}%
          {\expandafter\uppercase\expandafter{\@title}}%
          \vspace{\afit@doubleskip}%
        \end{center}%
      \fi
    \else
      \setlength\@tempdima{.25in}% chapter titles start 1.25 in from the top
      \addtolength\@tempdima{-\afit@doubleskip}% 
      \addtolength\@tempdima{-\afit@partskip}%
      \vspace*{\@tempdima}%
    \fi
    \centering \bfseries #1 \par \nobreak
    \vspace{\afit@halfskip}%
  \endgroup
  \@afterheading
}

\renewcommand\section{\@startsection {section}{1}{\z@}%
  {2.1ex\@plus -1ex \@minus -.2ex}{0.1ex \@plus.2ex}%
  {\normalfont\normalsize\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{\parindent}%
  {0.1ex\@plus -1ex \@minus -.2ex}{0.1ex \@plus.2ex}%
  {\normalfont\normalsize\bfseries\itshape}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{2\parindent}%
  {0.1ex\@plus -1ex \@minus -.2ex}{0.1ex \@plus.2ex}%
  {\normalfont\normalsize\bfseries\itshape}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\parindent}%
  {0ex\@plus -1ex \@minus -.2ex}{-1em}{\normalfont\normalsize\bfseries\itshape}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
  {0ex \@plus1ex \@minus .2ex}{-1em}{\normalfont\normalsize\itshape}}

% The following is extracted directly from the LaTeX source code so that a 
% minor modification could be made to add a period for subsections and deeper
% sections.  This is a simpler change than was previously implemented.
\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2>\c@secnumdepth
  \let\@svsec\@empty
  \else
  \refstepcounter{#1}%
  \protected@edef\@svsec{\@seccntformat{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
  \begingroup
  #6{%
    \@hangfrom{\hskip #3\relax\@svsec}%
    \interlinepenalty \@M #8\ifnum#2>1.\fi\@@par}% add period if > section
  \endgroup
  \csname #1mark\endcsname{#7}%
  \addcontentsline{toc}{#1}{%
    \ifnum #2>\c@secnumdepth \else
    \protect\numberline{\csname the#1\endcsname}%
    \fi
    #7}%
  \else
  \def\@svsechd{%
    #6{\hskip #3\relax
      \@svsec #8.}% add period
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
      \protect\numberline{\csname the#1\endcsname}%
      \fi
      #7}}%
  \fi
  \@xsect{#5}%
}
\def\@ssect#1#2#3#4#5{%
  \@tempskipa #3\relax
  \ifdim \@tempskipa>\z@
  \begingroup
  #4{%
    \@hangfrom{\hskip #1}%
    \interlinepenalty \@M #5\ifnum#2>1.\fi\@@par}% add period if > section
  \endgroup
  \else
  \def\@svsechd{#4{\hskip #1\relax #5.}}% add period
  \fi
  \@xsect{#3}%
}

\if@AFITnonumbers
  \renewcommand* \thechapter      {\@Roman\c@chapter}%
  \renewcommand* \theequation     {\@arabic\c@equation}%
  \renewcommand* \thefigure       {\@arabic\c@figure}%
  \renewcommand* \thetable        {\@arabic\c@table}%
  \renewcommand* \l@figure        {\@dottedtocline{1} {0em}   {2.3em}}%
  \renewcommand* \l@table         {\@dottedtocline{1} {0em}   {2.3em}}%
  \renewcommand* \l@section       {\@dottedtocline{1} {1.5em} {0em}}%
  \renewcommand* \l@subsection    {\@dottedtocline{2} {3.0em} {0em}}%
  \renewcommand* \l@subsubsection {\@dottedtocline{3} {4.5em} {0em}}%
  \renewcommand* \l@paragraph     {\@dottedtocline{4} {6.0em} {0em}}%
  \renewcommand* \l@subparagraph  {\@dottedtocline{5} {7.5em} {0em}}%
\else
  \@addtoreset {equation} {chapter}%
  \@addtoreset {figure}   {chapter}%
  \@addtoreset {table}    {chapter}%
  \@addtoreset {section}  {chapter}%
  \renewcommand* \thechapter      {\@arabic\c@chapter}%
  \renewcommand* \theequation     {\thechapter.\@arabic\c@equation}%
  \renewcommand* \thefigure       {\thechapter.\@arabic\c@figure}%
  \renewcommand* \thetable        {\thechapter.\@arabic\c@table}%
  \renewcommand* \l@figure        {\@dottedtocline{1} {0em}   {2.3em}}%
  \renewcommand* \l@table         {\@dottedtocline{1} {0em}   {2.3em}}%
  \renewcommand* \l@section       {\@dottedtocline{1} {1.5em} {2.3em}}%
  \renewcommand* \l@subsection    {\@dottedtocline{2} {3.8em} {3.2em}}%
  \renewcommand* \l@subsubsection {\@dottedtocline{3} {7.0em} {4.1em}}%
  \renewcommand* \l@paragraph     {\@dottedtocline{4} {10em}  {5em}}%
  \renewcommand* \l@subparagraph  {\@dottedtocline{5} {12em}  {6em}}%
\fi

\setcounter{tocdepth}{3}

\def\fps@figure{tbh}
\def\fnum@figure{Figure\nobreakspace\thefigure}
\renewenvironment{figure}{\vspace\afit@fracskip\@float{figure}}{\end@float}

\def\fps@table{tbh}
\def\fnum@table{Table\nobreakspace\thetable}
\renewenvironment{table}%
               { \if@AFITsstables \singlespace \fi
                 \vspace\afit@fracskip \@float{table}%
               }%
               { \vspace{-\afit@lineskip}%
                 \end@float
               }
\renewenvironment{table*}{\if@AFITsstables\singlespace\fi\@dblfloat{table}}%
                         {\end@dblfloat}

\setlength\floatsep      {2\afit@doubleskip \@plus 1\p@ \@minus 1\p@}
\setlength\textfloatsep  {1\afit@doubleskip \@plus 1\p@ \@minus 1\p@}
\setlength\intextsep     {1\afit@doubleskip \@plus 1\p@ \@minus 1\p@}
\setlength\@fptop        {0\p@} % align float pages with the top of the page
\addtolength\textfloatsep\afit@lineskip

\setlength\abovecaptionskip{1ex}
\setlength\belowcaptionskip{1ex}
\long\def\@makecaption#1#2{%
  \expandafter\ifx#1\fnum@table 
  \else 
    \vskip \abovecaptionskip 
  \fi
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize%
    \begingroup
      \singlespace #1: #2\par
    \endgroup
  \else
    \global \@minipagefalse
    \begingroup
      \singlespace \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
    \endgroup
  \fi
  \expandafter\ifx#1\fnum@table 
    \vskip \belowcaptionskip
  \fi
}

\newcommand\l@chapter[2]{%
  \setlength\@tempdima{1.5em}%
  \begingroup
    \addvspace{\afit@lineskip}%
    \addpenalty{-\@highpenalty}%
    \@dottedtocline{0}{0em}{1.5em}{#1}{#2}\par%
    \nobreak
    \addvspace{\afit@lineskip}%
  \endgroup
  \singlespace
}

\renewcommand\@makefntext[1]{%
  \noindent
  \hb@xt@2em{\hss\@makefnmark}%
  \singlespace\footnotesize #1%
}

\pagestyle{headings}
% \raggedright
\setlength\parindent{2em} % must follow the \raggedright or will be reset to 0
\pretolerance=2000  
\clubpenalty =10000  
\widowpenalty=10000 
