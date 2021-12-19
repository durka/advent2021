IN: advent8b
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
    [ " " split { "|" } split ] map
;

:: solve-configuration' ( codex signals -- codex )
    ! - find 1 (only length-2) and 7 (only length-3)
    signals [ length 3 = ] find-first
    signals [ length 2 = ] find-first
    2dup
    diff ! deduce A from the segment in 7 but not 1
        "a" codex set-at
    intersect ! C and F are the other two segments in 7 (will narrow down later)
        "c" codex set-at

    ! - find 3 (length-5 containing 7)
    signals [ length 3 = ] find-first
    dup
    signals [ length 5 = ] filter
    [ [ dup ] dip subset? ] find-first ! find the one that contains 7
        [ drop ] dip
    swap diff ! remove 7 from 3; D and G are the other two segments (will narrow down later)
        "d" codex set-at

    ! - find 4 (only length-4)
    signals [ length 4 = ] find-first
    dup
    { "c" "d" } [ codex at ] map ! identify B by process of elimination
        concat diff
        "b" codex set-at
    "d" codex at ! narrow down D/G (only D is present in 4)
        2dup
        intersect
            "d" codex set-at
        swap diff
            "g" codex set-at

    ! - find 5 (length-5 containing B)
    signals [
        dup
        length 5 =
        swap
        "b" codex at swap subset?
        and
    ] find-first
    ! narrow down C/F (only F is present in 5)
    "c" codex at
        2dup
        intersect
            "f" codex set-at
        swap diff
            "c" codex set-at

    ! find E by process of elimination
    codex values concat
        "abcdefg" swap diff
        "e" codex set-at

    codex
;

: solve-configuration ( signals -- codex )
    H{ } clone ! clone so we use a distinct hash table every time
    swap
    solve-configuration'
;

: unscramble ( signals codex -- signals )
    assoc-invert swap
    [
        [ 1string over at ] { } map-as ! look up each signal in codex
        [ <=> ] sort ! put letters in standard order
        concat
    ] map
    swap drop
;

: decode ( signals -- number )
    { ! 0-9 patterns
        "abcefg"
        "cf"
        "acdeg"
        "acdfg"
        "bcdf"
        "abdfg"
        "abdefg"
        "acf"
        "abcdefg"
        "abcdfg"
    }
    swap [
        over index ! find corresponding number
        "0" first + ! number to char code
    ] map
    swap drop
    [ ] "" map-as string>number ! use atoi to get an integer
;

: solve ( parsed -- answer )
    [
        dup
        first solve-configuration
        [ second ] dip
        unscramble
        decode
    ] map
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

