#!/usr/bin/env bash
# Build do site (Linux): valida os arquivos e copia tudo para a pasta dist/
set -euo pipefail

cd "$(dirname "$0")"
arquivos=(index.html style.css)

# 1. Confere se todos os arquivos existem
for f in "${arquivos[@]}"; do
  [ -f "$f" ] || { echo "Arquivo obrigatorio nao encontrado: $f" >&2; exit 1; }
done

# 2. Limpa e recria a pasta dist
rm -rf dist
mkdir dist

# 3. Copia os arquivos
cp "${arquivos[@]}" dist/

# 4. Grava informacoes do build (commit e data)
printf 'commit: %s\nbuild: %s\n' "${GITHUB_SHA:-local}" "$(date -Iseconds)" > dist/build-info.txt

echo "Build ok -> $(pwd)/dist"
