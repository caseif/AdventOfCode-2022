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

            if ($newX >= length($newRow) || substr($newRow, $newX, 1) eq $CHAR_EMPTY) {
                if ($facingDir == $FACING_RIGHT) {
                    (my $trimmedRow = $newRow) =~ s/^\s+//g;
                    $newX = length($newRow) - length($trimmedRow);
                } elsif ($facingDir == $FACING_LEFT) {
                    (my $trimmedRow = $newRow) =~ s/\s+$//g;
                    $newX = length($trimmedRow) - 1;
                } elsif ($facingDir == $FACING_DOWN) {
                    for (0..(scalar(@grid) - 1)) {
                        next if length($grid[$_]) <= $newX;

                        if (substr($grid[$_], $newX, 1) ne $CHAR_EMPTY) {
                            $newY = $_;
                            last;
                        }
                    }
                } elsif ($facingDir == $FACING_UP) {
                    my $i = scalar(@grid) - 1;
                    while ($i >= 0) {
                        next if length($grid[$i]) <= $newX;

                        if (substr($grid[$i], $newX, 1) ne $CHAR_EMPTY) {
                            my $c = substr($grid[$i], $newX, 1);
                            $newY = $i;
                            last;
                        }
                    } continue {
                        $i -= 1;
                    }
                }

                # update since the y-value may have changed
                $newRow = $grid[$newY];
            }

            last if (substr($newRow, $newX, 1) eq $CHAR_WALL);

            $curX = $newX;
            $curY = $newY;
        }
    }
}

my $ansA = $curY * 1000 + $curX * 4 + $facingDir;
print("Part A: $ansA\n");
