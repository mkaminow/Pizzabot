# Pizzabot (FP) 

Pizzabot is a cutting-edge tool in virtual pizza delivery that can be run from the command-line.

Pizzabot works by parsing a grid size and coordinates that it is given and then, in the order that they were inputted, checking that each pair of coordinates is valid and within range, then moving first along an E/W axis and then along the N/S axis, and finally dropping pizza before moving on to the next pair of coorindates. 

Invalid coordinates (or coordinates listed before the grid size) will not prevent pizzabot from delivering to valid coordinates in the same set.

### Functional Programming refactor

This is a functional programming refactor of Pizzabot. It makes use of Swift's higher-order functions in order to reduce the use of mutable properties which results functions without unintended side-effects and cleaner, more modular code. It also makes the code base easier to debug and write tests for.

## Build Instructions

You can execute Pizzabot already using the pre-build executable. 

Or

If you wish to archive and build yourself

1. Open Pizzabot.xcodeproj using XCode 8.x
2. Select Product->Archive
3. In the XCode Oranizer window that pops up choose Export and choose Save Build Products
4. The exececutable file will be in the directory you choose as ../Products/usr/local/bin/Pizzabot

## Usage

Run directly from the command line by calling Pizzabot followed by a string that includes a grid size and a set of coordinates.

```bash
$ ./Pizzabot "[gridSize] [setOfCoordinates]"
``

ex:
```bash
$ ./Pizzabot "5x5 (1, 3) (4, 4)"
``

## Solution

The example:
```bash
$ ./Pizzabot "5x5 (0, 0) (1, 3) (4, 4) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"
``
will produce the solution: DENNNDEEENDSSDDWWWWSDEEENDWNDEESSD


## Tests

To run tests open Pizzabot.xcodeproj in XCode 8.x and press cmd + u

## Next Steps

Take advantage of the modularity of functional programming by writing tests for each function instead of the program as a whole.
