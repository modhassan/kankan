# -*- mode: sh; sh-shell: bash; -*-

##          author: torstein@escenic.com
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

check_cache_varnish_conf_is_valid() {
  local file=/etc/varnish/default.vcl
  /usr/sbin/varnishd -C -f "${file}" &> /dev/null || {
    flag_error "Varnish configuration is invalid: ${file}"
  }
}
