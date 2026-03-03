const http = require('http');
const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const WebSocket = require('ws');

const STOCKFISH_PATH = process.env.STOCKFISH_PATH || '/var/packages/stockfish/target/bin/stockfish';
const PORT = process.env.PORT || 3001;
const PUBLIC_DIR = path.join(__dirname, 'public');

// Serve static files
const server = http.createServer((req, res) => {
    let filePath = path.join(PUBLIC_DIR, req.url === '/' ? 'index.html' : req.url);
    const ext = path.extname(filePath);
    const contentTypes = {
        '.html': 'text/html',
        '.js': 'application/javascript',
        '.css': 'text/css',
        '.svg': 'image/svg+xml',
        '.png': 'image/png'
    };
    
    fs.readFile(filePath, (err, content) => {
        if (err) {
            res.writeHead(404);
            res.end('Not Found');
        } else {
            res.writeHead(200, { 'Content-Type': contentTypes[ext] || 'text/plain' });
            res.end(content);
        }
    });
});

// WebSocket server for stockfish communication
const wss = new WebSocket.Server({ server });

wss.on('connection', (ws) => {
    console.log('Client connected');
    
    // Spawn stockfish process for this connection
    const stockfish = spawn(STOCKFISH_PATH);
    
    stockfish.stdout.on('data', (data) => {
        const lines = data.toString().split('\n').filter(l => l.trim());
        lines.forEach(line => {
            ws.send(JSON.stringify({ type: 'uci', data: line }));
        });
    });
    
    stockfish.stderr.on('data', (data) => {
        console.error('Stockfish error:', data.toString());
    });
    
    ws.on('message', (message) => {
        try {
            const cmd = JSON.parse(message);
            if (cmd.type === 'uci') {
                stockfish.stdin.write(cmd.data + '\n');
            }
        } catch (e) {
            console.error('Invalid message:', e);
        }
    });
    
    ws.on('close', () => {
        console.log('Client disconnected');
        stockfish.kill();
    });
});

server.listen(PORT, () => {
    console.log(`Stockfish Web GUI running on http://localhost:${PORT}`);
});
