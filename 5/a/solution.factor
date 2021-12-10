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

: axis-aligned? ( coords -- ? )
    [ first ] [ last ] bi
    [ <=> ] 2map
    {
        { { +eq+ +lt+ } [ t ] }
        { { +eq+ +gt+ } [ t ] }
        { { +lt+ +eq+ } [ t ] }
        { { +gt+ +eq+ } [ t ] }
        [ drop f ]
    } case
;

: sort-coords ( coords -- coords )
    [ first ] [ last ] bi 2dup
    [ <=> ] 2map
    {
        { { +eq+ +lt+ } [ ] }
        { { +eq+ +gt+ } [ swap ] }
        { { +lt+ +eq+ } [ ] }
        { { +gt+ +eq+ } [ swap ] }
    } case
    make-seq
;

: expand-line ( endpoints -- allpoints )
    flip
    [ first2 [a..b] >array ] map
    first2 cartesian-product
;

: run ( filename -- )
    utf8 file-lines               ! read file into sequence
    [ parse-line ] map            ! parse each line into pairs of coordinates
    [ axis-aligned? ] filter      ! keep only vertical/horizontal lines
    [
        sort-coords               ! move the endpoint with a lower x/y coord to the beginning
        expand-line               ! fill in all the points between endpoints
    ] map
    concat concat                 ! flatten to a simple list of points
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


