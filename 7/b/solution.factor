IN: advent7b
USING: kernel namespaces locals combinators prettyprint
       math math.parser math.bitwise math.order math.ranges math.statistics math.functions
       io io.files io.encodings.utf8 command-line
       sequences grouping splitting arrays sets assocs hashtables sorting sorting.extras
       ;

:: rrot ( x y z w -- y z w x ) y z w x ;

: sum1n ( n -- sum ) dup 1 + * 2 / ;

: parse-opts ( -- filename )
    command-line get ?first
;

: parse ( line -- positions )
    first                         ! there's only one line
    "," split [ string>number ] map
;

: check-pos ( positions position -- fuel-cost )
    swap [ over - abs sum1n ] map sum  ! total fuel cost to move all submarines
    [ drop ] dip
;

: solve ( positions -- fuel-cost )
    dup minmax [a..b] [ [ dup ] dip check-pos ] map ! brute force try all positions
    0 kth-smallest ! sort and take the one with min fuel
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


