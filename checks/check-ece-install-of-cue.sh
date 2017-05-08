# Emacs: -*- mode: sh; sh-shell: bash; -*-

check_cue_app_config_has_been_generated() {
  # Since we have more than one test here, we increase the counter
  # ourselves in the loop below.
  ((number_of_tests--))

  for dir in $(find /etc/escenic/cue-web-* -maxdepth 0 -type d); do
    local file="${dir}"/app.config.js
    ((number_of_tests++))

    if [ "${verbose-0}" -eq 1 ]; then
      printf "%s\n" "${file} should have been created"
    else
      printf "%s" "."
    fi

    test -e "${file}" || {
      flag_error "${file} should have been generated"
    }
  done
}

check_cue_available_on_port_80() {
  local url=http://localhost:80/cue-web/

  curl --silent --head "${url}" |
    grep -w -q '200 OK' || {
    flag_error "CUE web interface isn't available: ${url} "
  }
}

check_cue_escenic_webstudio_available_on_port_80() {
  local url=http://localhost:80/escenic/index.jsp

  curl --silent --head "${url}" |
    grep -w -q '200 OK' || {
    flag_error "Escenic web studio isn't available: ${url} "
  }
}

check_cue_escenic_webservice_available_on_port_80() {
  local url=http://localhost:80/webservice/index.xml

  curl --silent --head "${url}" |
    grep -w -q '401 Unauthorized' || {
    flag_error "Escenic webservice isn't available: ${url} "
  }
}
