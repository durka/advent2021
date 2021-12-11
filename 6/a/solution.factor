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

: parse-fish ( line -- fishes )
    "," split
    [ string>number ] map
;

: breed-one-fish ( fish -- fishes )
    dup 0 =
        [ drop { 6 8 } ]
        [ 1 - 1array ]
        if
;

: breed-fish ( fishes -- fishes )
    [ breed-one-fish ] map        ! breed each fish (becomes list including original fish and any children)
    concat                        ! flatten fish lists
;

: run ( filename -- )
    utf8 file-lines               ! read file into sequence
    first                         ! there's only one line
    parse-fish
    80 [ breed-fish ] times
    length .
;

: main ( -- )
    parse-opts
    run
;

MAIN: main


