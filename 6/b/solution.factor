IN: advent1b
USING: kernel namespaces locals combinators prettyprint
       math math.parser math.bitwise math.order math.ranges
       io io.files io.encodings.utf8 command-line
       sequences grouping splitting arrays sets assocs hashtables
       ;

: parse-opts ( -- filename )
    command-line get ?first
;

:: rrot ( x y z w -- y z w x ) y z w x ;

! count the number of each element in a seq
: counts ( seq -- freqlist )
    dup
    members dup -rot                        ! get unique elements
    [| elem | dup [ elem = ] count ] map    ! count frequencies in original seq
    swap drop zip                           ! turn into assoc
    >hashtable
;

: parse-fish ( line -- fishes )
    "," split
    [ string>number ] map
    counts
;

: breed-fish ( fishes -- fishes )
    [| key val | key 0 = ] assoc-partition  ! split out the zero entry

    [| key val |            ! for the nonzero entries, just decrement the key
        key 1 -
        val
    ] assoc-map
    
    swap

    0 of                    ! for zero, add that number of fish to the 6/8 entries (if they exist)
    [
        2dup 6 rot at+
        over 8 swap at+
    ] when*
;

: run ( filename -- )
    utf8 file-lines               ! read file into sequence
    first                         ! there's only one line
    parse-fish                    ! make initial hashtable
    256 [ breed-fish ] times      ! let's go!
    values sum .                  ! output total fish remaining
;

: main ( -- )
    parse-opts
    run
;

MAIN: main


