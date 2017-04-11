# Emacs: -*- mode: sh; sh-shell: bash; -*-

_foreign_create_content_item() {
  local tmp_file=
  tmp_file=$(mktemp)

  local title=
  local body=
  local publication=
  local http_auth=

  for el in "${!ece_instance_host_port_and_http_auth_map[@]}"; do
    title=$(fortune | head -n 1)
    body=$(fortune)

    local host_and_port=$el
    local ws_base_url=http://${host_and_port}/webservice

    local publication="${ece_instance_host_port_and_publication_map[${el}]}"
    http_auth="${ece_instance_host_port_and_http_auth_map[${el}]}"
    local content_type="${ece_instance_host_port_and_content_type_map[${el}]}"

    sub_section_uri=$(_foreign_get_sub_section_uri)
    local root_section_uri=
    root_section_uri=$(_foreign_get_root_section_uri)

    local content_item_url=
    content_item_url=$(_foreign_create_content_item_from_xml "${tmp_file}" "${root_section_uri}")
    # We get some nonsense character at the end because of standard
    # error/out redirect. Removing it here.
    end=$(( ${#content_item_url} - 1 ))

    local content_item_uri="${content_item_url:0:${end}}"

    curl \
      --silent \
      --user "${http_auth}" \
      "${content_item_uri}"\
      > "${tmp_file}"

    _foreign_add_random_author_to_content_item \
      "${tmp_file}" \
      "${content_item_uri}"

    curl --silent --user "${http_auth}" "${content_item_uri}" > "${tmp_file}"

    xmlstarlet \
      sel \
      -N a="http://www.w3.org/2005/Atom" \
      -t \
      -v "/a:entry/a:author/a:name" \
      "${tmp_file}" |
      grep -c -q "${random_author_name}" || {
      flag_error "No foreign author with name '${random_author_name}'"
    }
    xmlstarlet \
      sel \
      -N a="http://www.w3.org/2005/Atom" \
      -t \
      -v "/a:entry/a:author/a:name" \
      "${tmp_file}" |
      grep -c -q "${random_author_uri}" || {
      flag_error "No foreign author with uri ${random_author_uri}"
    }
  done

  # cat "${tmp_file}"

  rm -rf "${tmp_file}"

}

_foreign_get_sub_section_uri() {
  local xpath='/endpoint/link[@rel="sections"]/@href'
  curl \
    --silent \
    --user "${http_auth}" \
    --request GET \
    "${ws_base_url}/index.xml" |
    sed 's#xmlns=".*"##' |
    xmllint --xpath "${xpath}" - |
    sed -r 's#.*["](.*)["].*#\1#'
}

_foreign_get_root_section_uri() {
  local xpath='/feed/entry/link[@rel="http://www.vizrt.com/types/relation/content-items"]/@href'
  curl \
    --silent \
    --user "${http_auth}" \
    --request GET \
    "${ws_base_url}/${sub_section_uri}" |
    xmllint --format - |
    sed 's#xmlns=".*"##' |
    xmllint --xpath "${xpath}" - |
    sed -r 's#.*["](.*)["].*#\1#'
}

_foreign_create_content_item_from_xml() {
  local tmp_file=$1
  local root_section_uri=$2

  cat > "${tmp_file}" <<EOF
<?xml version="1.0"?>
<entry xmlns="http://www.w3.org/2005/Atom"
  xmlns:app="http://www.w3.org/2007/app"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:metadata="http://xmlns.escenic.com/2010/atom-metadata">
  <content type="application/vnd.vizrt.payload+xml">
    <vdf:payload xmlns:vdf="http://www.vizrt.com/types"
        model="${ws_base_url}/escenic/publication/mypub/model/content-type/${content_type}">
      <vdf:field name="title">
        <vdf:value>${title}</vdf:value>
      </vdf:field>
      <vdf:field name="body">
        <vdf:value>${body}</vdf:value>
      </vdf:field>
    </vdf:payload>
  </content>
  <title type="text">${title}</title>
</entry>
EOF

  curl \
    --silent \
    --include \
    --user "${http_auth}" \
    --request POST \
    --header "Content-Type: application/atom+xml; type=entry" \
    --upload-file "${tmp_file}" \
    "${root_section_uri}" 2>&1 |
    sed -n -r 's#Location: ([a-z0-9]*)#\1#p'
}

_foreign_add_random_author_to_content_item() {
  local tmp_file=$1
  local content_item_uri=$2

  _foreign_add_random_author_to_xml "${tmp_file}"
  curl \
    --silent \
    --user "${http_auth}" \
    --request PUT \
    --header "If-Match: *" \
    --header "Content-Type: application/atom+xml; type=entry" \
    --upload-file "${tmp_file}" \
    "${content_item_uri}"
}

_foreign_add_random_author_to_xml() {
  local tmp_file=$1
  random_author_name=$(_foreign_random_author_name)
  random_author_uri=$(_foreign_random_author_uri)

  xmlstarlet \
    ed -P --inplace \
    -N a="http://www.w3.org/2005/Atom" \
    -s /a:entry -t elem -n TMP -v "" \
    -r /a:entry/TMP -v author \
    -s /a:entry/author -t elem -n name -v "${random_author_name}" \
    -s /a:entry/author -t elem -n uri -v "${random_author_uri}" \
    "${tmp_file}"
}

_foreign_random_author_name() {
  fortune | head -n 1 | cut -d' ' -f1,2 | sed 's#^[ ]##'
}

_foreign_random_author_uri() {
  printf "%s\n" "https://example.com/user/${RANDOM}"
}

_foreign_update_content_item_with_foreign_author() {
  :
}

check_can_add_foreign_author() {
  _foreign_create_content_item

}
