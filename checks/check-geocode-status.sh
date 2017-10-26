#! /usr/bin/env bash

check_geocode_setup_have_required_files() {
  local -a files=(
    /etc/escenic/${cue}/geocode.yml
    /etc/nginx/default-site/geo-code.conf
  )

  for file in "${files[@]}"; do
    ((number_of_tests++))
    test -e "${file}" || {
      flag_error "Should have created ${file}"
    }

    if [ "${verbose-0}" -eq 1 ]; then
      echo "File exists as expected: ${file}"
    else
      echo -n "."
    fi
  done
}


