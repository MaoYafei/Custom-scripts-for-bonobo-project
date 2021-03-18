import sys,os
sys.path.append("XXX/ete3/ete3-3.1.1")
from ete3 import Tree

infile=open("all_tree.txt","r")

BSvalue=50

def bootstrap_check(tree, value):
	tree = Tree(tree)
	for node in tree.iter_search_nodes():
		if node.support > 1 and node.support < value:
			return False
	return True

for line in infile:
	s=line.strip().split(" ")[1]
	if bootstrap_check(s, BSvalue):
		print (line.strip())
infile.close()

