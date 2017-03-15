# -*- mode: sh; sh-shell: bash; -*-

## author: torstein@escenic.com
check_assembly_tool_has_files() {
  local -a files=(
    /usr/share/escenic/escenic-assemblytool/assemble.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/layers/addon/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/layers/addon/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/layers/common/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/layers/common/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/layers/default/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/layers/default/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/layers/family/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/layers/family/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/layers/host/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/layers/host/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/Nursery.properties
    /usr/share/escenic/escenic-assemblytool/conf/bootstrap-skeleton/README.txt
    /usr/share/escenic/escenic-assemblytool/conf/layers/addon/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/addon/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/common/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/common/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/default/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/default/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/environment/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/environment/host/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/environment/host/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/environment/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/family/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/family/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/host/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/host/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/instance/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/instance/host/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/instance/host/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/instance/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/server/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/server/host/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/server/host/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/server/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/vosa/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/vosa/host/Files.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/vosa/host/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/layers/vosa/Layer.properties
    /usr/share/escenic/escenic-assemblytool/conf/Nursery.properties
    /usr/share/escenic/escenic-assemblytool/conf/README.txt
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
