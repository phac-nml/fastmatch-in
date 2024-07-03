/*
fast_matching
*/


process FAST_MATCH {
    label "process_high"
    tag "FastMatching reference and query profiles"

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'mwells14/go-cluster:0.0.1' :
        'mwells14/go-cluster:0.0.1' }"

    input:
    path query
    path ref

    output:
    path output_file, emit: matches
    path versions, emit: versions

    script:
    output_file = "match_results.txt"
    """
    go-cluster -i $query -r $ref \
    -l $task.cpus -m $params.go_cluster.missing_allele_char -c $params.go_cluster.column_delimiter \
    -t $params.go_cluster.threshold -d $params.go_cluster.distance -o $output_file

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        go-cluster: \$( go-cluster --version | sed -e "s/Version: //g" )
    END_VERSIONS
    """

}
