
with open('18.txt', 'r', encoding='utf-8') as f:
    trn = f.read()

trn = trn.replace('+ +','')
trn = trn.replace('+ ',' ')
trn = trn.replace(' +',' ')
trn = trn.replace('+\n','\n')

new = []
for line in trn.splitlines():
    words = line.split()
    id = words[0]
    new.append(' '.join(words[1:]) + ' ({})'.format(id))

with open('combined.txt', 'w', encoding='utf-8') as f:
    for line in new:
        f.write(line + '\n')

