#! /usr/bin/env bash

check_ece_install_have_installed_publication() {
  local required_count=1
  local ece_user=escenic

  local publication_count=0
  publication_count=$(
    su - "${ece_user}" -c "ece -i engine1 list-publications" |
      sed '/These are all the/d' |
      wc -l)

  if [ "${publication_count-0}" -lt "${required_count}" ]; then
    flag_error "At least ${required_count} publications should be available."
  fi
}


check_ece_install_have_installed_publication() {
  local dir=/etc/escenic/engine/common/neo/publications/
  ls "${dir}/"Pub-*.properties &> /dev/null || {
    flag_error "Should have set up Nursery conf in ${dir}"
  }
}
