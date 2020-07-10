
import numpy as np

with open('web.txt', 'r', encoding='utf-8') as f:
    weblines = f.readlines()

with open('dsp.txt', 'r', encoding='utf-8') as f:
    dsplines = f.readlines()

lines = weblines + dsplines
linelens = [len(line.split()) for line in lines]
print("the number of lines is", len(lines))
print("the number of words is", np.sum(linelens))
print("the average line length is", np.mean(linelens))
print("the median line length is", np.median(linelens))