IN: advent1a
USING: kernel namespaces sequences prettyprint math math.parser
       io io.files io.encodings.utf8 command-line
       ;

: parse-opts ( -- filename )
    command-line get ?first
;

! surely this is builtin...
: bool>number ( bool -- num )
    [ 1 ] [ 0 ] if
;

: run ( filename -- answer )
    utf8 file-lines              ! read file into sequence
    [ string>number ] map        ! convert to integers
    dup                          ! copy the whole sequence
    dup first prefix             ! shift the copy to the right
    [ > bool>number ] [ + ] 2map-reduce ! compare and sum
;

: main ( -- )
    parse-opts
    run
    .
;

MAIN: main

