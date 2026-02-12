#!/usr/bin/env node

/**
 * Script para generar INDEX.json automáticamente desde la estructura de carpetas
 * Escanea el repositorio y crea un índice estructurado de todos los prompts
 */

const fs = require('fs');
const path = require('path');

const REPO_ROOT = path.join(__dirname, '..');
const INDEX_FILE = path.join(REPO_ROOT, 'INDEX.json');

/**
 * Obtiene todos los archivos en un directorio recursivamente
 */
function getAllFiles(dirPath, arrayOfFiles = []) {
  const files = fs.readdirSync(dirPath);

  files.forEach((file) => {
    const filePath = path.join(dirPath, file);
    if (fs.statSync(filePath).isDirectory()) {
      arrayOfFiles = getAllFiles(filePath, arrayOfFiles);
    } else {
      arrayOfFiles.push(filePath);
    }
  });

  return arrayOfFiles;
}

/**
 * Obtiene información de un archivo
 */
function getFileInfo(filePath) {
  const stats = fs.statSync(filePath);
  const relativePath = path.relative(REPO_ROOT, filePath);
  return {
    name: path.basename(filePath),
    path: relativePath.replace(/\\/g, '/'),
    size: stats.size,
    modified: stats.mtime.toISOString(),
  };
}

/**
 * Escanea system prompts
 */
function scanSystemPrompts() {
  const systemPromptsDir = path.join(REPO_ROOT, 'system-prompts');
  const index = {};

  if (!fs.existsSync(systemPromptsDir)) {
    return index;
  }

  const tools = fs.readdirSync(systemPromptsDir).filter((item) => {
    const itemPath = path.join(systemPromptsDir, item);
    return fs.statSync(itemPath).isDirectory();
  });

  tools.forEach((tool) => {
    const toolPath = path.join(systemPromptsDir, tool);
    const files = getAllFiles(toolPath)
      .map(getFileInfo)
      .filter((file) => !file.name.startsWith('.'));

    if (files.length > 0) {
      index[tool] = {
        path: `system-prompts/${tool}/`,
        files: files,
        description: `System prompts de ${tool}`,
        fileCount: files.length,
      };
    }
  });

  return index;
}

/**
 * Escanea Claude Skills
 */
function scanClaudeSkills() {
  const skillsDir = path.join(REPO_ROOT, 'claude-skills');
  const index = {};

  if (!fs.existsSync(skillsDir)) {
    return index;
  }

  const categories = fs.readdirSync(skillsDir).filter((item) => {
    const itemPath = path.join(skillsDir, item);
    return fs.statSync(itemPath).isDirectory();
  });

  categories.forEach((category) => {
    const categoryPath = path.join(skillsDir, category);
    const skills = fs.readdirSync(categoryPath).filter((item) => {
      const itemPath = path.join(categoryPath, item);
      return fs.statSync(itemPath).isDirectory();
    });

    if (skills.length > 0) {
      index[category] = {};

      skills.forEach((skill) => {
        const skillPath = path.join(categoryPath, skill);
        const skillFiles = getAllFiles(skillPath).map(getFileInfo);
        const skillFile = skillFiles.find((f) => f.name === 'SKILL.md');

        if (skillFile || skillFiles.length > 0) {
          index[category][skill] = {
            path: `claude-skills/${category}/${skill}/`,
            mainFile: skillFile ? 'SKILL.md' : null,
            files: skillFiles,
            fileCount: skillFiles.length,
          };
        }
      });
    }
  });

  return index;
}

/**
 * Escanea prompts generales
 */
function scanGeneralPrompts() {
  const generalPromptsDir = path.join(REPO_ROOT, 'general-prompts');
  const index = {};

  if (!fs.existsSync(generalPromptsDir)) {
    return index;
  }

  const categories = fs.readdirSync(generalPromptsDir).filter((item) => {
    const itemPath = path.join(generalPromptsDir, item);
    return fs.statSync(itemPath).isDirectory();
  });

  categories.forEach((category) => {
    const categoryPath = path.join(generalPromptsDir, category);
    const files = getAllFiles(categoryPath)
      .map(getFileInfo)
      .filter((file) => !file.name.startsWith('.'));

    if (files.length > 0) {
      index[category] = {
        path: `general-prompts/${category}/`,
        files: files,
        fileCount: files.length,
      };
    }
  });

  return index;
}

/**
 * Genera el índice completo
 */
function generateIndex() {
  console.log('Generando índice del repositorio...');

  const systemPrompts = scanSystemPrompts();
  const claudeSkills = scanClaudeSkills();
  const generalPrompts = scanGeneralPrompts();

  const systemPromptsCount = Object.keys(systemPrompts).length;
  const claudeSkillsCount = Object.values(claudeSkills).reduce(
    (sum, cat) => sum + Object.keys(cat).length,
    0
  );
  const generalPromptsCount = Object.keys(generalPrompts).length;

  const index = {
    version: '1.0.0',
    lastUpdated: new Date().toISOString().split('T')[0],
    systemPrompts: systemPrompts,
    claudeSkills: claudeSkills,
    generalPrompts: generalPrompts,
    metadata: {
      description: 'Índice estructurado de todos los prompts en el repositorio',
      totalPrompts:
        systemPromptsCount + claudeSkillsCount + generalPromptsCount,
      categories: {
        'system-prompts': systemPromptsCount,
        'claude-skills': claudeSkillsCount,
        'general-prompts': generalPromptsCount,
      },
    },
  };

  fs.writeFileSync(INDEX_FILE, JSON.stringify(index, null, 2), 'utf8');

  console.log('✓ Índice generado exitosamente');
  console.log(`  - System Prompts: ${systemPromptsCount}`);
  console.log(`  - Claude Skills: ${claudeSkillsCount}`);
  console.log(`  - General Prompts: ${generalPromptsCount}`);
  console.log(`  - Total: ${index.metadata.totalPrompts}`);
}

// Ejecutar si se llama directamente
if (require.main === module) {
  generateIndex();
}

module.exports = { generateIndex };
