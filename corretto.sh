#!/usr/bin/env bash

set -eux

usage() {
  echo "usage: $0 [-h] [-o] [-k] version" > /dev/stderr
}

process_version() {
  local version="$1"
  case "${version}" in
	8)
	  package_prefix="java-1.8.0"
	  ;;
	11 | 15 | 16)
	  package_prefix="java-${version}"
	  ;;
	*)
	  echo "error: The valid versions are 8, 11, 15, 16. You entered ${version}" 
	  exit 1
  esac
}

add_key() {
  sudo mkdir -p "${keyringdir}"
  wget https://apt.corretto.aws/corretto.key 
  gpg --dearmor corretto.key
  sudo mv corretto.key.gpg /usr/share/keyrings/amazon-corretto-keyring.gpg
}


add_source_deb822_style() {
  cat <<-EOF > amazon-corretto.sources
	X-Repolib-Name: Amazon Corretto
	Enabled: yes
	Types: deb
	URIs: https://apt.corretto.aws
	Suites: stable
	Components: main
	signed-by: ${keyringdir}/amazon-corretto-keyring.gpg
EOF
  sudo mv amazon-corretto.sources /etc/apt/sources.list.d/
}

add_source_one_line_style() {
  cat <<-EOF > amazon-corretto.list
	deb [signed-by=${keyringdir}/amazon-corretto-keyring.gpg] https://apt.corretto.aws stable main
EOF
  sudo mv amazon-corretto.list /etc/apt/sources.list.d/
}

version=8
mode=deb822
keyringdir=/usr/share/keyrings
while getopts ":hk:o" opt; do
  case "${opt}" in
    h) 
      usage
      exit 0
      ;;
    o) 
      mode=oneline
      ;;
    k) 
      keyringdir="${OPTARG}"
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

# Process the positional argument.
shift $((OPTIND - 1))
if [ "$#" -ne 1 ]; then
  echo "error: A single positional argument, version, is required" > /dev/stderr
  echo
  usage
  exit 1
fi
version="$1"

# Add the repo and signing key.
process_version "${version}"
workdir="$(mktemp -d)"
pushd "${workdir}"
add_key
if [ "${mode}" = "deb822" ]; then
  add_source_deb822_style
else
  add_source_one_line_style
fi
popd
rm -r "${workdir}"

sudo apt -y update
sudo apt -y install "${package_prefix}"-amazon-corretto-jdk
