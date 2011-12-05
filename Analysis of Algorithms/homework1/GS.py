import sys

man2int = dict()
int2man = list()
woman2int = dict()
int2woman = list()

def getinput():
  readingmen = True
  menpreflist = list()
  womenpreflist = list()
  for line in sys.stdin.readlines(): 
    line = line.strip()
    if line == "":
      readingmen = False
      continue
    if readingmen:
      menpreflist.append(line.split(" "))
    else:
      womenpreflist.append(line.split(" "))
  for i in range(len(menpreflist)):
    man = menpreflist[i][0]
    woman = womenpreflist[i][0]
    man2int[man] = i
    int2man.append(man) 
    woman2int[woman] = i
    int2woman.append(woman)
  return menpreflist, womenpreflist

def test():
  menpreflist, womenpreflist = getinput()
  ranking = gs(menpreflist, womenpreflist)
  for item in ranking.items():
    print item[0], item[1]

"""
Make all men and women free
while a man has not proposed to every woman:
  choose a man m
  let w be the highest ranked women to who m has not proposed to
  if w is free:
    (m,w) become engages
  else:
    if w prefers m' to m:
      m remains free
    else:
      m' becomes free
"""
def gs(menpreflist, womenpreflist):
  freemen = [menpref[0] for menpref in menpreflist]  
  n = len(menpreflist[0]) - 1
  nextman = {manpref[0] : 0 for manpref in menpreflist}
  current = dict()
  ranking = dict()
  for womenpref in womenpreflist:
    current[womenpref[0]] = ""
    ranking[womenpref[0]] = {womenpref[i] : i for i in range(1,len(womenpref))}

  while freemen != []:
    m = freemen.pop()
    w = nextman[m]
    w = menpreflist[man2int[m]][w+1]
    if current[w] == "":
      current[w] = m
    else:
      m1 = current[w]
      if ranking[w][m] > ranking[w][m1]:
        nextman[m] += 1
        freemen.append(m)
      else:
        current[w] = m
        nextman[m1] += 1
        freemen.append(m1)
  return current
test()
