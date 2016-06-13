set -e
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
cd linux-sunxi

cp ../$1 .config
make -j`getconf _NPROCESSORS_ONLN` uImage modules | grep -E 'function | Image | Created |warning | error'
cd ..