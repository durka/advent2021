IN: advent7a
USING: kernel namespaces locals combinators prettyprint
       math math.parser math.bitwise math.order math.ranges math.statistics math.functions
       io io.files io.encodings.utf8 command-line
       sequences grouping splitting arrays sets assocs hashtables
       ;

:: rrot ( x y z w -- y z w x ) y z w x ;

: parse-opts ( -- filename )
    command-line get ?first
;

: parse ( line -- positions )
    first                         ! there's only one line
    "," split [ string>number ] map
;

: solve ( positions -- fuel-cost )
    dup median round swap         ! find most economical gathering place
    [ over - abs ] map sum        ! total fuel cost to move all submarines
    [ drop ] dip
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


