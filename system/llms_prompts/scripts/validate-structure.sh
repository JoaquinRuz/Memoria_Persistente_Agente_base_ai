#!/bin/bash

# Script para validar que la estructura del repositorio cumple con los estándares

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

echo -e "${GREEN}=== Validador de Estructura del Repositorio ===${NC}\n"

# Verificar estructura de carpetas principales
echo -e "${YELLOW}Verificando estructura de carpetas...${NC}"

REQUIRED_DIRS=(
  "system-prompts"
  "claude-skills"
  "general-prompts"
  "scripts"
)

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$REPO_ROOT/$dir" ]; then
    echo -e "  ${GREEN}✓${NC} $dir/"
  else
    echo -e "  ${RED}✗${NC} $dir/ (faltante)"
    ((ERRORS++))
  fi
done

# Verificar archivos principales
echo -e "\n${YELLOW}Verificando archivos principales...${NC}"

REQUIRED_FILES=(
  "README.md"
  "INDEX.json"
  ".gitignore"
  "CONTRIBUTING.md"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ -f "$REPO_ROOT/$file" ]; then
    echo -e "  ${GREEN}✓${NC} $file"
  else
    echo -e "  ${RED}✗${NC} $file (faltante)"
    ((ERRORS++))
  fi
done

# Verificar scripts
echo -e "\n${YELLOW}Verificando scripts...${NC}"

REQUIRED_SCRIPTS=(
  "scripts/import-from-repos.sh"
  "scripts/generate-index.js"
  "scripts/validate-structure.sh"
)

for script in "${REQUIRED_SCRIPTS[@]}"; do
  if [ -f "$REPO_ROOT/$script" ]; then
    if [ -x "$REPO_ROOT/$script" ]; then
      echo -e "  ${GREEN}✓${NC} $script (ejecutable)"
    else
      echo -e "  ${YELLOW}⚠${NC} $script (no ejecutable)"
      ((WARNINGS++))
    fi
  else
    echo -e "  ${RED}✗${NC} $script (faltante)"
    ((ERRORS++))
  fi
done

# Validar estructura de Claude Skills
echo -e "\n${YELLOW}Validando estructura de Claude Skills...${NC}"

if [ -d "$REPO_ROOT/claude-skills" ]; then
  for category_dir in "$REPO_ROOT/claude-skills"/*; do
    if [ -d "$category_dir" ]; then
      category=$(basename "$category_dir")
      skill_count=0
      
      for skill_dir in "$category_dir"/*; do
        if [ -d "$skill_dir" ]; then
          skill_name=$(basename "$skill_dir")
          
          # Verificar que tenga SKILL.md
          if [ -f "$skill_dir/SKILL.md" ]; then
            ((skill_count++))
          else
            echo -e "  ${YELLOW}⚠${NC} $category/$skill_name/ (sin SKILL.md)"
            ((WARNINGS++))
          fi
        fi
      done
      
      if [ $skill_count -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} $category/ ($skill_count skills)"
      fi
    fi
  done
fi

# Validar INDEX.json
echo -e "\n${YELLOW}Validando INDEX.json...${NC}"

if [ -f "$REPO_ROOT/INDEX.json" ]; then
  if command -v node &> /dev/null; then
    if node -e "JSON.parse(require('fs').readFileSync('$REPO_ROOT/INDEX.json', 'utf8'))" 2>/dev/null; then
      echo -e "  ${GREEN}✓${NC} INDEX.json (JSON válido)"
    else
      echo -e "  ${RED}✗${NC} INDEX.json (JSON inválido)"
      ((ERRORS++))
    fi
  else
    echo -e "  ${YELLOW}⚠${NC} INDEX.json (no se pudo validar, node no disponible)"
    ((WARNINGS++))
  fi
fi

# Resumen
echo -e "\n${YELLOW}=== Resumen ===${NC}"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo -e "${GREEN}✓ Estructura válida${NC}"
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo -e "${YELLOW}⚠ Estructura válida con $WARNINGS advertencia(s)${NC}"
  exit 0
else
  echo -e "${RED}✗ Estructura inválida: $ERRORS error(es), $WARNINGS advertencia(s)${NC}"
  exit 1
fi
