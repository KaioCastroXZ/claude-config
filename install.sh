#!/usr/bin/env bash
# Instala as skills externas (skills-externas.txt) e liga as skills/agentes
# próprios deste repositório em ~/.claude. Pode rodar de novo à vontade.
# Uso: ./install.sh [--dry-run]
set -euo pipefail

DRY=0
[[ "${1:-}" == "--dry-run" ]] && DRY=1

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

run() {
  if (( DRY )); then echo "[dry-run] $*"; else "$@"; fi
}

command -v npx >/dev/null || { echo "Erro: npx não encontrado. Instale o Node.js (>= 18)." >&2; exit 1; }

echo "==> Skills externas"
falhas=0
while read -r repo skill _ <&3; do
  [[ -z "${repo}" || "${repo}" == \#* ]] && continue
  [[ -z "${skill}" ]] && { echo "Linha inválida (falta o nome da skill): ${repo}" >&2; falhas=$((falhas+1)); continue; }
  echo "-> ${repo} :: ${skill}"
  if ! run npx -y skills add "${repo}" --skill "${skill}" --agent claude-code -g -y; then
    echo "   FALHOU: ${repo} ${skill}" >&2
    falhas=$((falhas+1))
  fi
done 3< "${DIR}/skills-externas.txt"

# Liga (symlink) as skills e agentes próprios; não sobrescreve o que já existe.
ligar() {
  local origem="$1" destino="$2"
  if [[ -e "${destino}" || -L "${destino}" ]]; then
    if [[ "$(readlink -f "${destino}")" == "$(readlink -f "${origem}")" ]]; then return; fi
    echo "   já existe, mantido: ${destino}" >&2; return
  fi
  run ln -s "${origem}" "${destino}"
  echo "   ligado: ${destino}"
}

echo "==> Skills e agentes próprios"
run mkdir -p "${CLAUDE_DIR}/skills" "${CLAUDE_DIR}/agents"
for d in "${DIR}"/skills/*/; do
  [[ -f "${d}SKILL.md" ]] && ligar "${d%/}" "${CLAUDE_DIR}/skills/$(basename "${d}")"
done
for f in "${DIR}"/agents/*.md; do
  [[ -f "${f}" ]] && ligar "${f}" "${CLAUDE_DIR}/agents/$(basename "${f}")"
done

echo
if (( falhas )); then
  echo "Concluído com ${falhas} falha(s). Veja as mensagens acima."; exit 1
fi
echo "Concluído. Reinicie o Claude Code para carregar as skills."
