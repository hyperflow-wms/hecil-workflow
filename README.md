HECIL Workflow Example
----------------------

Port of the [Makeflow](http://ccl.cse.nd.edu/software/makeflow) [Hecil workflow](https://github.com/cooperative-computing-lab/makeflow-examples/tree/master/hecil) to HyperFlow.

This workflow gives an example of using Makeflow to parallelize
the Hybrid Error Correction with Iterative Learning (HECIL) tool.

Citation:
"HECIL: A Hybrid Error Correction Algorithm for Long Reads with Iterative Learning",
Olivia Choudhury, Ankush Chakrabarty, and Scott Emrich
bioRxiv preprint, 2017.
https://doi.org/10.1101/162917

The conversion of HECIL into a workflow was accomplished
by Connor Howington as part of a summer REU project at Notre Dame.

Installation and Use
--------------------

Use the Docker container image `hyperflowwms/hecil-worker`, or build it yourself:

```
make image
```

Generate test data
------------------

If you do not have real data to work with, then generate
some simulated data (~10 second workflow):

```
./scripts/fastq_generate.pl 100000 1000 > ref.fastq
./scripts/fastq_generate.pl 10000 100 ref.fastq > query.fastq
```

The long read file needs to be in fasta format, so you'll need to convert it:

```
./convert_fastq.py ref.fastq > ref.fasta
```

Then, generate a workflow to process the data:

```
./make_hecil_workflow -l ref.fasta -s query.fastq -len 100 -p 100 -ps 2 -rs 1000
```


Execute workflow
----------------


Outputs
-------
corr.out (default) contains only the corrected long reads.  Corrected_ref.fasta contains all reads, with the corrected reads replacing the old reads (order is not conserved from input fasta file).

