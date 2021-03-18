import sys,os
sys.path.append("XXX/ete3/ete3-3.1.1")
from ete3 import Tree

os.system("module load java/8u151")
infile=open("all_50_root_tree.txt","r")
outfile=open("all_50_root_tree.txt","w")
dic={}
roottaxon='orangutan'
L=['(orangutan,(gorilla,((bonobo,chimp),human)));']
dic[L[0]]=1

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
	tmp=line.strip().split(" ")[1]
	s=tmp
	tmp=root_tree(tmp)
	outfile.write(line.strip().split("\t")[0]+'\t'+tmp+'\n')
	for i in range(10):
		s=s.replace(str(i),'')
	s=s.replace(':','')
	s=s.replace('.','')
	s=s.replace('-','')
	s=s.replace('_','')
	s=s.replace('X','')
	s=s.replace('chr','human')
	s=root_tree(s)
	IDX=[]
	for tree in L:
		tree=root_tree(tree)
		IDX.append(tree_equal(s,tree))
		if 0 in IDX:
			break
	if 0 not in IDX:
		L.append(s)
		dic[s]=1
	else:
		dic[tree]+=1
print (len(L))
outfile.close()
for key in dic:
	print (key,dic[key]) #Caution: dic[key]-1 for the first key
infile.close()

