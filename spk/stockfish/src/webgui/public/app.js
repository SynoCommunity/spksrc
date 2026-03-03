// Chess game state
let game = new Chess();
let board = null;
let ws = null;
let playerColor = 'w';
let isThinking = false;
let skillLevel = 10;

// WebSocket connection to stockfish server
function connectWS() {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    ws = new WebSocket(`${protocol}//${window.location.host}`);
    
    ws.onopen = () => {
        console.log('Connected to Stockfish');
        sendUCI('uci');
        setTimeout(() => {
            sendUCI('setoption name Skill Level value ' + skillLevel);
            sendUCI('isready');
        }, 100);
    };
    
    ws.onmessage = (event) => {
        const msg = JSON.parse(event.data);
        if (msg.type === 'uci') handleUCIResponse(msg.data);
    };
    
    ws.onclose = () => {
        console.log('Disconnected, reconnecting...');
        setTimeout(connectWS, 2000);
    };
}

function sendUCI(cmd) {
    if (ws && ws.readyState === WebSocket.OPEN) {
        ws.send(JSON.stringify({ type: 'uci', data: cmd }));
    }
}

function handleUCIResponse(line) {
    // Parse evaluation
    if (line.includes('score cp ')) {
        const match = line.match(/score cp (-?\d+)/);
        if (match) {
            let cp = parseInt(match[1]) / 100;
            if (game.turn() === 'b') cp = -cp;
            document.getElementById('eval').textContent = (cp >= 0 ? '+' : '') + cp.toFixed(1);
        }
    }
    if (line.includes('score mate ')) {
        const match = line.match(/score mate (-?\d+)/);
        if (match) {
            document.getElementById('eval').textContent = 'Mate in ' + Math.abs(parseInt(match[1]));
        }
    }
    
    // Show thinking depth
    if (line.includes('depth ')) {
        const match = line.match(/depth (\d+)/);
        if (match) {
            document.getElementById('thinking').textContent = 'Thinking... depth ' + match[1];
        }
    }
    
    // Best move response
    if (line.startsWith('bestmove ')) {
        isThinking = false;
        document.getElementById('thinking').textContent = '';
        const move = line.split(' ')[1];
        
        if (move && move !== '(none)') {
            document.getElementById('bestmove').textContent = 'Best: ' + move;
            
            // If it's engine's turn, make the move
            if (game.turn() !== playerColor) {
                const from = move.substring(0, 2);
                const to = move.substring(2, 4);
                const promotion = move.length > 4 ? move[4] : undefined;
                
                game.move({ from, to, promotion });
                board.position(game.fen());
                updateStatus();
            }
        }
    }
}

function engineMove() {
    if (game.game_over() || isThinking) return;
    isThinking = true;
    sendUCI('position fen ' + game.fen());
    sendUCI('go movetime 1000');
}

function onDragStart(source, piece) {
    if (game.game_over()) return false;
    if (game.turn() !== playerColor) return false;
    if ((playerColor === 'w' && piece.search(/^b/) !== -1) ||
        (playerColor === 'b' && piece.search(/^w/) !== -1)) return false;
}

function onDrop(source, target) {
    const move = game.move({
        from: source,
        to: target,
        promotion: 'q'
    });
    
    if (move === null) return 'snapback';
    
    updateStatus();
    setTimeout(engineMove, 250);
}

function onSnapEnd() {
    board.position(game.fen());
}

function updateStatus() {
    let status = '';
    if (game.in_checkmate()) {
        status = (game.turn() === 'w' ? 'Black' : 'White') + ' wins by checkmate!';
    } else if (game.in_draw()) {
        status = 'Draw!';
    } else if (game.in_check()) {
        status = (game.turn() === 'w' ? 'White' : 'Black') + ' is in check';
    }
    if (status) document.getElementById('bestmove').textContent = status;
}

function newGame() {
    game = new Chess();
    board.position('start');
    document.getElementById('eval').textContent = '0.0';
    document.getElementById('bestmove').textContent = '';
    document.getElementById('thinking').textContent = '';
    
    if (playerColor === 'b') {
        setTimeout(engineMove, 500);
    }
}

// Initialize
$(document).ready(() => {
    board = Chessboard('board', {
        draggable: true,
        position: 'start',
        pieceTheme: 'https://chessboardjs.com/img/chesspieces/wikipedia/{piece}.png',
        onDragStart: onDragStart,
        onDrop: onDrop,
        onSnapEnd: onSnapEnd
    });
    
    connectWS();
    
    // Event handlers
    document.getElementById('newGame').onclick = newGame;
    document.getElementById('undo').onclick = () => {
        game.undo(); game.undo();
        board.position(game.fen());
    };
    document.getElementById('hint').onclick = () => {
        sendUCI('position fen ' + game.fen());
        sendUCI('go movetime 2000');
    };
    document.getElementById('flip').onclick = () => board.flip();
    
    document.getElementById('playerColor').onchange = (e) => {
        playerColor = e.target.value;
        newGame();
        if (playerColor === 'b') board.flip();
    };
    
    document.getElementById('difficulty').oninput = (e) => {
        skillLevel = parseInt(e.target.value);
        document.getElementById('diffVal').textContent = skillLevel;
        sendUCI('setoption name Skill Level value ' + skillLevel);
    };
    
    $(window).resize(() => board.resize());
});
