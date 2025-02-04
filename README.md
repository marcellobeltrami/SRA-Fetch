# SRA-Fetch
Nextflow Pipeline that fetches SRA entries and automatically QCs them. Optionally, reads can also be trimmed.


### Quickstart

To use this program you will need a (free) API key from NCBI. Obtain API Key : https://support.nlm.nih.gov/kbArticle/?pn=KA-05317 .

Inputs can be given as a list of entries or by project code. It is advisable to use a .yaml file to pass these parameters.
*See input_example/* for an example of a param.yaml file.

```bash
# To run on SLURM
nf run main.nf -params-file <path/to/params.yaml> -profile slurm

# To run locally (mostly for dev)
nf run main.nf -params-file <path/to/params.yaml> -profile local

```

**Note:** the pipeline has been tested with single project ids and multiple reads ids. It is possible that passing a list of projects could work, although it could result in unexpected behaviour.

### Update modules

This pipeline relies on a centralized file to manage SLURM dependencies. Modifying  commands in ```bash configs/modules.nf ``` will allow to load relevant modules to relative processes. 
This allows to use this pipeline on different HPCs managed by SLURM. 


## Dev Note

Running the pipeline locally with stub is quite useful to test inputs and outputs and general syntax without major resource usage. 

```bash
nf run main.nf -params-file <path/to/params.yaml> -profile slurm -stub-run

# To run locally (mostly for dev)
nf run main.nf -params-file <path/to/params.yaml> -profile local -stub-run

```
### **TO DO**
- [X] Implement SRA get and download 
- [ ] Implement MultiQC
- [ ] Test Trimming

