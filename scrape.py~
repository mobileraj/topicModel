import os
yrs = range(1977,2004)
yrs2=range(2004,2015)

for x in yrs2:
 #yrs for html
 #os.system('html2text http://www.berkshirehathaway.com/letters/'+str(x)+'.html --decode-errors=ignore > '+str(x)+'.txt')
 os.system('gs -sDEVICE=txtwrite -dFirstPage=2 -o '+str(x)+'.txt '+str(x)+'ltr.pdf')


