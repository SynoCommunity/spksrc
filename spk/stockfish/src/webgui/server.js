const http = require('http');
const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const WebSocket = require('ws');

const STOCKFISH_PATH = process.env.STOCKFISH_PATH || '/var/packages/stockfish/target/bin/stockfish';
const PORT = process.env.PORT || 8300;
const PUBLIC_DIR = path.join(__dirname, 'public');
const MAX_CLIENTS = 8;

// Serve static files
const server = http.createServer((req, res) => {
    let filePath;
    try {
        const requested = decodeURIComponent((req.url || '/').split('?')[0]);
        filePath = path.resolve(PUBLIC_DIR, `.${requested === '/' ? '/index.html' : requested}`);
    } catch (e) {
        res.writeHead(400);
        res.end('Bad Request');
        return;
    }

    const relativePath = path.relative(PUBLIC_DIR, filePath);
    if (relativePath === '..' || relativePath.startsWith(`..${path.sep}`) || path.isAbsolute(relativePath)) {
        res.writeHead(404);
        res.end('Not Found');
        return;
    }

    const ext = path.extname(filePath);
    const contentTypes = {
        '.html': 'text/html',
        '.js': 'application/javascript',
        '.css': 'text/css',
        '.svg': 'image/svg+xml',
        '.png': 'image/png',
        '.ico': 'image/x-icon',
        '.mp3': 'audio/mpeg'
    };
    
    fs.readFile(filePath, (err, content) => {
        if (err) {
            res.writeHead(404, { 'Content-Type': 'text/plain', 'X-Content-Type-Options': 'nosniff' });
            res.end('Not Found');
        } else {
            const cacheable = ['.png', '.svg', '.ico', '.mp3'].includes(ext);
            res.writeHead(200, {
                'Content-Type': contentTypes[ext] || 'text/plain',
                'Content-Length': content.length,
                'Cache-Control': cacheable ? 'public, max-age=86400' : 'no-cache',
                'X-Content-Type-Options': 'nosniff'
            });
            res.end(content);
        }
    });
});

// WebSocket server for stockfish communication
const wss = new WebSocket.Server({ server, maxPayload: 1024 * 1024 });
const children = new Set();

wss.on('error', (err) => {
    console.error('WebSocket server error:', err);
});

wss.on('connection', (ws) => {
    if (wss.clients.size > MAX_CLIENTS) {
        console.warn(`Rejecting client: limit of ${MAX_CLIENTS} reached`);
        ws.close(1013, 'Too many clients');
        return;
    }

    console.log('Client connected');
    
    // Spawn stockfish process for this connection
    const stockfish = spawn(STOCKFISH_PATH);
    children.add(stockfish);

    let output = '';
    stockfish.stdout.on('data', (data) => {
        output += data.toString();
        const lines = output.split('\n');
        output = lines.pop();
        lines.filter(l => l.trim()).forEach(line => {
            if (ws.readyState === WebSocket.OPEN) {
                ws.send(JSON.stringify({ type: 'uci', data: line }));
            }
        });
    });
    
    stockfish.stderr.on('data', (data) => {
        console.error('Stockfish error:', data.toString());
    });

    stockfish.stdin.on('error', (err) => {
        console.error('Stockfish stdin error:', err);
        stockfish.kill();
        ws.close();
    });

    stockfish.on('error', (err) => {
        console.error('Unable to start Stockfish:', err);
        ws.close();
    });

    stockfish.on('close', () => {
        children.delete(stockfish);
    });
    
    ws.on('message', (message) => {
        try {
            const cmd = JSON.parse(message);
            if (cmd.type === 'uci' && typeof cmd.data === 'string' &&
                stockfish.stdin.writable && !stockfish.stdin.destroyed) {
                try {
                    stockfish.stdin.write(cmd.data + '\n');
                } catch (e) {
                    console.error('Unable to write to Stockfish:', e);
                    stockfish.kill();
                    ws.close();
                }
            }
        } catch (e) {
            console.error('Invalid message:', e);
        }
    });

    ws.on('error', (err) => {
        console.error('WebSocket error:', err);
        stockfish.kill();
    });
    
    ws.on('close', () => {
        console.log('Client disconnected');
        stockfish.kill();
    });
});

server.on('error', (err) => {
    console.error('HTTP server error:', err);
    process.exit(1);
});

function shutdown() {
    for (const child of children) child.kill();
    for (const client of wss.clients) client.close();
    server.close(() => process.exit(0));
    setTimeout(() => process.exit(1), 2000).unref();
}

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

server.listen(PORT, () => {
    console.log(`Stockfish Web GUI running on http://localhost:${PORT}`);
});
