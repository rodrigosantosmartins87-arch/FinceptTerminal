#!/usr/bin/env bash
# Requer git, Git LFS, python3, sha256sum, tar. Nunca sobrescreve uma captura.
set -Eeuo pipefail
OUT="${1:-./fincept-backup}"
mkdir -p "$OUT"
OUT="$(cd "$OUT" && pwd)"
if [ -n "$(ls -A "$OUT")" ]; then echo "Escolha um diretorio vazio." >&2; exit 2; fi
git clone --mirror https://github.com/rodrigosantosmartins87-arch/FinceptTerminal.git "$OUT/mirror.git"
git -C "$OUT/mirror.git" cat-file -e 68691b7577ce642009cdf2c1b4b0766ca9e37999^{commit}
git -C "$OUT/mirror.git" fsck --full --no-reflogs
git -C "$OUT/mirror.git" bundle create "$OUT/FinceptTerminal-completo.bundle" --all
git -C "$OUT/mirror.git" bundle verify "$OUT/FinceptTerminal-completo.bundle"
git clone --mirror "$OUT/FinceptTerminal-completo.bundle" "$OUT/restaurado.git"
git -C "$OUT/restaurado.git" fsck --full --no-reflogs
git -C "$OUT/mirror.git" show-ref | LC_ALL=C sort > "$OUT/refs-mirror.txt"
git -C "$OUT/restaurado.git" show-ref | LC_ALL=C sort > "$OUT/refs-restaurado.txt"
diff -u "$OUT/refs-mirror.txt" "$OUT/refs-restaurado.txt"
test "$(git -C "$OUT/mirror.git" symbolic-ref HEAD)" = "$(git -C "$OUT/restaurado.git" symbolic-ref HEAD)"
git -C "$OUT/mirror.git" lfs ls-files --all --json > "$OUT/lfs-inventory.json"
if ! git -C "$OUT/mirror.git" lfs fetch --all > "$OUT/lfs-fetch.log" 2>&1; then
  git -C "$OUT/mirror.git" remote add upstream https://github.com/Fincept-Corporation/FinceptTerminal.git
  git -C "$OUT/mirror.git" lfs fetch --all upstream >> "$OUT/lfs-fetch.log" 2>&1 || true
fi
cd "$OUT"
python3 - <<'PY'
import json, pathlib, hashlib
objects={f["oid"]:f for f in json.load(open("lfs-inventory.json"))["files"]}
missing=[]; corrupt=[]; valid=[]
for oid,f in objects.items():
    p=pathlib.Path("mirror.git/lfs/objects")/oid[:2]/oid[2:4]/oid
    if not p.exists(): missing.append({"oid":oid,"name":f["name"],"size":f["size"]})
    elif hashlib.sha256(p.read_bytes()).hexdigest()!=oid: corrupt.append(oid)
    else: valid.append(oid)
pathlib.Path("lfs-status.json").write_text(json.dumps({"unique":len(objects),"missing":missing,"corrupt":corrupt,"valid":valid},indent=2))
pathlib.Path("BACKUP-STATUS.txt").write_text("GIT_OK_LFS_INCOMPLETE\n" if missing or corrupt else "GIT_AND_LFS_OK\n")
PY
if [ -d mirror.git/lfs/objects ]; then tar -czf FinceptTerminal-lfs.tar.gz -C mirror.git/lfs objects; fi
sha256sum FinceptTerminal-completo.bundle > SHA256SUMS
if [ -f FinceptTerminal-lfs.tar.gz ]; then sha256sum FinceptTerminal-lfs.tar.gz >> SHA256SUMS; fi
sha256sum -c SHA256SUMS
echo "Historico Git restaurado; estado: $(cat BACKUP-STATUS.txt). Guarde copia em outro dispositivo/provedor."
echo "Este script nao preserva wiki, issues ou arquivos de releases."
test "$(cat BACKUP-STATUS.txt)" = GIT_AND_LFS_OK
