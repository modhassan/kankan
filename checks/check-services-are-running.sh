# Emacs: -*- mode: sh; sh-shell: bash; -*-

## One entry for each of the ports you want to check in your
## ~/.kankan.conf:
##
## declare -ax service_list=(
##   "semantic-enrichment-service"
##   "content-duplication-service"
##   "sse-proxy"
##   "mysql"
##   "ece"
## )

check_services_are_running() {
  for service in "${service_list[@]}"; do
    ((number_of_tests++))

    ${service} status | grep -o '[0-9:]*' &> /dev/null || {
        flag_error "Service ${service} isn't running"
    }

    if [ "${verbose-0}" -eq 1 ]; then
      printf "%s\n" "Service ${service} is running"
    else
      echo -n "."
    fi

  done
}
