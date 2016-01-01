import os
yrs = range(1977,2015)

for x in yrs:
 #yrs for html
 #os.system('html2text http://www.berkshirehathaway.com/letters/'+str(x)+'.html --decode-errors=ignore > '+str(x)+'.txt')
 os.system('dd conv=lcase if=data/'+str(x)+'.txt of=topics/'+str(x)+'.txt')


