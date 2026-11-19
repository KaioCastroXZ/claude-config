# claude-config

Configuração pessoal do Claude Code (skills e agentes), para instalar em qualquer máquina.

## Instalar (nova máquina)

Requisitos: Node.js >= 18 e git.

```bash
git clone https://github.com/KaioCastroXZ/claude-config.git ~/claude-config
cd ~/claude-config
./install.sh --dry-run   # mostra o que faria
./install.sh             # instala de fato
```

Reinicie o Claude Code depois. Pode rodar o `install.sh` de novo para atualizar.

## Estrutura

- `skills-externas.txt` — skills de terceiros (repositório + nome), instaladas com `npx skills add ... -g`.
- `skills/<nome>/SKILL.md` — skills próprias; o script liga em `~/.claude/skills/`.
- `agents/<nome>.md` — agentes próprios; o script liga em `~/.claude/agents/`.

## Adicionar algo

- Skill externa: nova linha em `skills-externas.txt`, depois `./install.sh`.
- Skill ou agente próprio: criar o arquivo na pasta, depois `./install.sh`.

## Dicas para site menos "cara de IA"

1. Dê uma referência concreta (print, link ou Figma).
2. Defina uma direção estética ("brutalista", "impressão anos 70"), não "moderno e bonito".
3. Animação em poucos momentos de impacto (hero, revelação no scroll).
4. Fontes e paleta próprias.

Não colocar aqui skills/agentes com dados de cliente, senhas ou regras internas de empresa.
