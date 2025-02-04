
// Gets apprpriate SRA entries depending on input.
def getSRAEntries(){
    
    if (params.id_list != null){

        SRA_channel = channel.fromSRA(params.id_list, 
                                      apiKey:params.ncbi_api_key, 
                                      protocol:'ftp',
                                      retryPolicy: [delay: '1.5s', maxAttempts: 5])

        return SRA_channel

    } else if (params.project_name != null){
        
        SRA_channel = channel.fromSRA(params.project_name, 
                                      apiKey:params.ncbi_api_key, 
                                      protocol:'ftp',
                                      retryPolicy: [delay: '1.5s', maxAttempts: 5])
        return SRA_channel
    
    } else {

        error "Please specify valid project ID or list of samples ID"
    }
}
 
 