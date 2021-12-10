IN: advent1b
USING: kernel namespaces locals combinators prettyprint
       math math.parser math.bitwise math.order math.ranges
       io io.files io.encodings.utf8 command-line
       sequences grouping splitting arrays sets
       ;

: parse-opts ( -- filename )
    command-line get ?first
;

:: rrot ( x y z w -- y z w x ) y z w x ;
:: make-seq ( a b -- seq ) { a b } ;

: split-endpoints ( line -- x1y1-x2y2 )
    " -> " split1 make-seq
;

: split-coords ( xy-str -- coord )
    "," split
    [ string>number ] map
;

: parse-line ( line -- coords )
    split-endpoints
    [ split-coords ] map
;

: expand-aa-line ( endpoints -- allpoints )
    flip                                ! { { x1 x2 } { y1 y2 } }
    [ first2 [a..b] >array ] map        ! { { x1..x2 } { y1..y2 } } one is a single elem seq, the other is a range
    first2 cartesian-product concat     ! { { x1 y1 }..{ x2 y2 } }
;

: expand-diag-line ( endpoints -- allpoints )
    flip
    [ first2 [a..b] >array ] map
    flip
;

: diagonal? ( endpoints -- ? )
    first2 [ = ] 2map
    first2 or not
;

: expand-line ( endpoints -- allpoints )
    dup diagonal? [ expand-diag-line ] [ expand-aa-line ] if
;

: run ( filename -- )
    utf8 file-lines               ! read file into sequence
    [
        parse-line            ! parse each line into pairs of coordinates
        expand-line           ! fill in all the points between endpoints
    ] map
    concat                        ! flatten to a simple list of points
    duplicates                    ! keep only points that appear more than once
    members                       ! remove the duplicate duplicates
    length                        ! count unique duplicates
    .
;

: main ( -- )
    parse-opts
    run
;

MAIN: main


