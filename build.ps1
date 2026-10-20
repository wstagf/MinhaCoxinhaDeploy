# Build do site: valida os arquivos e copia tudo para a pasta dist/
$ErrorActionPreference = 'Stop'

$raiz = $PSScriptRoot
$dist = Join-Path $raiz 'dist'
$arquivos = @('index.html', 'style.css')

# 1. Confere se todos os arquivos existem
foreach ($f in $arquivos) {
  if (-not (Test-Path (Join-Path $raiz $f))) {
    throw "Arquivo obrigatorio nao encontrado: $f"
  }
}

# 2. Limpa e recria a pasta dist
if (Test-Path $dist) { Remove-Item $dist -Recurse -Force }
New-Item -ItemType Directory -Path $dist | Out-Null

# 3. Copia os arquivos
foreach ($f in $arquivos) {
  Copy-Item (Join-Path $raiz $f) $dist
}

# 4. Grava informacoes do build (commit e data)
$commit = if ($env:GITHUB_SHA) { $env:GITHUB_SHA } else { 'local' }
"commit: $commit`nbuild: $(Get-Date -Format s)" | Set-Content (Join-Path $dist 'build-info.txt')

Write-Host "Build ok -> $dist"
