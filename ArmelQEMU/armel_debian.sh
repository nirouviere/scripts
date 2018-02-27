#!/bin/sh

usage () {
	cat << EOF >&1

usage: $0 OPTIONS

OPTIONS:
    -l    Launch VM
    -i    Install VM (Basicallly, just download qcow2, initramfs and kernel from 
          https://people.debian.org/~aurel32/qemu/armel/
    -h    display this text and exit
EOF
}

install () {
	ARMEL_QCOW2_URL="https://people.debian.org/~aurel32/qemu/armel/debian_wheezy_armel_standard.qcow2"
	ARMEL_QCOW2="${ARMEL_QCOW2_URL##*/}"

	ARMEL_KERNEL_URL="https://people.debian.org/~aurel32/qemu/armel/vmlinuz-3.2.0-4-versatile"
	ARMEL_KERNEL="${ARMEL_KERNEL_URL##*/}"

	ARMEL_INITRAMFS_URL="https://people.debian.org/~aurel32/qemu/armel/initrd.img-3.2.0-4-versatile"
	ARMEL_INITRAMFS="${ARMEL_INITRAMFS_URL##*/}"

	ARMEL_QCOW2_DEFAULT="debian_DEFAULT.qcow2"
	ARMEL_KERNEL_DEFAULT="vmlinuz_DEFAULT"
	ARMEL_INITRAMFS_DEFAULT="initrd.img_DEFAULT"

	if [[ ! -f "${ARMEL_QCOW2_DEFAULT}" ]]; then
		echo "[+++] ${ARMEL_QCOW2} not found. Downloading"
		curl -o "${ARMEL_QCOW2_DEFAULT}" "${ARMEL_QCOW2_URL}"
	fi

	if [[ ! -f "${ARMEL_KERNEL_DEFAULT}" ]]; then
		echo "[+++] ${ARMEL_KERNEL} not found. Downloading"
		curl -o "${ARMEL_KERNEL_DEFAULT}" "${ARMEL_KERNEL_URL}" 
	fi

	if [[ ! -f "${ARMEL_INITRAMFS_DEFAULT}" ]]; then
		echo "[+++] ${ARMEL_INITRAMFS} not found. Downloading"
		curl -o "${ARMEL_INITRAMFS_DEFAULT}" "${ARMEL_INITRAMFS_URL}"
	fi
}

launch () {
	qemu-system-arm -M versatilepb \
		-kernel vmlinuz-DEFAULT \
		-initrd initrd.img-DEFAULT \
		-hda debian_DEFAULT.qcow2 \
		-append "root=/dev/sda1"
}


if [[ "$#" == 0 ]]; then
	usage
	exit 1
fi

case "$1" in
	"-l")
		launch
		shift 1
		;;
	"-i")
		install
		shift 1
		;;
	"-h")
		usage
		exit 0
		;;
	"*")
		usage
		exit 1
		;;
	"")
		usage
		exit 1
		;;
esac

