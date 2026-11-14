#!/usr/bin/env bash
# Uso: bash PRESERVACAO/scripts/preservar_fincept.sh [diretorio_saida]
# Pré-requisitos: git, sha256sum ou shasum, espaço para todo o histórico.
set -Eeuo pipefail
OUT="${1:-./fincept-backup}"
mkdir -p "$OUT"
OUT="$(cd "$OUT" && pwd)"
SRC="https://github.com/rodrigosantosmartins87-arch/FinceptTerminal.git"
MIRROR="$OUT/FinceptTerminal.git"
BUNDLE="$OUT/FinceptTerminal-completo.bundle"
RESTORE="$OUT/restore-verification.git"
if [ -e "$MIRROR" ] || [ -e "$BUNDLE" ] || [ -e "$RESTORE" ]; then
  echo "Saída já contém artefatos. Escolha um diretório vazio para não sobrescrever backups." >&2
  exit 2
fi
git clone --mirror "$SRC" "$MIRROR"
git -C "$MIRROR" remote update --prune
git -C "$MIRROR" fsck --full --no-reflogs
git -C "$MIRROR" bundle create "$BUNDLE" --all
git -C "$MIRROR" bundle verify "$BUNDLE"
git clone --mirror "$BUNDLE" "$RESTORE"
git -C "$RESTORE" fsck --full --no-reflogs
git -C "$MIRROR" show-ref | LC_ALL=C sort > "$OUT/refs-origem.txt"
git -C "$RESTORE" show-ref | LC_ALL=C sort > "$OUT/refs-restauracao.txt"
diff -u "$OUT/refs-origem.txt" "$OUT/refs-restauracao.txt"
git -C "$MIRROR" rev-parse refs/heads/main > "$OUT/main-sha.txt"
( cd "$OUT"; if command -v sha256sum >/dev/null; then sha256sum "$(basename "$BUNDLE")" > SHA256SUMS; else shasum -a 256 "$(basename "$BUNDLE")" > SHA256SUMS; fi )
echo "ESPELHO E RESTAURAÇÃO VERIFICADOS. Copie o .bundle e SHA256SUMS para uma segunda localização independente."
# Segurança: não publica conteúdo do projeto nem credenciais.
