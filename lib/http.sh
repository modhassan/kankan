# Emacs: -*- mode: sh; sh-shell: bash; -*-

## $1 :: uri
## $2 :: HTTP auth
## $3 :: HTTP header name
get_http_header_from_uri() {
  local uri=$1
  local http_auth=$2
  local http_header=$3
  local result=
  result=$(
    curl \
      --silent \
      --head \
      --user "${http_auth}" \
      "${uri}" 2>&1 |
      sed -n -r "s#^${http_header}[:] (.*)#\1#ip")


  # We get some nonsense character at the end because of standard
  # error/out redirect. Removing it here.
  local end=$(( ${#result} - 1 ))

  if [ "${end}" -gt 0 ]; then
    result="${result:0:${end}}"
  else
    result=${result}
  fi

  echo "${result}"
}
