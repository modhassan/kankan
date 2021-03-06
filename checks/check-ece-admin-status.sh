# Emacs: -*- mode: sh; sh-shell: bash; -*-

_ece_admin_on_aws() {
  uname -r | grep -q aws$
}

check_that_escenic_admin_reports_all_green() {
  for el in "${!ece_instance_host_port_and_http_auth_map[@]}"; do
    ((number_of_tests++))
    local host_and_port="${el}"
    local http_auth="${ece_instance_host_port_and_http_auth_map[${el}]}"

    local uri="http://${host_and_port}/escenic-admin/status.jsp?tests=all"

    local number_of_failed_tests=0
    number_of_failed_tests=$(curl -s "${uri}" | grep -c images/red.gif)

    if _ece_admin_on_aws; then
      local ignore_tests=0
      ignore_tests=$(
        curl -s "${uri}" |
          grep -A 1 images/red.gif |
          grep -c  UnknownHostException)
      number_of_failed_tests=$((number_of_failed_tests - ignore_tests))
    fi

    if [ "${number_of_failed_tests}" -gt 0 ]; then
      flag_error "There are conf errors, check ${uri}"
    fi

    echo -n "."
  done
}
