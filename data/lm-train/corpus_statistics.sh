
words=$(cat dsp.txt web.txt | wc -w)
echo total number of words is $words
lines=$(cat dsp.txt web.txt | wc -l)
echo total number of lines is $lines

python3 << END
import sys
filename = (sys.argv[1])
print("the $lines")
END $(cat dsp.txt web.txt)