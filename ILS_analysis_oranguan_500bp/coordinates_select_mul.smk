shell.prefix(f" set -eo pipefail; ")

SAMPLES=[line.strip() for line in open("samples.fofn")]

rule all:
    input:
        expand("{sample}.bed.done.txt", sample = SAMPLES),

rule coordinates_select:
    input:
        "{sample}.bed",
    output:
        "{sample}.bed.done.txt",
    threads: 1,
    resources:
        mem=5,
    run:
        import os
        import sys, getopt
        infile=open('../hg38_chimp.mapped.bed','r')
        outfile=open('error_coordinates.txt','w')
        L_chimp=[]
        dic_chimp={}
        for line in infile:
            L=line.strip().split()
            L_chimp.append(L[3])
            dic_chimp[L[3]]=L[0]+':'+L[1]+'-'+L[2]
        infile.close()

        infile=open('../hg38_bonobo.mapped.bed','r')
        L_bonobo=[]
        dic_bonobo={}
        for line in infile:
            L=line.strip().split()
            L_bonobo.append(L[3])
            dic_bonobo[L[3]]=L[0]+':'+L[1]+'-'+L[2]
        infile.close()

        infile=open('../hg38_gorilla.mapped.bed','r')
        L_gorilla=[]
        dic_gorilla={}
        for line in infile:
            L=line.strip().split()
            L_gorilla.append(L[3])
            dic_gorilla[L[3]]=L[0]+':'+L[1]+'-'+L[2]
        infile.close()

        infile=open('../hg38_orangutan.mapped.bed','r')
        L_orangutan=[]
        dic_orangutan={}
        for line in infile:
            L=line.strip().split()
            L_orangutan.append(L[3])
            dic_orangutan[L[3]]=L[0]+':'+L[1]+'-'+L[2]
        infile.close()
        print ('APE loading done')

        shell("module load minimap2")
        shell("module load samtools/1.9")

        def check_chain_idx(s,i):
            shell("minimap2 temp_human%s.fa temp_%s%s.fa >temp_idx%s.txt" %(s,i,s,s))
            with open('temp_idx%s.txt' %(s)) as infile_check:
                IDX=infile_check.readline().strip().split()
                if IDX==[]:
                    outfile.write(s+'\t'+i)
                    return True
                if IDX[4]=='-':
                    if i == 'chimp':
                        shell("samtools faidx -i ../%s.fasta %s > temp_%s%s.fa" % (i,dic_chimp[s],i,s))
                        print ('chimp -')
                    elif i== 'bonobo':
                        shell("samtools faidx -i ../%s.fasta %s > temp_%s%s.fa" % (i,dic_bonobo[s],i,s))
                        print ('bonobo -')
                    elif i== 'gorilla':
                        shell("samtools faidx -i ../%s.fasta %s > temp_%s%s.fa" % (i,dic_gorilla[s],i,s))
                        print (' -')
                    elif i== 'orangutan':
                        shell("samtools faidx -i ../%s.fasta %s > temp_%s%s.fa" % (i,dic_orangutan[s],i,s))
                        print ('orangutan -')
            infile_check.close()
            return False

        def mul_seq(s):
            shell("samtools faidx ../%s.fa %s > temp_%s%s.fa" % ('hg38',dic_human[s],'human',s))
            shell("sed -i '1c >human' temp_human%s.fa" %(s))
            for i in ['chimp','bonobo','gorilla','orangutan']:
                if i == 'chimp':
                    temp_coor=dic_chimp[s]
                elif i== 'bonobo':
                    temp_coor=dic_bonobo[s]
                elif i== 'gorilla':
                    temp_coor=dic_gorilla[s]
                elif i== 'orangutan':
                    temp_coor=dic_orangutan[s]
                shell("samtools faidx ../%s.fasta %s > temp_%s%s.fa" % (i,temp_coor,i,s))
                if check_chain_idx(s,i):
                     shell('rm temp_*%s.fa temp_*%s.txt' % (s,s))
                     return
                shell("sed -i '1c >%s' temp_%s%s.fa" %(i,i,s))

            shell('cat temp_*%s.fa > %s.fa' % (s,s))
            shell('rm temp_*%s.fa temp_*%s.txt' % (s,s))
            return

        infile=open(str(input),'r')
        dic_human={}
        for line in infile:
            L=line.strip().split()
            dic_human[L[3]]=L[0]+':'+L[1]+'-'+L[2]
            if L[3] in L_bonobo and L[3] in L_gorilla and L[3] in L_chimp and L[3] in L_orangutan:
                print (L[3])
                mul_seq(L[3])
#                break
        infile.close()
        outfile.close()
        shell ("echo done >{output}")
