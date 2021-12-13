IN: advent5a
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

! check if a line is horizontal or vertical
: axis-aligned? ( coords -- ? )
    [ first ] [ last ] bi           ! { x1 y1 } { x2 y2 }
    [ <=> ] 2map                    ! { x1<=>x2 y1<=> y2 }
    {
        { { +eq+ +lt+ } [ t ] }     ! vertical
        { { +eq+ +gt+ } [ t ] }     ! vertical
        { { +lt+ +eq+ } [ t ] }     ! horizontal
        { { +gt+ +eq+ } [ t ] }     ! horizontal
        [ drop f ]
    } case
;

: expand-line ( endpoints -- allpoints )
    flip
    [ first2 [a..b] >array ] map
    first2 cartesian-product concat
;

: run ( filename -- )
    utf8 file-lines               ! read file into sequence
    [ parse-line ] map            ! parse each line into pairs of coordinates
    [ axis-aligned? ] filter      ! keep only vertical/horizontal lines
    [ expand-line ] map           ! fill in all the points between endpoints
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


