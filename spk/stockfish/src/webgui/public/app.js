// Chess game state
let game = new Chess();
let board = null;
let ws = null;
let playerColor = 'w';
let isThinking = false;
let skillLevel = 10;
let moveHistory = [];
let soundEnabled = true;
let selfPlayMode = false;
let pendingPromotion = null;

// Sound files (bundled locally)
const sounds = {
    move: new Audio('sound/move.mp3'),
    capture: new Audio('sound/capture.mp3'),
    check: new Audio('sound/check.mp3'),
    castle: new Audio('sound/castle.mp3'),
    promote: new Audio('sound/promote.mp3'),
    gameEnd: new Audio('sound/gameend.mp3'),
    illegal: new Audio('sound/illegal.mp3')
};

// Preload sounds
Object.values(sounds).forEach(audio => { audio.volume = 0.6; audio.load(); });

function playSound(type) {
    if (!soundEnabled) return;
    const sound = sounds[type];
    if (sound) { sound.currentTime = 0; sound.play().catch(() => {}); }
}

// Piece images for captured display
const pieceImages = {
    p: 'img/pieces/bP.png', n: 'img/pieces/bN.png', b: 'img/pieces/bB.png',
    r: 'img/pieces/bR.png', q: 'img/pieces/bQ.png',
    P: 'img/pieces/wP.png', N: 'img/pieces/wN.png', B: 'img/pieces/wB.png',
    R: 'img/pieces/wR.png', Q: 'img/pieces/wQ.png'
};

