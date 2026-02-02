/**
 * fix-entity-imports.js
 * 
 * Patches TypeORM's glob-based entity loading to use explicit imports.
 * This is required because glob patterns don't resolve correctly in DSM.
 * 
 * Auto-discovers entities from server/entity/ directory for easier upgrades.
 */

const fs = require('fs');
const pathModule = require('path');

const DATASOURCE_PATH = 'server/datasource.ts';
const ENTITY_DIR = 'server/entity';

// Discover entity files automatically
function discoverEntities() {
  const entityFiles = fs.readdirSync(ENTITY_DIR)
    .filter(f => f.endsWith('.ts') && !f.endsWith('.d.ts'));
  
  return entityFiles.map(file => {
    const name = file.replace('.ts', '');
    const content = fs.readFileSync(pathModule.join(ENTITY_DIR, file), 'utf8');
    // Detect if it's a named export (export class/const) or default export
    const isNamedExport = /export\s+(class|const)\s+\w+/.test(content) && 
                          !/export\s+default/.test(content);
    return { name, isNamedExport };
  });
}

// Main
try {
  if (!fs.existsSync(DATASOURCE_PATH)) {
    throw new Error(`File not found: ${DATASOURCE_PATH}`);
  }
  if (!fs.existsSync(ENTITY_DIR)) {
    throw new Error(`Entity directory not found: ${ENTITY_DIR}`);
  }

  const entities = discoverEntities();
  console.log(`Discovered ${entities.length} entities:`, entities.map(e => e.name).join(', '));

  // Generate import statements
  const imports = entities.map(e => 
    e.isNamedExport 
      ? `import { ${e.name} } from './entity/${e.name}';`
      : `import ${e.name} from './entity/${e.name}';`
  ).join('\n');

  const classArray = `const entityClasses = [${entities.map(e => e.name).join(', ')}];`;
  const entityImports = `\n${imports}\n\n${classArray}`;

  let code = fs.readFileSync(DATASOURCE_PATH, 'utf8');
  const originalCode = code;

  // Insert after DataSource import
  code = code.replace(
    "import { DataSource } from 'typeorm';",
    "import { DataSource } from 'typeorm';" + entityImports
  );

  // Replace glob patterns with entityClasses
  code = code.replace(/entities:\s*\['server\/entity\/\*\*\/\*\.ts'\]/g, 'entities: entityClasses');
  code = code.replace(/entities:\s*\['dist\/entity\/\*\*\/\*\.js'\]/g, 'entities: entityClasses');

  if (code === originalCode) {
    throw new Error('No replacements made - patterns may have changed in upstream');
  }

  fs.writeFileSync(DATASOURCE_PATH, code);
  console.log(`Fixed TypeORM entity imports in ${DATASOURCE_PATH}`);

} catch (err) {
  console.error('ERROR:', err.message);
  process.exit(1);
}
