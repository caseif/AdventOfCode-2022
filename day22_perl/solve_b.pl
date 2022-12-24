#!/usr/bin/env perl

use warnings FATAL => 'all';
use strict;

use List::Util qw(first);

my $CHAR_EMPTY = ' ';
my $CHAR_SPACE = '.';
my $CHAR_WALL = '#';

my $TYPE_EMPTY = 0;
my $TYPE_SPACE = 1;
my $TYPE_WALL = 2;

my $DIR_RIGHT = 'R';
my $DIR_LEFT = 'L';

my $FACING_RIGHT = 0;
my $FACING_DOWN = 1;
my $FACING_LEFT = 2;
my $FACING_UP = 3;

my $FACE_UP = 0;
my $FACE_DOWN = 1;
my $FACE_LEFT = 2;
my $FACE_RIGHT = 3;
my $FACE_FRONT = 4;
my $FACE_BACK = 5;

my $EDGE_RIGHT = 0;
my $EDGE_BOTTOM = 1;
my $EDGE_LEFT = 2;
my $EDGE_TOP = 3;

my $FACE_SIDE_LEN = 50;

my $ROTATE_NONE = 0;
my $ROTATE_CW = 1;
my $ROTATE_180 = 2;
my $ROTATE_CCW = 3;

my @grid = ();
my @dirs = ();

open my $info, 'input.txt' or die 'Failed to open file';
my $i = 1;
my $isMapComplete = 0;
my $maxLen = 0;
while (my $line = <$info>) {
    if ($line eq "\n") {
        $isMapComplete = 1;
        next;
    }

    $line =~ s/\n$//;

    if ($isMapComplete) {
        $line =~ s/L/ L /g;
        $line =~ s/R/ R /g;
        $line =~ s/^ //;
        $line =~ s/ $//;
        @dirs = split(' ', $line);
    } else {
        if (length($line) > $maxLen) {
            $maxLen = length($line);
        }
        @grid[$i] = "$CHAR_EMPTY$line$CHAR_EMPTY";
    }

    $i++;
}
close $info;

$grid[0] = $CHAR_EMPTY x ($maxLen + 2);
$grid[scalar(@grid)] = $CHAR_EMPTY x ($maxLen + 2);

my $curX = index($grid[1], $CHAR_SPACE);
my $curY = 1;
my $facingDir = $FACING_RIGHT;

