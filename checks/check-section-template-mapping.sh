#!/usr/bin/env bash

check_storyline_template_available_at_section() {
  local minimum_count=1
  for el in "${!publication_auth_map[@]}"; do
    local publication="${el}"
    local http_auth="${publication_auth_map[${el}]}"
    local solr_selction_url="http://localhost:8983/solr/editorial/select?fl=objectid&indent=on&q=publication:%22${publication}%22%20AND%20contenttype:%22com.escenic.section%22%20AND%20section_uniquename:%22ece_frontpage%22&wt=json"

    local tmp_file=
    tmp_file=$(mktemp)

    local section_id=$(curl --fail  "$solr_selction_url" | jq ".response.docs[0].objectid" | sed -e "s/\"//g")
    curl --fail -u "${http_auth}" -X GET http://localhost:8080/webservice/escenic/section/"${section_id}" > $tmp_file
    local section_template_count=$( xmlstarlet sel -N a="http://www.w3.org/2005/Atom" -N g="http://xmlns.escenic.com/2015/layout-group" -N v="http://www.vizrt.com/types" -t -v  "count(/a:entry/a:content/v:payload/v:field[@name='com.escenic.storyline-templates']/v:list/v:payload)" $tmp_file )
    if [[ "${section_template_count-0}" -lt "${minimum_count}" ]]; then
      flag_error "At least ${minimum_count} storyline template should be available."
    fi
    rm "${tmp_file}"
  done
}
