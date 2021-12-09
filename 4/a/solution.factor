IN: advent1b
USING: kernel namespaces locals combinators prettyprint
       math math.parser math.bitwise
       io io.files io.encodings.utf8 command-line
       sequences grouping splitting
       ;

: parse-opts ( -- filename )
    command-line get ?first
;

:: rrot ( x y z w -- y z w x ) y z w x ;

: parse-draws ( draws-line -- draws )
    "," split
    [ string>number ] map
;

: parse-board-row ( board-row-line -- board-row )
    " " split harvest
    [ string>number ] map
;

: parse-board ( board-lines -- board )
    [ parse-board-row ] map
;

: mark-number ( draw number -- number )
    dup rot           ! preserve the number       ( number draw number )
    =                 ! draw == number
    [ drop t ] when   ! change to t if it matches
;

:: mark-number-in-row ( draw row -- row )
    row [ draw swap mark-number ] map
;

:: mark-number-on-board ( draw board -- board )
    board [ draw swap mark-number-in-row ] map
;

:: draw-number ( draw boards -- boards )
    boards [ draw swap mark-number-on-board ] map
;

: winning-row? ( row -- ? )
    [ t = ] all?
;

! there must be a builtin way to do this...
:: make-seq ( a b -- seq )
    { a b }
;

: diagonals ( rows -- diagonals )
    dup
    [ swap nth ] map-index
    swap
    [ swap <reversed> nth ] map-index
    make-seq
;

: winning-board? ( board -- ? )
    dup [ winning-row? ] any? swap
    dup flip [ winning-row? ] any? swap
    drop f ! whaddayamean diagonals don't count??? diagonals [ winning-row? ] any?
    or or
;

: game-over? ( boards -- ? )
    [ winning-board? ] any?
;

: finish-bingo ( last-draw boards -- winner score )
    [ winning-board? ] find ! find winning board
    swap drop dup           ! toss out index from find, copy board
    concat                  ! flatten rows
    [ t = ] reject          ! remove marked entries
    sum                     ! sum remaining entries
    swapd *                 ! multiply by last draw
;

: run-bingo ( draws boards -- winner score )
    ! perform draw (we assume there is a draw to do, if nobody has won yet)
    swap dup first dup [ rest ] 2dip rrot ! split off first draw    ( draws-rest draws-first draws-first boards )
    draw-number                                                   ! ( draws-rest draws-first boards* )

    ! win condition
    dup game-over?                                                ! ( draws-rest draws-first boards* ? )

    ! recurse
    [ nipd finish-bingo ] [ nip run-bingo ] if
;

: run ( filename -- )
    utf8 file-lines               ! read file into sequence
    { "" } split                  ! split into sections on blank lines
    dup first first parse-draws   ! first element is the number draws
    swap rest [ parse-board ] map ! rest of the elements are boards
    run-bingo . .
;

: main ( -- )
    parse-opts
    run
;

MAIN: main


