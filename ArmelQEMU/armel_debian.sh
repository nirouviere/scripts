#!/bin/sh

usage () {
	cat << EOF >&1

usage: $0 [-l]
	-l    Launch VM
EOF
}

ARMEL_QCOW2_URL="https://people.debian.org/~aurel32/qemu/armel/debian_wheezy_armel_standard.qcow2"
ARMEL_QCOW2="${ARMEL_QCOW2_URL##*/}"

ARMEL_KERNEL_URL="https://people.debian.org/~aurel32/qemu/armel/vmlinuz-3.2.0-4-versatile"
ARMEL_KERNEL="${ARMEL_KERNEL_URL##*/}"

ARMEL_INITRAMFS_URL="https://people.debian.org/~aurel32/qemu/armel/initrd.img-3.2.0-4-versatile"
ARMEL_INITRAMFS="${ARMEL_INITRAMFS_URL##*/}"

ARMEL_QCOW2_DEFAULT="debian_DEFAULT.qcow2"
ARMEL_KERNEL_DEFAULT="vmlinuz_DEFAULT"
ARMEL_INITRAMFS_DEFAULT="initrd.img-DEFAULT"

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

if [[ $1 == "-l" ]]; then
	qemu-system-arm -M versatilepb \
		-kernel vmlinuz-DEFAULT \
		-initrd initrd.img-DEFAULT \
		-hda debian_DEFAULT.qcow2 \
		-append "root=/dev/sda1"
else
	usage
	exit 1
fi
