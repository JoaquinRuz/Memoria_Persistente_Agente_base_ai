#!/bin/bash

# Script para importar contenido de repositorios de referencia
# Importa system prompts y Claude Skills de los repositorios especificados

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMP_DIR="/tmp/llms_prompts_import_$$"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Importador de Prompts para LLMs ===${NC}\n"

# Crear directorio temporal
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Repositorios a importar
SYSTEM_PROMPTS_REPO="https://github.com/x1xhlol/system-prompts-and-models-of-ai-tools.git"
CLAUDE_SKILLS_REPO="https://github.com/ComposioHQ/awesome-claude-skills.git"

echo -e "${YELLOW}Clonando repositorios...${NC}"

# Clonar repositorio de system prompts
if [ -d "system-prompts-repo" ]; then
  echo "  - Limpiando clon anterior de system-prompts..."
  rm -rf system-prompts-repo
fi
echo "  - Clonando system-prompts-and-models-of-ai-tools..."
git clone --depth 1 "$SYSTEM_PROMPTS_REPO" system-prompts-repo || {
  echo -e "${RED}Error: No se pudo clonar el repositorio de system prompts${NC}"
  exit 1
}

# Clonar repositorio de Claude Skills
if [ -d "claude-skills-repo" ]; then
  echo "  - Limpiando clon anterior de claude-skills..."
  rm -rf claude-skills-repo
fi
echo "  - Clonando awesome-claude-skills..."
git clone --depth 1 "$CLAUDE_SKILLS_REPO" claude-skills-repo || {
  echo -e "${RED}Error: No se pudo clonar el repositorio de Claude Skills${NC}"
  exit 1
}

echo -e "\n${YELLOW}Importando system prompts...${NC}"

# Función para mapear nombres de carpetas
map_system_prompt_name() {
  case "$1" in
    "Cursor Prompts")
      echo "Cursor"
      ;;
    "Devin AI")
      echo "Devin-AI"
      ;;
    "Claude Code")
      echo "Claude-Code"
      ;;
    "Windsurf")
      echo "Windsurf"
      ;;
    "v0 Prompts and Tools")
      echo "v0"
      ;;
    "Replit")
      echo "Replit"
      ;;
    "VSCode Agent")
      echo "VSCode-Agent"
      ;;
    "Trae")
      echo "Trae"
      ;;
    "Perplexity")
      echo "Perplexity"
      ;;
    "Cluely")
      echo "Cluely"
      ;;
    "Xcode")
      echo "Xcode"
      ;;
    "NotionAi")
      echo "NotionAI"
      ;;
    "Orchids.app")
      echo "Orchids"
      ;;
    "Junie")
      echo "Junie"
      ;;
    "Kiro")
      echo "Kiro"
      ;;
    "Warp.dev")
      echo "Warp"
      ;;
    "Z.ai Code")
      echo "Z-ai-Code"
      ;;
    "Qoder")
      echo "Qoder"
      ;;
    "Augment Code")
      echo "Augment-Code"
      ;;
    "Lovable")
      echo "Lovable"
      ;;
    "Same.dev")
      echo "Same-dev"
      ;;
    "CodeBuddy Prompts")
      echo "CodeBuddy"
      ;;
    "Comet Assistant")
      echo "Comet"
      ;;
    "Manus Agent Tools & Prompt")
      echo "Manus"
      ;;
    "Open Source prompts")
      echo "Open-Source"
      ;;
    *)
      echo "$1"
      ;;
  esac
}

cd system-prompts-repo
for folder in */; do
  folder_name="${folder%/}"
  
  # Saltar carpetas especiales
  if [[ "$folder_name" == ".github" ]] || [[ "$folder_name" == "assets" ]] || [[ "$folder_name" == "dia" ]] || [[ "$folder_name" == "README.md" ]]; then
    continue
  fi
  
  target_name=$(map_system_prompt_name "$folder_name")
  target_path="$REPO_ROOT/system-prompts/$target_name"
  
  if [ -n "$target_name" ] && [ -d "$folder" ]; then
    echo "  - Importando $folder_name -> $target_name"
    mkdir -p "$target_path"
    # Copiar contenido, excluyendo .git
    if command -v rsync &> /dev/null; then
      rsync -av --exclude='.git' "$folder" "$target_path/" 2>/dev/null || cp -r "$folder"* "$target_path/" 2>/dev/null || true
    else
      cp -r "$folder"* "$target_path/" 2>/dev/null || true
    fi
  fi
