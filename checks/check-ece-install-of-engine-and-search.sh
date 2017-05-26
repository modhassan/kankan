#! /usr/bin/env bash

check_ece_install_have_installed_engine_files() {
  local -a files=(
    /etc/default/ece
    /etc/escenic/ece-engine1.conf
    /etc/escenic/ece.conf
    /etc/escenic/engine/common/security/jaas.config
    /etc/escenic/engine/common/security/java.policy
    /etc/init.d/ece
    /opt/tomcat-engine1
    /opt/tomcat-engine1/escenic/lib
    /var/cache/escenic
    /var/lib/escenic
    /var/log/escenic
    /var/run/escenic
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

check_ece_install_have_installed_search_files() {
  local -a files=(
    /etc/default/ece
    /etc/escenic/ece-search1.conf
    /etc/escenic/ece.conf
    /etc/escenic/solr/editorial/schema.xml
    /etc/escenic/solr/presentation/schema.xml
    /etc/init.d/ece
    /etc/init.d/solr
    /opt/solr
    /opt/tomcat-search1
    /opt/tomcat-search1/escenic/lib
    /var/cache/escenic
    /var/lib/escenic
    /var/lib/escenic/solr/editorial/core.properties
    /var/lib/escenic/solr/presentation/core.properties
    /var/log/escenic
    /var/run/escenic
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

## $1 :: dir of escenic/lib
_check_ece_install_no_duplicates() {
  local escenic_lib_dir=$1

  if [ ! -d "${escenic_lib_dir}" ]; then
    return
  fi

  local list=
  list=$(find "${escenic_lib_dir}" -name "*.jar" |
    sed "s#${escenic_lib_dir}/##" |
    sort |
    sed 's#[0-9]##g' |
    sed 's#develop-SNAPSHOT##' |
    sed 's#..-.jar##')

  declare -A _errors

  for el in ${list}; do
    local count=
    count=$(grep -c "${el}" <<< "${list}")
    if [ "${count}" -gt 1 ]; then
      _errors["${el}"]=$count
    fi
  done

  for el in "${!_errors[@]}"; do
    local fn_base=${el//\./}
    fn_base=${fn_base//jar}
    flag_error "Duplicates found:" $(ls "${escenic_lib_dir}/${fn_base}"*)
  done
}

check_ece_install_no_duplicates() {
  local engine_tomcat_dir=${engine_tomcat_dir-/opt/tomcat-engine1}
  local escenic_lib_dir="${engine_tomcat_dir}/escenic/lib"

  _check_ece_install_no_duplicates "${escenic_lib_dir}"

  local search_tomcat_dir=${search_tomcat_dir-/opt/tomcat-search1}
  escenic_lib_dir="${search_tomcat_dir}/escenic/lib"
  _check_ece_install_no_duplicates "${escenic_lib_dir}"
}
