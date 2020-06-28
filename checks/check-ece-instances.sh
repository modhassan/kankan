# Emacs: -*- mode: sh; sh-shell: bash; -*-

has_initialised_ece_instance_check=0

declare -a url_list_vdf=()

init_check_ece_instances() {
  for el in "${!ece_instance_host_port_and_http_auth_map[@]}"; do
    host_and_port="${el}"
    http_auth="${ece_instance_host_port_and_http_auth_map[${el}]}"
    publication="${ece_instance_host_port_and_publication_map[${el}]}"
    content_type="${ece_instance_host_port_and_content_type_map[${el}]}"

    url_list_200_ok_and_xml=(
      http://"${http_auth}"@${host_and_port}/webservice/index.xml
      http://"${http_auth}"@${host_and_port}/webservice/escenic/publication/${publication}/model/content-type/${content_type}
      ${url_list_200_ok_and_xml[@]}
    )

    url_list_vdf=(
      http://"${http_auth}"@${host_and_port}/webservice/escenic/publication/${publication}/model/content-type/${content_type}
      ${url_list_vdf[@]}
    )
  done

  has_initialised_ece_instance_check=1
}

check_that_search_is_working() {
  for el in "${!ece_instance_host_port_and_http_auth_map[@]}"; do
    ((number_of_tests++))
    local host_and_port="${el}"
    local http_auth="${ece_instance_host_port_and_http_auth_map[${el}]}"

    local uri="http://${host_and_port}/webservice/search/*/"
    local -i total_results=0
    total_results=$(
      curl -s  -u "${http_auth}" "${uri}" 2> /dev/null |
        grep totalResults |
        tail -n 1 |
        sed -n -r 's#.*totalResults="([^"]*)".*#\1#p')
    if [ "${total_results}" -gt 0 ]; then
      echo -n "."
    else
      flag_error "Searching isn't working using ${uri}"
    fi
  done
}

check_list_of_urls_that_should_return_vdf() {
  if [ "${has_initialised_ece_instance_check}" -eq 0 ]; then
    init_check_ece_instances
  fi

  for el in "${url_list_vdf[@]}"; do
    ((number_of_tests++))
    local uri_fragment=${el##http://${host_and_port}}

    curl -I -s "${el}" 2> /dev/null |
      grep --quiet -i "^Content-Type: application/vnd.vizrt.model+xml"
    if [ $? -ne 0 ]; then
      flag_error "${uri_fragment} did NOT return VDF"
    fi

    if [ "${verbose-0}" -eq 1 ]; then
      echo "Verified VDF: ${uri_fragment}"
    else
      echo -n "."
    fi
  done
}
