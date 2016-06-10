set -e
export ARCH=arm
#export CC=arm-linux-gnueabihf-gcc-4.7
export CROSS_COMPILE=arm-linux-gnueabihf-
cd linux-sunxi

cp ../cubietruck_defconfig .config
make -j`getconf _NPROCESSORS_ONLN` uImage modules | grep -E 'function | Image | Created |warning | error'
cd ..
