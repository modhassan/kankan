# Emacs: -*- mode: sh; sh-shell: bash; -*-

_cuto_get_pool_uri() {
  ## TODO impl, create pool from root section

  echo http://localhost:8080/webservice/escenic/section-page/13882
}

_cuto_update_teaser_options() {
  local uri=$1
  local http_auth=$2

  local tmp_file=
  tmp_file=$(mktemp)
  curl -s -u "${http_auth}" "${uri}" > "${tmp_file}"

  cat "${tmp_file}" | xmllint --format -

  exit 0

  local current_layout=

  local xpath='/a:entry/a:content/v:payload/v:field[@name="page"]/v:value/g:group/g:area/g:group/g:area/a:link/v:payload/v:field[@name="LAYOUT"]/v:value'

  local xpath='/a:entry/a:content/v:payload/v:field[@name="page"]/v:value/g:group/g:area/a:link/v:payload/v:field[@name="LAYOUT"]/v:value'
  current_layout=$(xml_xpath "${tmp_file}" "${xpath}")

  echo old layout=$current_layout

  if [[ "${current_layout}" == large ]]; then
    new_layout=small
  elif [[ "${current_layout}" == mini ]]; then
    new_layout=large
  else
    new_layout=mini
  fi

  echo changing layout to=$new_layout

  xml_xpath_set_value "${tmp_file}" "${xpath}" "${new_layout}"
  http_put_atom_entry "${uri}" "${http_auth}" "${tmp_file}"

  curl -s -u "${http_auth}" "${uri}" > "${tmp_file}"
  local updated_layout=
  updated_layout=$(xml_xpath "${tmp_file}" "${xpath}")

  echo changed layout should have been persisted=$updated_layout

  if [[ "${new_layout}" != "${updated_layout}" ]]; then
    flag_error "Teaser options on ${uri} should have been updated"
  fi

  rm -rf "${tmp_file}"

}


check_can_update_teaser_options() {


  for el in "${!ece_instance_host_port_and_http_auth_map[@]}"; do
    local host_and_port="${el}"
    local http_auth="${ece_instance_host_port_and_http_auth_map[${el}]}"
    local ws_base_url=http://${host_and_port}/webservice

    local pool_uri=
    pool_uri=$(
      _cuto_get_pool_uri "${host_and_port}" "${ws_base_url}" "${http_auth}")


    _cuto_update_teaser_options "${pool_uri}" "${http_auth}"

  done

}
