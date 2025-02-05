/*
  __  __       _         
 |  \/  | __ _(_)_ __    
 | |\/| |/ _` | | '_ \   
 | |  | | (_| | | | | |  
 |_|  |_|\__,_|_|_| |_|  
                         
 Handles program logic based on inputs.

*/

include {DownLoadReads; FastQC as FastQCRaw;FastQC as FastQCTrim ; Trim; MultiQC} from './lib/dep/processes.nf'
include {getSRAEntries} from './lib/dep/misc.nf'



workflow{

    SRA_channel = getSRAEntries()

    SRA_channel.view()

    Reads_ch = DownLoadReads(SRA_channel)
    
    FastQC_out = FastQCRaw(Reads_ch.reads_tuple)

    // Checks if reads should be trimmed directly.
    if (params.trimmed == true){
        Trimmed_reads = Trim(Reads_ch.reads_tuple)
        FastQC_out_trim = FastQCTrim(Trimmed_reads.trimmed_tuple)

        QC_merged = FastQC_out.results.concat(FastQC_out_trim.results)
        MultiQC(QC_merged.collect())

    } else {
        
        MultiQC(FastQC_out.results.collect())

    }




}
