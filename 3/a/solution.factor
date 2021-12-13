IN: advent3a
USING: kernel namespaces combinators prettyprint
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

! find out whether 0 or 1 is the most popular bit at an index
:: bit-popularity ( idx numbers -- most-popular-bit-value )
    numbers [ idx bit? bool>number ] [ + ] map-reduce   ! count elements with the bit set
    numbers length 2/ <                                 ! less than half?
    bool>number
;

:: analyze ( width numbers -- epsilon gamma )
    width <iota> [ numbers bit-popularity ] map
    0 [ swap zero? [ set-bit ] [ clear-bit ] if ] reduce-index
    dup width on-bits bitxor ! gamma = ~epsilon
;

: run ( filename -- )
    utf8 file-lines              ! read file into sequence
    dup first length swap        ! calculate bit width from first number
    [ bin> ] map                 ! parse all numbers
    analyze
    2dup * -rot                  ! power = gamma * epsilon
    "\ngamma rate" print            .b
    "\nepsilon rate" print          .b
    "\npower consumption" print     .
;

: main ( -- )
    parse-opts
    run
;

MAIN: main


