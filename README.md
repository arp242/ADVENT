This "Colossal Cave Adventure", or just "Adventure" for short, I wanted to have
a working version that is as close to the original source code as possible.

https://en.wikipedia.org/wiki/Colossal_Cave_Adventure

Almost none of this is my work, but based on Dan Nelson's work that I got at:
https://www.ifarchive.org/indexes/if-archive/games/source/

I had to make a few small changes to the Fortran code to make it compile with
gfortran 13.2, I added a Makefile, and changed the advent.bin location from
/etc/advent.bin to ./advent.bin, which seems like a slightly more sensible
default.

Type `make` to compile. Default is to make a statically linked binary; use `make
STATIC=` to disable.

Dan Nelson's README follows, with a few small modifications.


ADVENTURE PORT
==============
The objective of this port was to be able to play the original colossal cave
adventure in its true original form, with no omissions, additions, or
modernizations. I started with the PDP-10 FORTRAN source code by Crowther and
Woods, and ported it to standard UNIX FORTRAN 77. I've only tested it with g77
on Linux and FreeBSD, but it's pretty much straight-ahead ANSI FORTRAN 77, so it
ought to work with other compilers and systems without much trouble.

I did the porting work over a few evenings and weekends in January 2016.


SETUP
-----
In its original form the program was designed to work with the snapshot feature
of the PDP-10. An installation would initialize it once with the text data file,
then save a core image, which included the initialized states of all the
program's variables. The data file could then be removed or made inaccessible,
so as to discourage cheating, and the core image could simply be run.

This port works the same way, except that the game's state is saved to a binary
file instead of a core image. Thus, the state and the code are kept in two
separate files instead of one.

After compiling the program, on first running it, the file 'advent.dat' must be
present in the current directory. The program will initialize from this file,
then save its state to ./advent.bin. Then it will pause, and you can either
terminate it or go on and play the game. I recommend doing that first run as
root, so that it can write to ./advent.bin, and then terminating after it
initializes. From that point on, advent.dat is no longer required, and
./advent.bin need only be readable unless you are going to change the game
options in magic mode, which is explained further below. If you would like to
put the binary file somewhere other than in the current directory, simply change
the constant BINFIL in the code before compiling.


MAGIC MODE
----------
The cave hours and a few other options can be changed if you are a wizard. If
you'd like to do this, run the program as a user with write access to
advent.bin, and then issue `magic mode` as your first command (*after* "would
you like instructions"). After that, the game will present you with a series of
challenges to determine whether you are a wizard. It will prompt you for the
magic word, which by default is 'dwarf', though it can be changed via magic mode
once you get in the first time. If you respond with the correct magic word, it
will ask you if you know what IT thinks the magic word is. You should answer
"no" to this question, which will cause the game to print a random magic word.
To finish authenticating as a wizard, you must respond with the correct answer
to this random magic word. The correct answer is based on the random magic word,
the current time, and a magic number. I've included a little program called
'wiz' to calculate it. Run 'wiz', enter the random magic word from the game, and
it will print out the proper response. Go back to the game and enter that
response, and it will authenticate you as a wizard. Note that if you change the
magic number via wizard mode, you must also change it in the source code for wiz
(wiz.for) and recompile, or you will not get correct results.

Only a user with write access to advent.bin can permanently change the game
options, but you still want wizard access to be secure, because wizards can do
other things to override normal game restrictions. The two mechanisms for
securing wizard access are changing the magic word and the magic number. Of
course both of these values are stored without encryption in advent.bin, so it's
not true security, but it ought to be enough to keep honest users honest.


SUSPENDING AND RESTORING
------------------------
In the original game, upon suspending, the game would simply exit back to the
command level and allow the user to save a core image that preserved the state
of their game. In this port I changed the suspend operation so that it now
prompts you for a path to a binary file, in which it saves the state of your
game. As in the original, when you suspend a game, the program terminates, and
you cannot play that game anymore for at least 90 minutes. (This time is
configurable somewhat via magic mode.) To resume a game, I added a new "resume"
command, which prompts for the location of the file where you saved your game.
It then loads the state from that file and starts exactly as if it were starting
from a core image. This means that if it hasn't been long enough since you
saved, it will tell you so and terminate.


PORTING NOTES
-------------
I tried to add good comments as I went along, but I also strove to leave the
original comments unscathed, so some of those are now incorrect. Most of the
work involved was in three basic areas: (1) using CHARACTER types instead of
packing characters into integer types, (2) eliminating use of non-portable
bitwise logical operators and I/O functionality, and (3) dealing with the fact
that UNIX architectures don't have the PDP-10's snapshot feature. Where I
changed code, I tried to make it comply with the ANSI FORTRAN 77 spec. One place
I couldn't do that was in the date/time routine. There is no standard way to get
the date and time, but the intrinsics I used are probably common in the world of
UNIX FORTRAN. Another place the code could not be 100% standard compliant was in
the assumption that if a READ statement requires more characters than are
supplied by a record, the remainder will be read as blanks. This is evidently a
widespread assumption, however, even though it is strictly forbidden by the ANSI
spec.

The original textual data file was tab-delimited, but standard FORTRAN does not
know how to read delimited fields. It wants fixed-sized fields. So I wrote a
small program called datcvt to convert it. This program is supplied along with
this port. Beyond that, I added only the necessary vocabulary entries for the
new "restore" command.

I'm supplying the original files I started with for reference, with .orig
suffixes. If you're interested in exactly what I changed, try diffing against
the originals, but make sure you ignore whitespace, because I converted tabs to
spaces throughout, which will otherwise make the diffs very noisy.

Cheers!

Dan Nelson
Feb 2, 2016
