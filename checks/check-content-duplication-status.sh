#! /usr/bin/env bash

check_content_duplication_setup_have_required_files() {
  local -a files=(
    /etc/escenic/content-duplication-service-${cue_content_duplication_enrichment_service_version}/content-duplication-service.yaml
    /etc/nginx/sites-available/duplication
    /etc/escenic/${cue}/content-duplication-service.yml
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

check_content_duplication_service_status(){
   content-duplication-service status | grep -o '[0-9:]*' &> /dev/null || {
      flag_error "content-duplication-service service isn't running"
   }

   if [ "${verbose-0}" -eq 1 ]; then
     printf "%s\n" "content-duplication-service service is running"
   else
     echo -n "."
   fi
}
