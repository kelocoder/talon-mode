Note: this file is auto converted from talon-mode.el by [el2org](https://github.com/tumashu/el2org), please do not edit it by hand!!!


# Table of Contents

1.  [Overview](#org07c18c4)
2.  [Features](#orgdf6719f)
    1.  [Syntax Highlighting](#org43c1819)
    2.  [Indentation Support](#orgf12c05e)
    3.  [Syntax Table Configuration](#orga492d81)
    4.  [Outline Minor Mode Default Settings](#org364857a)
3.  [Installation](#org257cab8)
4.  [Usage](#orgc02bf94)


<a id="org07c18c4"></a>

# Overview

talon-mode is a major mode for editing Talon Voice scripts.

Features include:

1.  Syntax Highlighting
2.  Indentation Support
3.  Syntax Table Configuration
4.  Outline Minor Mode Default Settings


<a id="orgdf6719f"></a>

# Features


<a id="org43c1819"></a>

## Syntax Highlighting

Syntax highlighting is supported through configuration of \`font-lock'
faces.

The following faces are matched to the talon script elements listed:

-   \`font-lock-comment-face':
    -   Comments
-   \`font-lock-builtin-face':
    -   Built-in actions (ex. 'key', 'insert')
    -   Context header identifiers (ex. 'app.name', 'os')
-   \`font-lock-preprocessor-face':
    -   'settings' and 'tags' identifiers
-   \`font-lock-function-name-face':
    -   Rules


<a id="orgf12c05e"></a>

## Indentation Support

A straightforward indentation function is implemented.

The following custom variables are provided:

-   \`tal-indent-offset'


<a id="orga492d81"></a>

## Syntax Table Configuration

Some characters in the \`syntax-table' are modified to enable proper
parsing, movement, and syntax highlighting (features implemented by other
Emacs facilities).


<a id="org364857a"></a>

## Outline Minor Mode Default Settings

Comment lines starting with '#- ', '#&#x2013; ', or '#&#x2014; ' are matched
as outline headings.

    Collapsing all headings will produce a result like this:
    #- Heading Level 1
    #-- Heading Level 2
    #--- Heading Level 3

The following custom variables are provided:

-   \`tal-outline-regexp'


<a id="org257cab8"></a>

# Installation

talon-mode is currently not managed by any package repository.

To install it:

1.  Copy this file into your emacs site-lisp dir or somewhere in your 'load-path'.
2.  Add the following code to your Emacs init file:

    (require 'talon-mode)


<a id="orgc02bf94"></a>

# Usage

Opening any file with the ".talon" extension will automatically enable
talon-mode.

