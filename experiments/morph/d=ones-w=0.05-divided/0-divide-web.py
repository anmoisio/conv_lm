import math

with open('../../../data/lm-train/web.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()
totsize = len(lines)
filesize = math.ceil(totsize / 6)

for filenum in [1,2,3,4,5,6]:
    fil = 'data/web{}.txt'.format(filenum)
    linerange = range((filenum - 1)*filesize, min(filenum*filesize, totsize))
    print("writing lines {} in file {}".format(linerange, fil))
    with open(fil, 'w', encoding='utf-8') as f:
        for linenum in linerange:
            f.write(lines[linenum])

