
profiles {
    
    // Settings for testing locally
    local {
        process.executor = 'local'
        process.cpus = 4
        process.memory = '4 GB'
    }

    // Settings for local execution in debug (preserves all intermediate files)
    debug {
        process.executor = 'local'
        process.cpus = 4
        process.memory = '4 GB'
    }

    slurm {
            process{
                global_options = '--qos=default --account=biol-cancerinf-2020'
                // Define resources for MultiQC process
                    withLabel: QC {
                        memory= { 10.GB * task.attempt }
                        time= '30m'
                        clusterOptions="${global_options} --output=%x-%j.FastQC.log"
                    }


                    // Define resources for MultiQC process
                    withLabel: trimming {
                        memory= { 10.GB * task.attempt }
                        time= '30m'
                        cpus = 15
                        clusterOptions="${global_options} --output=%x-%j.Multi_QC.log"
                    }


                    // Define resources for MultiQC process
                    withLabel: get {
                            memory = 3.GB
                            time = '2h'
                            cpus = 2
                            clusterOptions = "${global_options} --output=%x-%j.Download.log"
                        }
                
                }


    }

}