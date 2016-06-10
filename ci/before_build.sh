#!/bin/bash




# advanced_patch <dest> <family> <device> <description>
#
# parameters:
# <dest>: u-boot, kernel
# <family>: u-boot: u-boot, u-boot-neo; kernel: sun4i-default, sunxi-next, ...
# <device>: cubieboard, cubieboard2, cubietruck, ...
# <description>: additional description text
#
# priority:
# $SRC/userpatches/<dest>/<family>/<device>
# $SRC/userpatches/<dest>/<family>
# $SRC/lib/patch/<dest>/<family>/<device>
# $SRC/lib/patch/<dest>/<family>
#
advanced_patch () {

	echo "Started patching process"
	local description="patching"

	local names=()
	local dirs=("$1/igor-patch/patch/kernel/sun7i-default" "$1/dam-patch")
	echo "patch directories : ${dirs[@]}"
	# required for "for" command
	shopt -s nullglob dotglob
	# get patch file names
	for dir in "${dirs[@]}"; do
		echo $dir
		ls
		for patch in $dir/*.patch; do
			names+=($(basename $patch))
			echo ${names[0]}
			ls
		done
	done
	# remove duplicates
	local names_s=($(echo "${names[@]}" | tr ' ' '\n' | LC_ALL=C sort -u | tr '\n' ' '))
	# apply patches
	for name in "${names_s[@]}"; do
		for dir in "${dirs[@]}"; do
			if [[ -f $dir/$name ]]; then
				if [[ -s $dir/$name ]]; then
					echo $dir $name $description
					process_patch_file "$dir/$name" "$description"
				else
					echo "... $name" "skipped" "info"
				fi
				break # next name
			fi
		done
	done
}

# process_patch_file <file> <description>
#
# parameters:
# <file>: path to patch file
# <description>: additional description text
#
process_patch_file() {

	local patch=$1
	local description=$2

	# detect and remove files which patch will create
	LANGUAGE=english patch --batch --dry-run -p1 -N < $patch | grep create \
		| awk '{print $NF}' | sed -n 's/,//p' | xargs -I % sh -c 'rm %'

	# main patch command
	echo $patch $description
	patch --batch -p1 -N < $patch 

	}

#fetch patch form igor
#git clone --depth 1 -n https://github.com/igorpecovnik/lib.git igor-patch

#checkout patch fopr sun7i
cd igor-patch
#git checkout HEAD -- patch/kernel/sun7i-default/
#clone kernel
cd ..
#git clone --depth 1 -b sunxi-3.4 https://github.com/linux-sunxi/linux-sunxi.git

cd linux-sunxi
#patch
advanced_patch ".."




