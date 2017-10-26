#! /usr/bin/env bash

check_pixabay_setup_have_required_files() {
  local -a files=(
    /etc/escenic/${cue}/pixabay.yml
    /etc/nginx/default-site/pixabay.conf
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


