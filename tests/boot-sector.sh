#!/usr/bin/env bash
set -euo pipefail

image_path="${1:-build/simple-os.img}"
expected_message="Simple OS boot sector OK"

if [ ! -f "$image_path" ]; then
  echo "Imagem de arranque não encontrada: $image_path" >&2
  exit 1
fi

if [ "$(stat -c%s "$image_path")" -ne 512 ]; then
  echo "A imagem de arranque deve ter exatamente 512 bytes." >&2
  exit 1
fi

signature="$(od -An -tx1 -j 510 -N 2 "$image_path" | tr -d '[:space:]')"
if [ "$signature" != "55aa" ]; then
  echo "A assinatura BIOS 0xAA55 não foi encontrada." >&2
  exit 1
fi

debug_log="$(mktemp)"
trap 'rm -f "$debug_log"' EXIT

set +e
qemu_output="$(timeout 3 qemu-system-i386 \
  -drive "format=raw,file=$image_path,if=floppy" \
  -display none \
  -serial none \
  -monitor none \
  -debugcon "file:$debug_log" \
  -global isa-debugcon.iobase=0xe9 \
  -no-reboot \
  -no-shutdown 2>&1)"
qemu_status=$?
set -e

if [ "$qemu_status" -ne 0 ] && [ "$qemu_status" -ne 124 ]; then
  echo "$qemu_output" >&2
  echo "O QEMU terminou com estado inesperado: $qemu_status" >&2
  exit "$qemu_status"
fi

if ! grep -Fq "$expected_message" "$debug_log"; then
  cat "$debug_log" >&2
  echo "$qemu_output" >&2
  echo "O sector de arranque não emitiu a mensagem esperada." >&2
  exit 1
fi

echo "Boot test passed: $expected_message"
