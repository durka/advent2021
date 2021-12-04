IN: advent1b
USING: kernel namespaces combinators prettyprint math math.parser
       io io.files io.encodings.utf8 command-line
       sequences grouping splitting
       ;

: parse-opts ( -- filename )
    command-line get ?first
;

:: interpret ( prev_coords command -- next_coords )
    ! split into command and number
    command " " split

    ! dispatch on the command (keep both on stack)
    dup first
    {
        { "forward" [
            ! this is the complicated one

            ! parse number
            last string>number
            dup ! save copy of number

            ! horiz += X
            prev_coords first +
            prev_coords swap over set-first
            swap ! ( copied_number coords_with_added_horiz -- coords_with_added_horiz copied_number )

            ! depth += aim*X
            prev_coords last *
            1 prev_coords nth +
            over 1 swap set-nth
        ] }
        { "up" [
            last string>number

            ! depth -= X
            prev_coords last swap -
            prev_coords swap over set-last
        ] }
        { "down" [
            last string>number

            ! depth += X
            prev_coords last +
            prev_coords swap over set-last
        ] }
    } case
    ! dup .
;

: run ( filename -- )
    utf8 file-lines              ! read file into sequence
    { 0 0 0 } [ interpret ] reduce
    "\nfinal coords" print  dup .
    "\nproduct " print      dup first swap 1 swap nth * .
;

: main ( -- )
    parse-opts
    run
;

MAIN: main


