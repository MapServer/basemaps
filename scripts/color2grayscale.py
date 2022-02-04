import fileinput
import sys
import re
from random import randint
# Author Nicolas Ribot nicolas.ribot@gmail.com
# script to change a mapfile color values based on different formulas:
# changed mapfile is printed out
#
# usage: python color2grayscale(path to mapfile, <color type>
# where <color type> can be one of grayscale, random, invert, luminance

f = open(sys.argv[1], 'r')

gray_color = re.compile(r'COLOR (\d+) (\d+) (\d+)$')

def replace(match):
    ret = 'COLOR %s %s %s' % (match.group(1), match.group(2), match.group(3))
    if sys.argv[2] == 'grayscale':
        val1 = val2 = val3 = (int(match.group(1)) + int(match.group(2)) + int(match.group(3))) / 3
        ret = 'COLOR %s %s %s' % (val1, val2, val3)
    elif sys.argv[2] == 'random':
        ret = 'COLOR %s %s %s' % (randint(1,255), randint(1,255), randint(1,255))
    elif sys.argv[2] == 'invert':
        ret = 'COLOR %s %s %s' % (256 - int(match.group(1)), 256 - int(match.group(2)), 256 - int(match.group(3)))
    elif sys.argv[2] == 'luminance':
        val1 = val2 = val3 = (int(int(match.group(1)) * 0.299) + int(int(match.group(2)) * 0.587)
                              + int(int(match.group(3)) * 0.114))
        ret = 'COLOR %s %s %s' % (val1, val2, val3)

    return ret

# for line in fileinput.input(inplace=False):
for line in f.readlines():
    line = gray_color.sub(replace, line)
    sys.stdout.write(line)

sys.stdout.write('\n')

