IN: advent9b
USING: kernel namespaces locals combinators prettyprint
       math math.parser math.bitwise math.order math.ranges math.statistics math.functions
       io io.files io.encodings.utf8 command-line strings formatting
       sequences grouping splitting arrays sets assocs assocs.extras hashtables sorting sorting.extras dlists deques
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

:: matrix-set! ( value coords matrix -- )
    coords first matrix nth
    dup value coords second rot set-nth
    coords first matrix set-nth
;

: matrix-size ( matrix -- height width )
    dup length
    swap first length
;

: clear-basins ( matrix -- matrix )
    [
        [ 9 = not ] map
    ] map
;

:: get-surrounds ( coords -- surrounds )
    coords first2 1 - 2array
    coords first2 [ 1 - ] dip 2array
    coords first2 1 + 2array
    coords first2 [ 1 + ] dip 2array
    4array
;

:: assign-component! ( label coords queue components matrix -- )
    ! set in matrix
    label coords matrix matrix-set!

    ! add to component list
    label components at V{ } clone or
        coords over push
        label components set-at

    ! push to queue
    coords queue push-front
;

! https://en.wikipedia.org/wiki/Connected-component_labeling#One_component_at_a_time 
:: connected-components' ( queue components matrix -- components )
    matrix matrix-size
        [0..b)
        swap [0..b)
        swap cartesian-product concat
        [| coords label |
            ! If this pixel is a foreground pixel and it is not already labelled,
            coords matrix matrix-lookup t =
                [
                    ! give it the current label and add it as the first element in a queue,
                    label coords queue components matrix assign-component!
                    ! then go to (3).

                    queue [
                        ! Pop out an element from the queue, and look at its neighbours (based on any type of connectivity)
                        get-surrounds
                        [| coords |
                            ! If a neighbour is a foreground pixel and is not already labelled,
                            coords matrix matrix-lookup t =
                            [
                                ! give it the current label and add it to the queue.
                                label coords queue components matrix assign-component!
                            ] when
                        ] each
                    ] slurp-deque ! Repeat (3) until there are no more elements in the queue.
                ] when ! If it is a background pixel or it was already labelled, then repeat (2) for the next pixel in the image.
        ] each-index
    components values
;

: connected-components ( matrix -- components )
    [ <dlist> H{ } ] dip connected-components'
;

: solve ( parsed -- answer )
    clear-basins            ! convert to binary image
    connected-components    ! find basins
    [ length ] map          ! measure basin sizes
    [ <=> ] sort reverse    ! in decreasing order of size
    first3 * *              ! multiply biggest three
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

