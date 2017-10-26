#! /usr/bin/env bash

check_drop_trigger_setup_have_required_files() {
  local -a files=(
    /etc/escenic/cue-web-2.5/drop-trigger.yml
    /etc/nginx/default-site/nginx_trigger.conf
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

check_drop_trigger_urls(){
  local -a drop_trigger_url_list=(
      http://${ece_domain_name}/NewsgateImageImport
      http://${ece_domain_name}/NewsgateImageImport
  )
  for url in "${drop_trigger_url_list[@]}"; do
      ((number_of_tests++))

      curl --connect-timeout 2 --silent --head "${url}" |
        egrep "^HTTP.* (200|301|302|405)" > /dev/null || {
        flag_error "Couldn't GET ${url}"
      }

      if [ "${verbose-0}" -eq 1 ]; then
        printf "%s\n" "GET ${url} succeeded"
      else
        echo -n "."
      fi

   done
}


