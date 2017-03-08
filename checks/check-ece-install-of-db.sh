#! /usr/bin/env bash

check_ece_install_have_installed_db_files() {
  local -a files=(
    /usr/bin/mysql
    /usr/sbin/mysqld
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
