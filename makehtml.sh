#!/bin/sh

# The MIT License
# 
# Copyright (c) 2023 rekcuFniarB <retratserif@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


## Print messages to stderr
errlog() {
    echo "$@" 1>&2
    
    if [ -n "$DISPLAY" -a "$(which kdialog)" ]; then
        ## If X session active and kdialog installed
        exec kdialog --title "$0" --msgbox "$@"
    fi
}

fn_info() {
    errlog "This util makes html files complete by adding <html>, <head> and <body> tags if content isn't wrapped into <body> tag.
If supplied file has .md extension then additional script is added into resulting html file for converting markdown to html.
Supplied html file will be overwritten by this script.
https://github.com/rekcuFniarB/HtmlBoilerplate

USAGE
    $0 file.html
    $0 file.md
"
    exit
}

fn_check_file() {
    local MSG
    MSG="$2"
    if [ -z "$MSG" ]; then
        MSG="File $1 not exists"
    fi
    if [ ! -f "$1" ]; then
        errlog "$MSG"
        exit 1
    fi
}

fn_is_img() {
    local NAME
    local ext
    NAME="$1"
    if [ -z "$NAME" ]; then
        return 1
    fi
    for ext in jpg jpeg png gif webp svg JPG JPEG PNG GIF WEBP SVG; do
        if [ _$NAME != _"${NAME%%.$ext}" ]; then
            echo -n "$NAME"
            return 0
        fi
    done
}

FILE="$1"

if [ -z "$FILE" -o "$FILE" = '-h' -o _"$FILE" = '--help' ]; then
    ## Showing help
    fn_info
    exit
fi

BASENAME="$(basename "$FILE")"
TITLE="${BASENAME%%.html}"

## Alt src: https://ipfs.io/ipfs/QmRSWamS6ccdqubPdgjYPpfCVLw7h1ccQpDvSTgizpNbo8/markdown-it-init.js
MDSCRIPTS="<script src=\"https://bafybeibocnnv53gvyse2wrn2pohbazdiyqqlq3cledoxgchjpoeger6g2m.ipfs.dweb.link/markdown-it-init.js\" type=\"text/javascript\"></script>
"

if [ "${FILE%%.md}" != "$FILE" ]; then
    ## Has .md extension
    ## We use https://github.com/markdown-it/markdown-it#readme for rendering to html
    fn_check_file "$FILE"
    CONTENT="$(cat "$FILE")"
    echo "<pre><code class=\"markdown\">
$CONTENT
    </code></pre>" > "$FILE.html"
    ## Running self on new html file
    exec "$0" "$FILE.html"
elif [ _"$TITLE" != _"$BASENAME" ]; then
    ## has .html extension
    touch "$FILE" # creating if not exists in case of we want empty template
    fn_check_file "$FILE" "Could not create $FILE"
    CONTENT="$(cat "$FILE")"
    ## If have no <body>
    if [ -z "$(echo -n "$CONTENT" | grep -i '<body>')" ]; then
        ## If have markdown code 
        if [ -n "$(echo -n "$CONTENT" | grep ' class="markdown"\| type="text/markdown"')" ]; then
            SCRIPTS="$MDSCRIPTS"
        fi
        
        DIR="$(dirname "$FILE")"
        export FILE
        
        ## Generating list of links and imgs from parent directory
        
        IMGS="$(ls "$DIR" | while read F; do
            FILE="$(basename "$FILE")"
            if [ _"$F" != _"$FILE" ]; then
                IMGNAME="$(fn_is_img "$F")"
                if [ -n "$IMGNAME" ]; then
                    ## Is img
                    echo "<figure>
                        <img src=\"$F\" alt=\"$IMGNAME\">
                        <figcaption><a href=\"$F\">$IMGNAME</a></figcaption>
                    </figure>"
                fi
            fi
        done)"
        
        LINKS="$(ls "$DIR" | while read F; do
            FILE="$(basename "$FILE")"
            if [ _"$F" != _"$FILE" ]; then
                IMGNAME="$(fn_is_img "$F")"
                if [ -z "$IMGNAME" ]; then
                    ## Is regular file
                    echo "<li><a href=\"$F\">$(basename "$F")</a></li>"
                fi
            fi
        done)"
        
        if [ -n "$LINKS" ]; then
            CONTENT="$CONTENT
            <section class=\"links\">
            <ul>
            $LINKS
            </ul>
            </section>"
        fi
        
        if [ -n "$IMGS" ]; then
            CONTENT="$CONTENT
            <section class=\"pictures\">
            $IMGS
            </section>"
        fi
        
        echo "<!DOCTYPE html>
<html>
  <head>
    <meta charset=\"UTF-8\">
    <title>$TITLE</title>
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/water.css/out/water.css\">
    <!-- Other css alternatives: https://css-tricks.com/no-class-css-frameworks/ -->
    <meta name=\"generator\" content=\"https://github.com/rekcuFniarB/HtmlBoilerplate#readme\">
  </head>
  <body>
    <main>
    $CONTENT
    </main>
    $SCRIPTS
  </body>
</html>" > "$FILE"
        errlog "Template done for $FILE"
    else
        errlog "File $FILE already processed."
    fi
fi



