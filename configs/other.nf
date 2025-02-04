
/*



*/

// Pipeline Manifest
manifest {
    name = 'SRA getter'
    version = '1.0.0'
    description = 'Pipeline to retrieve, QC and optionally trim SRA reads.'
    author = 'Dr. Andrew Mason, Marcello Beltrami'
    mainScript = 'main.nf'
    nextflowVersion = '>=22.10.0'
    defaultBranch = 'main'
   
}

// Manages plugins and their configurations.
plugins {
  id "nf-boost" // Enables cleanup feature
}

// Manages temps cleanup as they fall out of scope. (false by default)
boost {
  cleanup = true
}

// Generate summary reports, timeline, trace, and DAG.
reports_dir = "${params.output}/reports" 

timeline {
    enabled = true
    overwrite = true
    file = "${reports_dir}/timeline.html"
}

report {
    enabled = true
    overwrite = true
    file = "${reports_dir}/report.html"
}

trace {
    enabled = true
    overwrite = true
    file = "${reports_dir}/trace.txt"
}


// Specifies executor profiles
profiles {
    standard {
        process.executor = 'local'
    }
    
    slurm {
        process.executor = 'slurm'
    }
    
    debug {
        // This profile can be used with either standard or slurm
        // It will preserve the work directory for debugging
        process.executor = 'local'
        boost.cleanup = false
    }
}