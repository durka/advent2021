IN: advent1b
USING: kernel namespaces prettyprint math math.parser
       io io.files io.encodings.utf8 command-line
       sequences grouping
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
    3 clump                      ! make seq of sliding windows
    [ 0 [ + ] reduce ] map       ! sum each window
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


