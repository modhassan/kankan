# Emacs: -*- mode: sh; sh-shell: bash; -*-

check_native_apr_installed() {
  local lib=libtcnative-1.so.0
  find /usr/lib* -maxdepth 3 -name "${lib}" |
    grep -q -w  "${lib}" || {
    flag_error "Apache Tomcat APR (${lib}) not installed"
  }
}

check_native_apr_tomcat_can_find_it() {
  local log=/var/log/escenic/engine1-tomcat
  grep -q "Loaded APR based Apache Tomcat Native librar" "${log}" || {
    flag_error "Tomcat cannot find the native APR library"
  }
}
