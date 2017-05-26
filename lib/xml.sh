# -*- mode: sh; sh-shell: bash; -*-

## Lookup XPath in XML file.
## $1 :: XML file
## $2 :: XPATH xpression
lookup_in_xml_file() {
  local file=$1
  local xpath=$2

  # xmllint doesn't work too well with namespaces
  sed 's#xmlns=".*"##' "${file}" | \
    xmllint --xpath "${xpath}" -
}

## $1 :: file
## $2 :: xpath
xml_xpath() {
  local file=$1
  local xpath=$2

  xmlstarlet \
    sel \
    -N a="http://www.w3.org/2005/Atom" \
    -N g="http://xmlns.escenic.com/2015/layout-group" \
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
    -N g="http://xmlns.escenic.com/2015/layout-group" \
    -N v="http://www.vizrt.com/types" \
    -u "${xpath}" \
    -v "${value}" \
    "${file}"
}
