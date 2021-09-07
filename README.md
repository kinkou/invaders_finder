# Development assignment
The presented solution is by no means optimal in terms of performance or memory consumption. I believe there are clever solutions to the problem of the space invader detection, however I will give my thoughts on a possible alternative approach.

## How to run
```
bundle
ruby run.rb
```

## The chosen approach
Since both the radar data sample and the space invader pattern are made up of lines of text, we can use [string similarity algorithms](https://medium.com/@appaloosastore/string-similarity-algorithms-compared-3f7b4d12f0ff
) to tell how likely that it's actually an invader within a certain region of a radar sample. To do that, we can compare the sample and the pattern line by line and then count the average:

```
Sample          Pattern         Similarity
--oo----o-- <=> --o-----o-- #=> 1.0
-------o--- <=> ---o---o--- #=> 1.0
o--oooooo-- <=> --ooooooo-- #=> 0.5
-oo--oo--o- <=> -oo-ooo-oo- #=> 0.5
oo-oooooooo <=> ooooooooooo #=> 1.0
o-ooooooo-o <=> o-ooooooo-o #=> 1.0
oo-o----o-o <=> o-o-----o-o #=> 0.5
--ooo-oo--o <=> ---oo-oo--- #=> 0.5

Average: 0.75 (using Damerau-Levenshtein)
```

## A possible alternative approach
Since the radar sample and the pattern only use two symbols, `-` and `o`, they can be converted into binary form. We can then use negation and conjunction to 'cancel out' the 1s (== `o`s) of the pattern in the sample, effectively getting the 'difference' between the both. The smaller the number of 1s in the result, the higher the likelihood that the sample contains an invader (blur your vision):

```
Sample        Negated pattern   Result, similarity
00110000100 & 11011111011  #=>  00010000000, 1.0
00000001000 & 11101110111  #=>  00000000000, 1.0
10011111100 & 11000000011  #=>  10000000000, 1.0
01100110010 & 10010001001  #=>  00000000000, 1.0
11011111111 & 00000000000  #=>  00000000000, 1.0
10111111101 & 01000000010  #=>  00000000000, 1.0
11010000101 & 01011111010  #=>  01010000000, 0.5
00111011001 & 11100100111  #=>  00100000001, 0.5

Average: ~0.88
```

This approach might be better performance- and memory-wise, but since in Ruby it's more convenient to work with strings and arrays, we'll stick with the first one.

## Scanning the scene
To detect invaders we will guilelessly move a frame of the size of an invader pattern left to right, top to bottom, one step at a time, taking a subsample at the current position and comparing it with the current pattern:

```
  0 1234 567
0 - -o-- --o    Subsample     Original
   ┌────┐       at (1, 1)     sample      Similarity  Threshold
1 -│-o--│-o- => -o--      <=> -oo-     => 0.5    <=>  0.75      => Not an
2 -│--o-│--o    --o-          -oo-                                 invader,
   └────┘                                                          probably
3 - o--- -o-
4 - --o- o--
```

If the resulting similarity is above a certain threshold, we will assume that we have detected an invader and print out the coordinates of the subsample within the radar sample data, the similarity index and the subsample 'image', for the radar operator to decide whether he/she should shoot lasers at it or not.

## Dealing with the edge cases
When we take a subsample where only a part of an invader is seen, we need to 'cut off' a part of an invader pattern so that the comparison would be made between the corresponding strings:

```
Subsample      Adjusted pattern
--oo--     =>  --oo--
-oo-o-         -oooo-
o-o-oo         oooooo
--------------------- edge of the radar sample
```

To avoid complex adjustments to the scanning frame, we can simply add a padding around our radar sample filled with a symbol that is not used in both the sample and the pattern, for instance `x`. We'll set the width of the padding on each side of the sample to ½ of the pattern's width, and the height to ½ of the pattern's height. In this case, when we'll do the subsampling, we will capture at least ½ of the potential 'hiding' invader:

```
Subsample  Pattern
--oo-x     --oo--
-oo-ox     -oooo-
o-o-ox     oooooo
xxxxxx      o--o
xxxxxx     o----o
```

Since the size of the subsampling frame is now equal to the size of the pattern, if we delete the `x`s in the subsample _and_ characters in the pattern at the same positions, we will have the versions of both that can be correctly compared:

```
Subsample    Pattern
--oo-  <=>  --oo-
-oo-o  <=>  -oooo
o-o-o  <=>  ooooo
```

It probably doesn't make sense to compare sections that are less than ¼ of a pattern area since the resolution of the sample data is quite low already and we might get a lot of false matches. This is the reason why we should pad the radar sample to no more than ½ of a pattern's width/height.

## How the app is designed
The main building block of the app is `InvadersFinder::TextBlock`. It wraps a block of text (a radar sample, a subsample of it, or a pattern) in a form of an array of strings and does basic operations on it, like telling dimensions, taking a subsample at a certain position, padding it with `x`s, unpadding it (removing the `x`s), intersecting itself with another text block (see 'Dealing with the edge cases').

`InvadersFinder::Comparator` takes two `TextBlock`s and returns a value representing their similarity, using an object that implements a `InvadersFinder::SimilarityAlgorithms::Base` interface. This way we can use several similarity algorithms to see which works best (so far Levenshtein has shown better results than White Similarity).

`InvadersFinder::Scanner` takes a radar sample and a pattern that we're searching for, both in the form of `InvadersFinder::TextBlock` objects, and a similarity algorithm object, and scans the sample, returning an `InvadersFinder::Match` object if the similarity was greater or equal to the algorithm's threshold.

`InvadersFinder::Scanner` will also use an `InvadersFinder::ScannerSetup` object to find out how many scanning steps to make, how large the scanning frame should be, etc.

`InvadersFinder::Match` knows everything about the matching result and can present itself using the current app-wide logger object (currently just `InvadersFinder::ScreenLogger`).

Finally, the `InvadersFinder::Main` wraps it all up, loading the dependencies, starting a scan cycle for each of the the two available patterns (the Crab and the Squid), and logging the results.

## Noticed imperfections
These are the imperfections in my code that I noticed but decided to leave as is:

- Some tests use the same sample data that the app uses as an input. In case this data gets replaced, the tests will break. Since this is a toy app I think it's ok.
- Some Rubocop's warnings, mostly `Metrics/AbcSize` and `Layout/LineLength` were silenced and the code left unchanged for the sake of expressiveness and better readability.

## Acknowledgements
I would like to thank the authors of the assignment for approaching the problem of coding test assignments creatively, it was a pure joy working on the solution.