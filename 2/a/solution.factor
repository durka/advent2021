IN: advent2a
USING: kernel namespaces combinators prettyprint math math.parser
       io io.files io.encodings.utf8 command-line
       sequences grouping splitting
       ;

: parse-opts ( -- filename )
    command-line get ?first
;

:: interpret ( prev_coords command -- next_coords )
    command " " split
    dup first
    {
        { "forward" [
            last string>number
            prev_coords first +
            prev_coords swap over set-first
        ] }
        { "up" [
            last string>number
            prev_coords last swap -
            prev_coords swap over set-last
        ] }
        { "down" [
            last string>number
            prev_coords last +
            prev_coords swap over set-last
        ] }
    } case
;

: run ( filename -- )
    utf8 file-lines              ! read file into sequence
    { 0 0 } [ interpret ] reduce
    dup .
    1 [ * ] reduce .
;

: main ( -- )
    parse-opts
    run
;

MAIN: main


