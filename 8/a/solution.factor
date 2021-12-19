IN: advent8a
USING: kernel namespaces locals combinators prettyprint
       math math.parser math.bitwise math.order math.ranges math.statistics math.functions
       io io.files io.encodings.utf8 command-line
       sequences grouping splitting arrays sets assocs hashtables sorting sorting.extras
       ;

:: rrot ( x y z w -- y z w x ) y z w x ;

: parse-opts ( -- filename )
    command-line get ?first
;

: parse ( lines -- parsed )
    [ " " split { "|" } split ] map
;

: solve ( parsed -- answer )
    [ second ] map concat ! grab all the output values
    [ length { 2 3 4 7 } in? ] count
;

: run ( filename -- )
    utf8 file-lines               ! read file into sequence
    parse
    solve
    .
;

: main ( -- )
    parse-opts
    run
;

MAIN: main


