#! /usr/bin/env bash

check_trello_setup_have_required_files() {
  local -a files=(
    /home/escenic/enrichment-service/conf/Configuration.yml
    /home/escenic/enrichment-service/escenic-services/escenic.conf.yml
    /home/escenic/enrichment-service/escenic-services/trello-story-planning/trello.conf.yml
    /etc/nginx/sites-available/trello
    /etc/escenic/${cue}/trello.yml
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

check_trello_service_status(){
   netstat -nlp | grep -w ${port} &> /dev/null|| {
      flag_error "trello service isn't running"
   }

   if [ "${verbose-0}" -eq 1 ]; then
     printf "%s\n" "trello service is running"
   else
     echo -n "."
   fi
}
