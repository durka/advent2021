IN: advent3b
USING: kernel namespaces locals combinators prettyprint
       math math.parser math.bitwise
       io io.files io.encodings.utf8 command-line
       sequences grouping splitting
       ;

: parse-opts ( -- filename )
    command-line get ?first
;

: bool>number ( bool -- num )
    [ 1 ] [ 0 ] if
;

:: rrot ( x y z w -- y z w x ) y z w x ;
: bitxnor ( x y -- z ) bitxor 1 bitxor ;

! find out whether 0 or 1 is the most popular bit at an index
:: bit-popularity ( idx numbers -- most-popular-bit-value )
    numbers [ idx bit? bool>number ] [ + ] map-reduce   ! count elements with the bit set
    numbers [ idx bit? not bool>number ] [ + ] map-reduce
    >= bool>number
;

:: rating* ( idx desired-bit-value numbers -- rating )
    SYMBOL: x
    idx numbers bit-popularity desired-bit-value bitxnor x set
    numbers [ idx bit? bool>number x get = ] filter
;

:: rating ( width idx desired-bit-value numbers -- rating )
    numbers length 1 =
    idx 0 < or ! spec doesn't say what to do if you get to the end and there's more than one left
        [ numbers first ]
        [
            idx desired-bit-value numbers rating*
            ! dup [ >bin ] map .
            width idx 1 - desired-bit-value rrot rating
        ]
        if
;

:: analyze ( width numbers -- oxygen-rating co2-rating )
    width dup 1 - 1 numbers rating
    width dup 1 - 0 numbers rating
;

: run ( filename -- )
    utf8 file-lines              ! read file into sequence
    dup first length swap        ! calculate bit width from first number
    [ bin> ] map                 ! parse all numbers
    analyze
    2dup * -rot                  ! power = gamma * epsilon
    "CO2 scrubber rating"       print     .
    "\noxygen generator rating" print     .
    "\nlife support rating"     print     .
;

: main ( -- )
    parse-opts
    run
;

MAIN: main


