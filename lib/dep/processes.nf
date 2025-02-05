/*
  ____                                                
 |  _ \ _ __ ___       _ __  _ __ ___   ___ ___  ___ ___ 
 | |_) | '__/ _ \_____| '_ \| '__/ _ \ / __/ _ \/ __/ __|
 |  __/| | |  __/_____| |_) | | | (_) | (_|  __/\__ \__ \
 |_|   |_|  \___|     | .__/|_|  \___/ \___\___||___/___/
                      |_|                                

*/


// Downloads and detects wheter reads are paired or not.
process DownLoadReads {
    label 'get'
    publishDir "${params.output}/01_RawReads/", mode: 'copy'

    input: 
        tuple val(sample_id), val(reads)
    
    output:
        tuple val(sample_id), path("*.fastq.gz"), emit: reads_tuple

    script:
        
        if (reads.size() == 2) {
            """
            wget "$ftp_head${reads[0]}"
            wget "$ftp_head${reads[1]}"
            """
        } else if (reads.size() == 1) {
            """
            wget "$ftp_head${reads[0]}"
            """
        } else {
                error "Unexpected number of read files: ${reads.size()}. Expected is either paired(2) or unpaired(1)"
            }
        
    stub:
        """
        
        if [ ${reads.size()} -eq 2 ]; then
            echo "Number is 2" > size2.fastq.gz
        else [ ${reads.size()} -eq 1 ]
            echo "Number is 1" > size1.fastq.gz
        fi
    
        
        """
}


// Carries out FastQC
process FastQC {
    label "QC"
    //publishDir "${params.output}/01_QC/FastQC", mode: 'copy'
    input:
        tuple val(sample_id), path(reads)

    output:
        val(sample_id), emit: id
        path("${sample_id}/*_fastqc.{zip,html}"), emit: results

    script:
        def read_inputs = reads instanceof Path ? reads : reads.join(' ')
        """
        $purge
        $fastqc # Load FastQC module

        mkdir -p ${sample_id}
        fastqc ${read_inputs} --threads ${task.cpus} --verbose --outdir ${sample_id}
        """

    stub: 
        """
        mkdir -p ${sample_id}
        touch ${sample_id}/fastqc.zip
        touch ${sample_id}/fastqc.html
        """

}


process FastQCTrim {
    label "QC"
    //publishDir "${params.output}/01_QC/FastQC", mode: 'copy'
    input:
        tuple val(sample_id), path(reads)

    output:
        val(sample_id), emit: id
        path("${sample_id}/*_trim-fastqc.{zip,html}"), emit: results

    script:
        def read_inputs = reads instanceof Path ? reads : reads.join(' ')
        """
        $purge
        $fastqc # Load FastQC module

        mkdir -p ${sample_id}
        fastqc ${read_inputs} --threads ${task.cpus} --verbose --outdir ${sample_id}_trim
        """

    stub: 
        """
        mkdir -p ${sample_id}
        touch ${sample_id}/${sample_id}_trim-fastqc.zip
        touch ${sample_id}/${sample_id}_trim-fastqc.html
        """

}



// Carries out MultiQC
process MultiQC {
    label "QC"
    publishDir "${params.output}", mode: 'copy'  
    
    input:
        path '*' // Collected list of tuples from Metrics of processes ->  multiqc_files = [file1.zip, file1.html, file2.zip, file.json, file2.html]

    output:
        path "multiqc_report.html"

    script:
        // Flatten the list to get all FastQC output files
        """
        $purge
        $multiqc
        
        multiqc . -o .
        """

    stub:
        """
        touch multiqc_report.html
        """
}


// Carries out MultiQC
process MultiQCTrim {
    label "QC"
    publishDir "${params.output}", mode: 'copy'  
    
    input:
        path '*' // Collected list of tuples from Metrics of processes ->  multiqc_files = [file1.zip, file1.html, file2.zip, file.json, file2.html]

    output:
        path "multiqc_report_trimmed.html"

    script:
        // Flatten the list to get all FastQC output files
        """
        $purge
        $multiqc
        
        multiqc . -o .
        mv multiqc_report.html multiqc_report_trimmed.html
        
        """

    stub:
        """
        touch multiqc_report_trimmed.html
        """
}



// Carries out trimming for single and paired end reads.
process Trim{
    label 'trimming'
    publishDir "${params.output}/02_Trimmed/", mode: 'copy'  

    input:
        tuple val(sample_id), path(reads)


    output:
        tuple val(sample_id), path("*.trm.fastq.gz"), emit: trimmed_tuple
        path("${sample_id}.fastp.json"), emit: json
        path("${sample_id}.fastp.html"), emit: html
    
    script:
    
        if (reads.size() == 1){

            """
                $purge
                $fastp # Load Fastp trimming module

                fastp \\
                    -i "${read[0]}" \\
                    -o "${sample_id}.trm.fastq.gz" \\
                    -q ${params.quality} \\
                    -l ${params.length_min} \\
                    --length_limit ${params.length_max} \\
                    -w ${task.cpus} \\
                    -j "${sample_id}.fastp.json" \\
                    -h "${sample_id}.fastp.html"
                
            """

        } else if (reads.size() == 2){
            """
            $purge
            $fastp # Load Fastp trimming module

            fastp \\
                -i "${reads[0]}" \\
                -I "${reads[1]}" \\
                -o "${sample_id}_1.trm.fastq.gz" \\
                -O "${sample_id}_2.trm.fastq.gz" \\
                -q ${params.quality} \\
                -l ${params.length_min} \\
                --length_limit ${params.length_max} \\
                -w ${task.cpus} \\
                -j "${sample_id}.fastp.json" \\
                -h "${sample_id}.fastp.html"
            
        
            """

        }
        
    
    stub:

        if (reads.size() == 1){
            """
            touch ${sample_id}.trm.fastq.gz
            touch ${sample_id}.fastp.json
            touch ${sample_id}.fastp.html
            """
        }
        else if (reads.size() == 2){
            """
            touch ${sample_id}_1.trm.fastq.gz
            touch ${sample_id}_2.trm.fastq.gz
            touch ${sample_id}.fastp.json
            touch ${sample_id}.fastp.html
            """

        }


}

