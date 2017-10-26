#! /usr/bin/env bash

check_semantic_setup_have_required_files() {
  local -a files=(
    /etc/escenic/semantic-enrichment-service/semantic-enrichment-service.yaml
    /etc/nginx/sites-available/semantic
    /etc/escenic/${cue}/semantic.yml
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

check_sermantic_service_status(){
   semantic-enrichment-service status | grep -o '[0-9:]*' &> /dev/null || {
      flag_error "semantic-enrichment-service service isn't running"
   }

   if [ "${verbose-0}" -eq 1 ]; then
     printf "%s\n" "semantic-enrichment-service service is running"
   else
     echo -n "."
   fi
}
