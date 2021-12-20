IN: advent9a
USING: kernel namespaces locals combinators prettyprint
       math math.parser math.bitwise math.order math.ranges math.statistics math.functions
       io io.files io.encodings.utf8 command-line strings formatting
       sequences grouping splitting arrays sets assocs assocs.extras hashtables sorting sorting.extras
       ;

: dbg ( x -- x ) dup . ;
:: rrot ( x y z w -- y z w x ) y z w x ;
: find-first ( ... seq quot: ( ... elt -- ... ? ) -- ... elt ) find [ drop ] dip ; inline

: parse-opts ( -- filename )
    command-line get ?first
;

: parse ( lines -- parsed )
    [
        [ "0" first - ] { } map-as
        { 9 } prepend ! put walls around rows
        { 9 } append
    ] map
    flip ! put walls around columns too
    [
        { 9 } prepend
        { 9 } append
    ] map
    flip
;

: matrix-lookup ( coords matrix -- value )
    over first swap nth
    [ second ] dip nth
;

:: get-surrounds ( coords matrix -- surrounds )
    coords first2 1 - 2array
    coords first2 [ 1 - ] dip 2array
    coords first2 1 + 2array
    coords first2 [ 1 + ] dip 2array
    4array
    { coords } prepend
    [ matrix matrix-lookup ] map
;

: local-minimum? ( surrounds -- ? )
    dup first [ rest ] dip [ > ] curry all?
;

:: find-minima ( matrix -- minima )
    matrix length 1 - [1..b)
    matrix first length 1 - [1..b)
    cartesian-product concat
    [ matrix get-surrounds ] map
    [ local-minimum? ] filter
    [ first ] map
;

: risk-level ( height -- risk-level )
    1 +
;

: solve ( parsed -- answer )
    find-minima
    [ risk-level ] map
    sum
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

