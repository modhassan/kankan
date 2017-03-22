#! /usr/bin/env bash

check_ece_install_have_installed_analysis_engine() {
  if [ ! -d /usr/share/escenic/escenic-analysis-engine ]; then
    return
  fi

  local -a files=(
    /etc/escenic/analysis/logger.cfg
    /etc/escenic/analysis/qs.cfg
    /etc/escenic/analysis/reports.cfg
    /opt/tomcat-analysis1/conf/context.xml
    /opt/tomcat-analysis1/conf/server.xml
    /opt/tomcat-analysis1/webapps/analysis-logger
    /opt/tomcat-analysis1/webapps/analysis-qs
    /opt/tomcat-analysis1/webapps/analysis-reports
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

check_ece_install_have_installed_analysis_valid_app_conf() {
  local app_xml_files=(
    /opt/tomcat-analysis1/conf/server.xml
    /opt/tomcat-analysis1/conf/context.xml
  )

  local file=
  for file in "${app_xml_files[@]}"; do
    if [ ! -e "${file}" ]; then
      continue
    fi

    ((number_of_tests++))
    xmllint --format "${file}" &> /dev/null || {
      flag_error "Should be well formed XML: ${file}"
    }
  done

}

_run_sql_mysql() {
  local sql=$1

  mysql \
    -u "${analysis_db_user}" \
    -p"${analysis_db_password}" "${analysis_db_schema}" \
    -e "${sql}" &> /dev/null
}

check_ece_install_have_set_up_analysis_db_tables() {
  if [[ -n "${analysis_db_user}" &&
          -n "${analysis_db_password}" &&
          -n "${analysis_db_schema}" ]]; then


    for table in Pageview PageviewMeta; do
      local sql="select count(*) from ${table};"
      _run_sql_mysql "${sql}" || {
        flag_error "Should have set up DB with schema ${analysis_db_schema} on ${HOSTNAME}"
      }
    done
  fi
}
