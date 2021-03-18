SAMPLES=[line.strip() for line in open("sample_chrX.fofn")]

rule all:
        input:
                expand("chrX/{sample}.treefile.done", sample = SAMPLES),

rule treemake:
        input:
                "chrX/{sample}",
        params:
                sge_opts="-l mfree=2G -l h_rt=4:00:00 -pe serial 1",
        output:
                "chrX/{sample}.treefile.done",
        shell:"""
prank -d={input} -o={input}.aln >/dev/null 2>&1 && \
iqtree -s {input}.aln.best.fas -bb 1000 -m MFP+MERGE -redo -nt 1 -safe >/dev/null 2>&1 && \
mv {input}.aln.best.fas.treefile `dirname {input}`/treefile  && \
mv {input} `dirname {input}`/ori_fasta_failed/  && \
rm {input}.aln.best.fas.*  && \
touch {output}
"""
