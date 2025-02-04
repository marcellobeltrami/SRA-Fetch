
/*
  ____  _    _   _ ____  __  __    __  __           _       _           
 / ___|| |  | | | |  _ \|  \/  |  |  \/  | ___   __| |_   _| | ___  ___ 
 \___ \| |  | | | | |_) | |\/| |  | |\/| |/ _ \ / _` | | | | |/ _ \/ __|
  ___) | |__| |_| |  _ <| |  | |  | |  | | (_) | (_| | |_| | |  __/\__ \
 |____/|_____\___/|_| \_\_|  |_|  |_|  |_|\___/ \__,_|\__,_|_|\___||___/

    Environmental to globally manage SLURM modules in case they need updating.
    These area directly called in the "script" section of processes.                                                                        

*/

env {

    // Purge environment before loading modules. Fails process if there are any errors. 
    purge = "module purge; set -e"

    // Pre processing modules
    fastqc = "module load FastQC/0.12.1-Java-11"
    multiqc = "module load MultiQC/1.13-foss-2021b"
    fastp = "module load fastp/0.23.4-GCC-13.2.0"
    ftp_head = "ftp://ftp.sra.ebi.ac.uk"
}