done

echo -e "\n${YELLOW}Importando Claude Skills...${NC}"

cd "$TEMP_DIR/claude-skills-repo"

# Función para obtener categoría de un skill
get_skill_category() {
  case "$1" in
    "artifacts-builder"|"changelog-generator"|"mcp-builder"|"webapp-testing")
      echo "Development"
      ;;
    "brand-guidelines"|"competitive-ads-extractor"|"domain-name-brainstormer"|"internal-comms"|"lead-research-assistant")
      echo "Business"
      ;;
    "file-organizer"|"invoice-organizer"|"raffle-winner-picker")
      echo "Productivity"
      ;;
    "content-research-writer"|"meeting-insights-analyzer")
      echo "Communication"
      ;;
    "canvas-design"|"image-enhancer"|"slack-gif-creator"|"theme-factory"|"video-downloader")
      echo "Creative"
      ;;
    *)
      echo ""
      ;;
  esac
}

# Lista de skills ya procesados
processed_skills=""

# Importar skills con categorías conocidas
for skill_folder in */; do
  skill_name="${skill_folder%/}"
  
  # Saltar carpetas especiales
  if [[ "$skill_name" == ".claude-plugin" ]] || [[ "$skill_name" == ".github" ]] || [[ "$skill_name" == "README.md" ]]; then
    continue
  fi
  
  category=$(get_skill_category "$skill_name")
  
  if [ -n "$category" ] && [ -d "$skill_folder" ]; then
    target_path="$REPO_ROOT/claude-skills/$category/$skill_name"
    echo "  - Importando $skill_name -> $category/$skill_name"
    mkdir -p "$target_path"
    if command -v rsync &> /dev/null; then
      rsync -av --exclude='.git' "$skill_folder" "$target_path/" 2>/dev/null || cp -r "$skill_folder"* "$target_path/" 2>/dev/null || true
    else
      cp -r "$skill_folder"* "$target_path/" 2>/dev/null || true
    fi
    processed_skills="$processed_skills|$skill_name|"
  fi
done

# Importar skills sin categoría específica en Development por defecto
for skill_folder in */; do
  skill_name="${skill_folder%/}"
  
  if [[ "$skill_name" == ".claude-plugin" ]] || [[ "$skill_name" == ".github" ]] || [[ "$skill_name" == "README.md" ]]; then
    continue
  fi
  
  # Si ya fue procesado, saltar
  if [[ "$processed_skills" == *"|$skill_name|"* ]]; then
    continue
  fi
  
  # Si es un directorio y tiene SKILL.md, importar a Development
  if [ -d "$skill_folder" ] && [ -f "$skill_folder/SKILL.md" ]; then
    target_path="$REPO_ROOT/claude-skills/Development/$skill_name"
    echo "  - Importando $skill_name -> Development/$skill_name (categoría por defecto)"
    mkdir -p "$target_path"
    if command -v rsync &> /dev/null; then
      rsync -av --exclude='.git' "$skill_folder" "$target_path/" 2>/dev/null || cp -r "$skill_folder"* "$target_path/" 2>/dev/null || true
    else
      cp -r "$skill_folder"* "$target_path/" 2>/dev/null || true
    fi
  fi
done

echo -e "\n${YELLOW}Limpiando archivos temporales...${NC}"
cd "$REPO_ROOT"
rm -rf "$TEMP_DIR"

echo -e "\n${GREEN}✓ Importación completada${NC}"
echo -e "${YELLOW}Ejecuta 'node scripts/generate-index.js' para actualizar el índice${NC}"
