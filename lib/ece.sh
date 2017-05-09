# Emacs: -*- mode: sh; sh-shell: bash; -*-

## $1 :: ws_base_url
## $2 :: http_auth
get_ece_root_section_uri() {
  local ws_base_url=$1
  local http_auth=$2

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

## $1 :: ws_base_url
## $2 :: http_auth
get_ece_section_lists_uri() {
  local ws_base_url=$1
  local http_auth=$2

  local sub_section_uri=
  sub_section_uri=$(get_ece_root_section_uri "${ws_base_url}" "${http_auth}")

  local xpath='/feed/entry/link[@rel="http://www.vizrt.com/types/relation/lists" and @type="application/atom+xml"]/@href'
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
