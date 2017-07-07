# Emacs: -*- mode: sh; sh-shell: bash; -*-

## One entry for each of the ports you want to check in your
## ~/.kankan.conf:
##
## declare -ax port_list=(
##   "8090"
##   "8082"
##   "5006"
## )

check_port_list_is_running() {
  for port in "${port_list[@]}"; do
    ((number_of_tests++))

    netstat -nlp | grep -c ${port} &> /dev/null || {
        flag_error "Port ${port} isn't running"
    }

    if [ "${verbose-0}" -eq 1 ]; then
      printf "%s\n" "Port ${port} is running"
    else
      echo -n "."
    fi

  done
}
