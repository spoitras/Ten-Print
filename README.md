Ten Print
=========

Variant of 10 PRINT CHR$(205.5+RND(1));:GOTO 10

Inspired by the book [10 PRINT CHR$(205.5+RND(1));:GOTO 10](http://10print.org/)
tenprint-page.asm outputs an entire screen at a time, instead of line
by line. The refresh rate can be set in seconds by adjusting the
delay variable (default = 0.5 second).

tenprint-col.asm outputs column by column, instead of line
by line. The refresh rate can be set in seconds by adjusting the
delay variable (default = 0.25 second).
