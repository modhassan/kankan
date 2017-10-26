#! /usr/bin/env bash

check_sse-proxy_setup_have_required_files() {
  local -a files=(
    /etc/escenic/sse-proxy/sse-proxy.yaml
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

sse_proxy_service_status(){
   sse-proxy status | grep -o '[0-9:]*' &> /dev/null || {
      flag_error "sse-proxy isn't running"
   }

   if [ "${verbose-0}" -eq 1 ]; then
     printf "%s\n" "sse-proxy is running"
   else
     echo -n "."
   fi
}
