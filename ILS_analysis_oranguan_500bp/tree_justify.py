import sys,os
sys.path.append("XXX/ete3/ete3-3.1.1")
from ete3 import Tree

os.system("module load java/8u151")
infile=open("all_50_root_tree.txt","r")
outfile=open("all_50_root_tree.anno.simple","w")
dic={}
roottaxon='orangutan'
L=['(orangutan,(gorilla,((bonobo,chimp),human)));']

dic['0']='(orangutan,(gorilla,((bonobo,chimp),human)));'
dic['1']='(orangutan,(((bonobo,chimp),gorilla),human));'
dic['2']='(orangutan,((gorilla,human),(bonobo,chimp)));'
dic['3']='(orangutan,(((bonobo,human),chimp),gorilla));'
dic['4']='(orangutan,(((chimp,human),bonobo),gorilla));'
dic['5']='(orangutan,(((gorilla,human),chimp),bonobo));'
dic['6']='(orangutan,(((gorilla,human),bonobo),chimp));'
dic['7']='(orangutan,((chimp,human),(bonobo,gorilla)));'
dic['8']='(orangutan,((chimp,gorilla),(bonobo,human)));'
dic['9']='(orangutan,(((chimp,human),gorilla),bonobo));'
dic['10']='(orangutan,(((bonobo,human),gorilla),chimp));'
dic['11']='(orangutan,(((bonobo,gorilla),chimp),human));'
dic['12']='(orangutan,(((chimp,gorilla),bonobo),human));'
dic['13']='(orangutan,(((bonobo,gorilla),human),chimp));'
dic['14']='(orangutan,(((chimp,gorilla),human),bonobo));'


def root_tree(s1):
	s1 = Tree(s1)
	s1.set_outgroup(s1 & roottaxon)
	s1 = s1.write(format=8)
	s1 = s1.replace('NoName', '')
	return (s1)

def tree_equal(s1,s2):
	s1 = Tree(s1)
	s2 = Tree(s2)
	return (s1.robinson_foulds(s2,unrooted_trees=True))[0]

for line in infile:
	L_temp=line.strip().split('\t')
	if len(L_temp)==1:continue
	tmp=L_temp[1]
	s=tmp
	tmp=root_tree(tmp)
#	outfile.write(tmp+'\n')
#	for i in range(10):
#		s=s.replace(str(i),'')
#	s=s.replace(':','')
#	s=s.replace('.','')
#	s=s.replace('-','')
#	s=s.replace('_','')
#	s=s.replace('X','')
#	s=s.replace('Y','')
#	s=s.replace('chr','Human')
#	s=root_tree(s)
	s=tmp
	IDX=[]
	for i in range(15):
		if tree_equal(s,root_tree(dic[str(i)]))==0:
			outfile.write("%s\t%s\t%s\t%s\n" %(L_temp[0],L_temp[1],dic[str(i)],str(i)))
#	break
#print (len(L))
outfile.close()
infile.close()