foreach (@dirs) {
    if ($_ eq $DIR_RIGHT) {
        $facingDir = ($facingDir + 1) % 4;
    } elsif ($_ eq $DIR_LEFT) {
        # easier to deal with if we treat it as 3 right turns
        # so we don't have to worry about negatives
        $facingDir = ($facingDir + 3) % 4;
    } else {
        my $paces = int($_);
        for (1..$paces) {
            my $newX = $curX;
            my $newY = $curY;
            if ($facingDir == $FACING_RIGHT) {
                $newX += 1;
            } elsif ($facingDir == $FACING_LEFT) {
                $newX -= 1;
            } elsif ($facingDir == $FACING_DOWN) {
                $newY += 1;
            } elsif ($facingDir == $FACING_UP) {
                $newY -= 1;
            }

            my $newRow = $grid[$newY];

            my $rotDelta = $ROTATE_NONE;

            if ($newX >= length($newRow) || substr($newRow, $newX, 1) eq $CHAR_EMPTY) {
                use integer;

                my $curFace;

                my $faceX = ($curX - 1) / $FACE_SIDE_LEN;
                my $faceY = ($curY - 1) / $FACE_SIDE_LEN;
                if ($faceX == 0) {
                    if ($faceY == 2) {
                        $curFace = $FACE_LEFT;
                    } elsif ($faceY == 3) {
                        $curFace = $FACE_BACK;
                    }
                } elsif ($faceX == 1) {
                    if ($faceY == 0) {
                        $curFace = $FACE_UP;
                    } elsif ($faceY == 1) {
                        $curFace = $FACE_FRONT;
                    } elsif ($faceY == 2) {
                        $curFace = $FACE_DOWN;
                    }
                } elsif ($faceX == 2) {
                    if ($faceY == 0) {
                        $curFace = $FACE_RIGHT;
                    }
                }

                my $destFace;
                my $destEdge;

                if ($curFace == $FACE_UP) {
                    if ($facingDir == $FACING_LEFT) {
                        $destFace = $FACE_LEFT;
                        $destEdge = $EDGE_LEFT;
                        $rotDelta = $ROTATE_180;
                    } elsif ($facingDir == $FACING_UP) {
                        $destFace = $FACE_BACK;
                        $destEdge = $EDGE_LEFT;
                        $rotDelta = $ROTATE_CW;
                    }
                } elsif ($curFace == $FACE_RIGHT) {
                    if ($facingDir == $FACING_RIGHT) {
                        $destFace = $FACE_DOWN;
                        $destEdge = $EDGE_RIGHT;
                        $rotDelta = $ROTATE_180;
                    } elsif ($facingDir == $FACING_UP) {
                        $destFace = $FACE_BACK;
                        $destEdge = $EDGE_BOTTOM;
                        $rotDelta = $ROTATE_NONE;
                    } elsif ($facingDir == $FACING_DOWN) {
                        $destFace = $FACE_FRONT;
                        $destEdge = $EDGE_RIGHT;
                        $rotDelta = $ROTATE_CW;
                    }
                } elsif ($curFace == $FACE_FRONT) {
                    if ($facingDir == $FACING_LEFT) {
                        $destFace = $FACE_LEFT;
                        $destEdge = $EDGE_TOP;
                        $rotDelta = $ROTATE_CCW;
                    } elsif ($facingDir == $FACING_RIGHT) {
                        $destFace = $FACE_RIGHT;
                        $destEdge = $EDGE_BOTTOM;
                        $rotDelta = $ROTATE_CCW;
                    }
                } elsif ($curFace == $FACE_LEFT) {
                    if ($facingDir == $FACING_LEFT) {
                        $destFace = $FACE_UP;
                        $destEdge = $EDGE_LEFT;
                        $rotDelta = $ROTATE_180;
                    } elsif ($facingDir == $FACING_UP) {
                        $destFace = $FACE_FRONT;
                        $destEdge = $EDGE_LEFT;
                        $rotDelta = $ROTATE_CW;
                    }
                } elsif ($curFace == $FACE_DOWN) {
                    if ($facingDir == $FACING_RIGHT) {
                        $destFace = $FACE_RIGHT;
                        $destEdge = $EDGE_RIGHT;
                        $rotDelta = $ROTATE_180;
                    } elsif ($facingDir == $FACING_DOWN) {
                        $destFace = $FACE_BACK;
                        $destEdge = $EDGE_RIGHT;
                        $rotDelta = $ROTATE_CW;
                    }
                } elsif ($curFace == $FACE_BACK) {
                    if ($facingDir == $FACING_LEFT) {
                        $destFace = $FACE_UP;
                        $destEdge = $EDGE_TOP;
                        $rotDelta = $ROTATE_CCW;
                    } elsif ($facingDir == $FACING_RIGHT) {
                        $destFace = $FACE_DOWN;
                        $destEdge = $EDGE_BOTTOM;
                        $rotDelta = $ROTATE_CCW;
                    } elsif ($facingDir == $FACING_DOWN) {
                        $destFace = $FACE_RIGHT;
                        $destEdge = $EDGE_TOP;
                        $rotDelta = $ROTATE_NONE;
                    }
                }

                my $newDir = ($facingDir + $rotDelta) % 4;

                my $srcXOff = ($curX - 1) % $FACE_SIDE_LEN;
                my $srcYOff = ($curY - 1) % $FACE_SIDE_LEN;

                my $destXOff;
                my $destYOff;

                if ($rotDelta == $ROTATE_NONE) {
                    $destXOff = $srcXOff;
                    $destYOff = $srcYOff;
                } elsif ($rotDelta == $ROTATE_180) {
                    $destXOff = ($FACE_SIDE_LEN - 1) - $srcXOff;
                    $destYOff = ($FACE_SIDE_LEN - 1) - $srcYOff;
                } elsif (($rotDelta == $ROTATE_CW && ($facingDir == $FACING_DOWN || $facingDir == $FACING_UP))
                        || ($rotDelta == $ROTATE_CCW && ($facingDir == $FACING_LEFT || $facingDir == $FACING_RIGHT))) {
                    $destXOff = $srcYOff;
                    $destYOff = $srcXOff;
                } else {
                    $destXOff = ($FACE_SIDE_LEN - 1) - $srcYOff;
                    $destYOff = ($FACE_SIDE_LEN - 1) - $srcXOff;
                }

                my $destFaceX;
                my $destFaceY;

                # compute face origins and add offsets to get newX and newY
                if ($destFace == $FACE_UP) {
                    $destFaceX = 1;
                    $destFaceY = 0;
                } elsif ($destFace == $FACE_RIGHT) {
                    $destFaceX = 2;
                    $destFaceY = 0;
                } elsif ($destFace == $FACE_FRONT) {
                    $destFaceX = 1;
                    $destFaceY = 1;
                } elsif ($destFace == $FACE_LEFT) {
                    $destFaceX = 0;
                    $destFaceY = 2;
                } elsif ($destFace == $FACE_DOWN) {
                    $destFaceX = 1;
                    $destFaceY = 2;
                } elsif ($destFace == $FACE_BACK) {
                    $destFaceX = 0;
                    $destFaceY = 3;
                }

                if ($destEdge == $EDGE_LEFT) {
                    $destXOff = 0;
                } elsif ($destEdge == $EDGE_RIGHT) {
                    $destXOff = $FACE_SIDE_LEN - 1;
                } elsif ($destEdge == $EDGE_TOP) {
                    $destYOff = 0;
                } elsif ($destEdge == $EDGE_BOTTOM) {
                    $destYOff = $FACE_SIDE_LEN - 1;
                }

                $destXOff %= $FACE_SIDE_LEN;
                $destYOff %= $FACE_SIDE_LEN;

                $newX = $destFaceX * $FACE_SIDE_LEN + $destXOff + 1;
                $newY = $destFaceY * $FACE_SIDE_LEN + $destYOff + 1;

                # update since the y-value may have changed
                $newRow = $grid[$newY];
            }

            last if (substr($newRow, $newX, 1) eq $CHAR_WALL);

            $facingDir = ($facingDir + $rotDelta) % 4;

            $curX = $newX;
            $curY = $newY;
        }
    }
}

my $ansB = $curY * 1000 + $curX * 4 + $facingDir;
print("Part B: $ansB\n");