// WebSocket connection
function connectWS() {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    ws = new WebSocket(`${protocol}//${window.location.host}`);
    ws.onopen = () => {
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
    ws.onclose = () => setTimeout(connectWS, 2000);
}

function sendUCI(cmd) {
    if (ws && ws.readyState === WebSocket.OPEN) {
        ws.send(JSON.stringify({ type: 'uci', data: cmd }));
    }
}

function handleUCIResponse(data) {
    data.split('\n').forEach(line => {
        if (line.startsWith('info') && line.includes('score cp')) {
            const match = line.match(/score cp (-?\d+)/);
            if (match) {
                let cp = parseInt(match[1]) / 100;
                if (game.turn() === 'b') cp = -cp;
                document.getElementById('eval').textContent = (cp >= 0 ? '+' : '') + cp.toFixed(1);
            }
        }
        if (line.startsWith('info') && line.includes('score mate')) {
            const match = line.match(/score mate (-?\d+)/);
            if (match) {
                let mate = parseInt(match[1]);
                if (game.turn() === 'b') mate = -mate;
                document.getElementById('eval').textContent = (mate > 0 ? '+' : '') + 'M' + Math.abs(mate);
            }
        }
        if (line.startsWith('bestmove')) {
            const match = line.match(/bestmove\s+(\S+)/);
            if (match) {
                document.getElementById('bestmove').textContent = 'Best: ' + match[1];
                if (isThinking) makeEngineMove(match[1]);
            }
            document.getElementById('thinking').textContent = '';
        }
    });
}

function makeEngineMove(uciMove) {
    isThinking = false;
    const from = uciMove.substring(0, 2);
    const to = uciMove.substring(2, 4);
    const promotion = uciMove.length > 4 ? uciMove[4] : null;
    const move = game.move({ from, to, promotion });
    if (move) {
        moveHistory.push(move.san);
        board.position(game.fen());
        playSoundForMove(move);
        updateDisplay();
        if (game.game_over()) {
            playSound('gameEnd');
            stopSelfPlay();
        } else if (selfPlayMode) {
            setTimeout(engineMove, 300);
        }
    }
}

function playSoundForMove(move) {
    if (move.flags.includes('k') || move.flags.includes('q')) playSound('castle');
    else if (move.flags.includes('p')) playSound('promote');
    else if (move.captured) playSound('capture');
    else playSound('move');
    if (game.in_check()) setTimeout(() => playSound('check'), 100);
}

function onDragStart(source, piece) {
    if (game.game_over()) return false;
    if (selfPlayMode) return false;
    if ((game.turn() === 'w' && piece.search(/^b/) !== -1) ||
        (game.turn() === 'b' && piece.search(/^w/) !== -1)) return false;
    if ((playerColor === 'w' && game.turn() === 'b') ||
        (playerColor === 'b' && game.turn() === 'w')) return false;
    return true;
}

function onDrop(source, target) {
    const moves = game.moves({ square: source, verbose: true });
    const isPromotion = moves.some(m => m.to === target && m.flags.includes('p'));
    if (isPromotion) {
        pendingPromotion = { source, target };
        showPromotionDialog(game.turn());
        return;
    }
    const move = game.move({ from: source, to: target, promotion: 'q' });
    if (move === null) {
        playSound('illegal');
        return 'snapback';
    }
    moveHistory.push(move.san);
    playSoundForMove(move);
    updateDisplay();
    if (game.game_over()) {
        playSound('gameEnd');
    } else if (!selfPlayMode) {
        setTimeout(engineMove, 300);
    }
}

function onSnapEnd() { board.position(game.fen()); }

function showPromotionDialog(color) {
    const modal = document.getElementById('promoModal');
    const piecesDiv = document.getElementById('promoPieces');
    const prefix = color === 'w' ? 'w' : 'b';
    piecesDiv.innerHTML = ['q','r','b','n'].map(p => `
        <div class="promo-piece" data-piece="${p}">
            <img src="img/pieces/${prefix}${p.toUpperCase()}.png" alt="${p}">
        </div>
    `).join('');
    modal.classList.add('active');
    piecesDiv.querySelectorAll('.promo-piece').forEach(el => {
        el.onclick = () => completePromotion(el.dataset.piece);
    });
}

function completePromotion(piece) {
    document.getElementById('promoModal').classList.remove('active');
    if (pendingPromotion) {
        const move = game.move({ from: pendingPromotion.source, to: pendingPromotion.target, promotion: piece });
        if (move) {
            moveHistory.push(move.san);
            board.position(game.fen());
            playSound('promote');
            updateDisplay();
            if (!game.game_over()) setTimeout(engineMove, 300);
        }
        pendingPromotion = null;
    }
}

function engineMove() {
    if (game.game_over() || isThinking) return;
    isThinking = true;
    document.getElementById('thinking').textContent = 'Thinking...';
    sendUCI('position fen ' + game.fen());
    sendUCI('go movetime 1500');
}

// Stop self-play mode and sync UI
function stopSelfPlay() {
    selfPlayMode = false;
    isThinking = false;
    const cb = document.getElementById('selfPlay');
    if (cb) cb.checked = false;
    document.getElementById('playerColor').disabled = false;
}

function updateDisplay() {
    updateMoveHistory();
    updateCaptured();
    document.getElementById('fen').textContent = game.fen();
    updateStatus();
    updateTurnIndicator();
}

function updateTurnIndicator() {
    const turn = game.turn();
    document.getElementById('turnWhite').classList.toggle('active', turn === 'w');
    document.getElementById('turnBlack').classList.toggle('active', turn === 'b');
    document.getElementById('turnText').textContent = turn === 'w' ? 'White to move' : 'Black to move';
}

function updateMoveHistory() {
    const div = document.getElementById('moveHistory');
    let html = '';
    for (let i = 0; i < moveHistory.length; i += 2) {
        const num = Math.floor(i / 2) + 1;
        const w = moveHistory[i] || '';
        const b = moveHistory[i + 1] || '';
        const last = i + 2 >= moveHistory.length;
        html += `<div class="move-pair"><span class="move-num">${num}.</span>
            <span class="white-move ${last && !b ? 'current' : ''}">${w}</span>
            <span class="black-move ${last && b ? 'current' : ''}">${b}</span></div>`;
    }
    div.innerHTML = html || '<span style="color:#666">No moves yet</span>';
    div.scrollTop = div.scrollHeight;
}

function updateCaptured() {
    const history = game.history({ verbose: true });
    const white = [], black = [];
    history.forEach(m => {
        if (m.captured) {
            if (m.color === 'w') black.push(m.captured);
            else white.push(m.captured.toUpperCase());
        }
    });
    const order = { q:0, Q:0, r:1, R:1, b:2, B:2, n:3, N:3, p:4, P:4 };
    white.sort((a,b) => order[a] - order[b]);
    black.sort((a,b) => order[a] - order[b]);
    document.getElementById('captured-white').innerHTML = white.map(p => `<img src="${pieceImages[p]}">`).join('') || '&nbsp;';
    document.getElementById('captured-black').innerHTML = black.map(p => `<img src="${pieceImages[p]}">`).join('') || '&nbsp;';
}

function updateStatus() {
    let status = '';
    const evalEl = document.getElementById('eval');
    if (game.in_checkmate()) {
        status = (game.turn() === 'w' ? 'Black' : 'White') + ' wins!';
        evalEl.textContent = game.turn() === 'w' ? '-∞' : '+∞';
    } else if (game.in_stalemate()) status = 'Stalemate';
    else if (game.in_threefold_repetition()) status = 'Draw (repetition)';
    else if (game.insufficient_material()) status = 'Draw (material)';
    else if (game.in_draw()) status = 'Draw';
    else if (game.in_check()) status = (game.turn() === 'w' ? 'White' : 'Black') + ' in check';
    document.getElementById('gameStatus').textContent = status;
    if (status && !game.in_check()) document.getElementById('bestmove').textContent = '';
}

function newGame() {
    isThinking = false; // Cancel any pending engine move
    game = new Chess();
    moveHistory = [];
    board.position('start');
    document.getElementById('eval').textContent = '0.0';
    document.getElementById('bestmove').textContent = '';
    document.getElementById('thinking').textContent = '';
    updateDisplay();
    if (selfPlayMode) setTimeout(engineMove, 500);
    else if (playerColor === 'b') setTimeout(engineMove, 500);
}

function loadFEN(fen) {
    const validation = game.validate_fen(fen);
    if (!validation.valid) {
        alert('Invalid FEN: ' + validation.error);
        playSound('illegal');
        return false;
    }
    isThinking = false; // Cancel any pending engine move
    game = new Chess(fen);
    moveHistory = [];
    board.position(fen);
    document.getElementById('eval').textContent = '0.0';
    document.getElementById('bestmove').textContent = '';
    document.getElementById('thinking').textContent = '';
    updateDisplay();
    if (selfPlayMode) setTimeout(engineMove, 500);
    else if ((playerColor === 'w' && game.turn() === 'b') || (playerColor === 'b' && game.turn() === 'w')) {
        setTimeout(engineMove, 500);
    }
    return true;
}

function showToast(msg) {
    const t = document.getElementById('toast');
    if (t) { t.textContent = msg; t.classList.add('show'); setTimeout(() => t.classList.remove('show'), 2000); }
}

function fallbackCopy(text, label) {
    const ta = document.createElement('textarea');
    ta.value = text; ta.style.cssText = 'position:fixed;opacity:0';
    document.body.appendChild(ta); ta.select();
    try { document.execCommand('copy'); showToast(label + ' copied!'); }
    catch(e) { showToast('Copy failed'); }
    document.body.removeChild(ta);
}

function copyPGN() {
    const pgn = game.pgn();
    if (!pgn.trim()) { showToast('No moves'); return; }
    if (navigator.clipboard?.writeText) {
        navigator.clipboard.writeText(pgn).then(() => showToast('PGN copied!')).catch(() => fallbackCopy(pgn, 'PGN'));
    } else fallbackCopy(pgn, 'PGN');
}

function copyFEN() {
    const fen = game.fen();
    if (navigator.clipboard?.writeText) {
        navigator.clipboard.writeText(fen).then(() => showToast('FEN copied!')).catch(() => fallbackCopy(fen, 'FEN'));
    } else fallbackCopy(fen, 'FEN');
}

// Initialize
$(document).ready(() => {
    board = Chessboard('board', {
        draggable: true, position: 'start',
        pieceTheme: 'img/pieces/{piece}.png',
        onDragStart, onDrop, onSnapEnd
    });
    connectWS();
    updateDisplay();

    // Controls
    document.getElementById('newGame').onclick = newGame;
    document.getElementById('undo').onclick = () => {
        game.undo(); game.undo();
        moveHistory = moveHistory.slice(0, -2);
        board.position(game.fen());
        updateDisplay();
    };
    document.getElementById('hint').onclick = () => {
        document.getElementById('thinking').textContent = 'Analyzing...';
        sendUCI('position fen ' + game.fen());
        sendUCI('go movetime 2000');
    };
    document.getElementById('flip').onclick = () => board.flip();
    document.getElementById('copyPgn').onclick = copyPGN;
    document.getElementById('fen').onclick = copyFEN;

    // FEN modal
    document.getElementById('loadFen').onclick = () => {
        document.getElementById('fenInput').value = game.fen();
        document.getElementById('fenModal').classList.add('active');
    };
    document.getElementById('fenLoad').onclick = () => {
        if (loadFEN(document.getElementById('fenInput').value.trim()))
            document.getElementById('fenModal').classList.remove('active');
    };
    document.getElementById('fenCancel').onclick = () => document.getElementById('fenModal').classList.remove('active');

    // Close modals on overlay click
    document.querySelectorAll('.modal-overlay').forEach(o => {
        o.onclick = (e) => { if (e.target === o) { o.classList.remove('active'); pendingPromotion = null; } };
    });

    // Settings
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
    document.getElementById('soundEnabled').onchange = (e) => {
        soundEnabled = e.target.checked;
        if (soundEnabled) playSound('move');
    };
    document.getElementById('selfPlay').onchange = (e) => {
        selfPlayMode = e.target.checked;
        document.getElementById('playerColor').disabled = selfPlayMode;
        if (selfPlayMode && !game.game_over() && !isThinking) engineMove();
    };

    $(window).resize(() => board.resize());

    // Keyboard shortcuts
    document.addEventListener('keydown', (e) => {
        if (e.target.tagName === 'INPUT') return;
        if (e.key === 'n') newGame();
        else if (e.key === 'u') document.getElementById('undo').click();
        else if (e.key === 'h') document.getElementById('hint').click();
        else if (e.key === 'f') board.flip();
    });
});
