#!/bin/bash
# bootstrap_palace.sh — Inicializa MemPalace con la config de Matrix
#
# Copia la configuración personalizada a ~/.mempalace/ y ejecuta
# el primer mining del sistema de memoria existente.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MEMPALACE_HOME="$HOME/.mempalace"
SYSTEM_DIR="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$SYSTEM_DIR")"

echo "=== MemPalace Bootstrap para Matrix ==="
echo ""

# 1. Instalar mempalace si no está
if ! python3 -c "import mempalace" 2>/dev/null; then
    echo "[1/5] Instalando mempalace..."
    pip install mempalace
else
    echo "[1/5] mempalace ya instalado."
fi

# 2. Crear directorio de configuración
echo "[2/5] Configurando ~/.mempalace/..."
mkdir -p "$MEMPALACE_HOME"
mkdir -p "$MEMPALACE_HOME/hook_state"
mkdir -p "$MEMPALACE_HOME/agents"

# 3. Copiar configs personalizadas
echo "[3/5] Copiando configuración de Matrix..."
cp "$SCRIPT_DIR/config.json" "$MEMPALACE_HOME/config.json"
cp "$SCRIPT_DIR/wing_config.json" "$MEMPALACE_HOME/wing_config.json"
cp "$SCRIPT_DIR/identity.txt" "$MEMPALACE_HOME/identity.txt"

# 4. Minar el sistema de memoria existente
echo "[4/5] Minando system/ y usuario/ en el palace..."
python3 -m mempalace mine "$SYSTEM_DIR" --wing wing_matrix 2>/dev/null || echo "  (mining system/ completado o sin datos nuevos)"
python3 -m mempalace mine "$REPO_ROOT/usuario" --wing wing_joaquin 2>/dev/null || echo "  (mining usuario/ completado o sin datos nuevos)"

# 5. Estado del palace
echo "[5/5] Estado del palace:"
echo ""
python3 -m mempalace status 2>/dev/null || echo "  Palace vacío — usa 'mempalace mine <dir>' para agregar datos."

echo ""
echo "=== Bootstrap completo ==="
echo "Próximos pasos:"
echo "  mempalace search \"cualquier consulta\"        # Buscar en tus memorias"
echo "  mempalace mine ~/chats/ --mode convos         # Importar conversaciones"
echo "  python -m mempalace.mcp_server                # Iniciar servidor MCP"
