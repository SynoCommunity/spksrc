const { fork } = require('node:child_process');
const path = require('path');

const mainjs = path.resolve(__dirname, '..', 'share', 'immich', 'dist', 'main.js');
const child = fork(mainjs, process.argv.slice(2));

process.on('SIGTERM', () => child.kill('SIGTERM'));
process.on('SIGINT', () => child.kill('SIGINT'));

child.on('exit', (code) => process.exit(code ?? 0));
