#!/opt/homebrew/bin/bash

# This script has since depreciated its usage. It was incredibly slow updating
# the pdf, although that may have been a fault more of Preview rather than the
# script. This functionality is now implemented through a few bash functions and
# vim autocommands. See 'Pandoc Live Markdown Viewer" in bash/.bash_functions

# This script utilizes pandoc, entr, and skim (or other pdf/.html viewer) in
# order to create a live previewer for Markdown (.md) files.
# 
#   pandoc - command line file converter. in our script, we convert markdown to
#            pdf
#   entr - command line tool that checks when files are updated.
#   skim - (brew --cask) application, pdf viewer downloaded through homebrew

DEFAULT_APP="Preview"

MD_FILE=""
APP=""

# Check argument count and assign appropriate variables
case $# in
    1)  
        if [[ $1 == *.md ]]; then
            MD_FILE=$1
            APP=$DEFAULT_APP
        else
            echo "Error: If providing one argument, it should be a markdown file."
            exit 1
        fi
        ;;
    
    2)
        if [[ $1 == *.md ]]; then
            MD_FILE=$1
            APP=$2
        else
            echo "Error: First argument should be a markdown file and second an application name."
            exit 1
        fi
        ;;
    
    *)
        echo "Usage: $0 markdown-file-name [application-to-view-live]"
        exit 1
        ;;
esac

PDF_FILE="${MD_FILE%.*}.pdf"

# Start entr in the background to watch changes and recompile using pandoc
echo "$MD_FILE" | entr -d pandoc "$MD_FILE" -o "$PDF_FILE" &
ENTR_PID=$!
echo $ENTR_PID > /tmp/livepreview_pid.tmp

# Open the PDF with the specified viewer
open -a "$APP" "$PDF_FILE"

