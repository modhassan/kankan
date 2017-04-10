# -*- mode: sh; sh-shell: bash; -*-

##          author: torstein@escenic.com

_cache_varnish_port=80

check_cache_has_created_varnish_conf() {
  local -a files=(
    /etc/varnish/caching-policies.vcl
    /etc/varnish/cache-key.vcl
    /etc/varnish/request-cleaning.vcl
    /etc/varnish/compression.vcl
    /etc/varnish/default.vcl
    /etc/varnish/cookie-cleaner.vcl
    /etc/varnish/robots-on-beta.vcl
    /etc/varnish/varnish-hacks.vcl
    /etc/varnish/serve-stale-content.vcl
    /etc/varnish/host-specific.vcl
    /etc/varnish/access-control.vcl
    /etc/varnish/secret
    /etc/varnish/backends.vcl
    /etc/varnish/redirects.vcl
    /etc/varnish/cache-statistics.vcl
    /etc/varnish/error-pages.vcl
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

check_cache_has_installed_varnish() {
  local -a files=(
    /usr/sbin/varnishd
  )

  if [ -e /etc/redhat-release ]; then
    files=(
      "${files[@]}"
      /etc/varnish/varnish.params
    )
  elif [ -e /etc/debian_version ]; then
    files=(
      "${files[@]}"
      /etc/default/varnish
    )
  fi

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

check_cache_varnish_runs_on_correct_port() {
  netstat --tcp -4  -nlp |
    grep -w varnishd  |
    grep -w -q "${_cache_varnish_port}" || {
    flag_error "Varnish should run on port ${_cache_varnish_port}"
  }
}

check_cache_varnish_conf_is_valid() {
  local file=/etc/varnish/default.vcl
  /usr/sbin/varnishd -C -f "${file}" &> /dev/null || {
    flag_error "Varnish configuration is invalid: ${file}"
  }
}

check_cache_varnish_conf_robots_txt_for_beta() {
  local expected="User-Agent: *
Disallow /"
  local actual=
  actual=$(curl --silent --header "Host: beta.localhost" \
                http://localhost:${_cache_varnish_port}/robots.txt)

  if [[ "${expected}" != "${actual}" ]]; then
    flag_error "Varnish conf for beta.*/robots.txt is wrong"
  fi
}
