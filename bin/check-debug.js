// import fs from "fs";
// import path from "path";

const fs = require('fs');
const path = require('path');

function checkForDebugStatements(dir) {
  const files = fs.readdirSync(dir);
  
  for (const file of files) {
    const filePath = path.join(dir, file);
    const stats = fs.statSync(filePath);
    
    if (stats.isDirectory()) {
      checkForDebugStatements(filePath);
    } else if (file.endsWith('.js')) {
      const content = fs.readFileSync(filePath, 'utf-8');
      if (content.includes('console.log')) {
        console.error(`Debug statement found in ${filePath}`);
        process.exit(1);
      }
    }
  }
}

checkForDebugStatements('./src'); // Adjust the path as needed
