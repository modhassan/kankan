# Emacs: -*- mode: sh; sh-shell: bash; -*-

## $1 :: file
## $2 :: xpath
xml_xpath() {
  local file=$1
  local xpath=$2

  xmlstarlet \
    sel \
    -N a="http://www.w3.org/2005/Atom" \
    -N v="http://www.vizrt.com/types" \
    -t \
    -v \
    "${xpath}" \
    "${file}"
}

xml_xpath_set_value() {
  local file=$1
  local xpath=$2
  local value=$3

  xmlstarlet \
    ed \
    --inplace \
    -N a="http://www.w3.org/2005/Atom" \
    -N v="http://www.vizrt.com/types" \
    -u "${xpath}" \
    -v "${value}" \
    "${file}"
}

## $1 :: list pool id
_clp_change_pinned_states() {
  local uri=$1

  local tmp_file=
  tmp_file=$(mktemp)

  curl -s -u "${http_auth}" "${uri}" > "${tmp_file}"

  local pool_list_entry_edit_links=
  pool_list_entry_edit_links=$(
    xml_xpath "${tmp_file}" '/a:feed/a:entry/a:link[@rel="edit"]/@href')

  local i=0
  local edit_link=
  for edit_link in ${pool_list_entry_edit_links}; do
    i=$((i + 1))
    local handle_tmp=
    handle_tmp=$(mktemp)
    curl -s -u "${http_auth}" "${edit_link}" > "${handle_tmp}"
    local handle_pinned_state=
    handle_pinned_state=$(
      xml_xpath \
        "${handle_tmp}" \
        '/a:entry/a:content/v:payload/v:field[@name="com.escenic.pinned"]/v:value')
    if [[ "${handle_pinned_state}" == false ]]; then
      new_pinned_state=true
      priority=$i
    else
      priority=-1
      new_pinned_state=false
    fi

    xml_xpath_set_value \
      "${handle_tmp}" \
      '/a:entry/a:content/v:payload/v:field[@name="com.escenic.pinned"]/v:value' \
      "${new_pinned_state}"
    xml_xpath_set_value \
      "${handle_tmp}" \
      '/a:entry/a:content/v:payload/v:field[@name="com.escenic.priority"]/v:value' \
      "${priority}"

    http_put_atom_entry "${edit_link}" "${http_auth}" "${handle_tmp}"

    rm -rf "${handle_tmp}"
  done



  rm "${tmp_file}"

}


check_list_pool_changing_pinned_state_updates_etag() {
  for el in "${!ece_instance_host_port_and_http_auth_map[@]}"; do
    local host_and_port="${el}"
    local http_auth="${ece_instance_host_port_and_http_auth_map[${el}]}"
    local ws_base_url=http://${host_and_port}/webservice

    local tmp_file=
    tmp_file=$(mktemp)


    list_pool_uri=http://localhost:8080/webservice/escenic/list-pool/13615
    etag_before=$(
      http_get_header_from_uri "${list_pool_uri}" "${http_auth}" etag)

    _clp_change_pinned_states "${list_pool_uri}"

    etag_after=$(
      http_get_header_from_uri "${list_pool_uri}" "${http_auth}" etag)

    if [[ "${etag_before}" == "${etag_after}" ]]; then
      flag_error "ETag should have been updated"
    fi

    rm "${tmp_file}"
  done
}
