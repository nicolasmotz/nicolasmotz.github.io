const huPlayer = -1;
const aiPlayer = 1;
const cells = document.querySelectorAll('.cell');

var Board;
var move;
var Theta;
var Theta1;      
var Theta2;
var Theta3;
var countRounds = 1;
    
    
loadTheta(function() {
    startGame();
});


function loadTheta(callback) {
    var xhttp = new XMLHttpRequest();
    
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        Theta = this.responseText;
        Theta = Theta.split('\n');
        Theta = Theta.map(parseFloat);
        Theta1 = math.subset(Theta, math.index(math.range(0,180)));
        Theta1 = math.reshape(Theta1, [18, 10]);
        Theta2 = math.subset(Theta, math.index(math.range(180,125903)));
        Theta2 = math.reshape(Theta2, [6617, 19]);
        Theta3 = math.subset(Theta, math.index(math.range(125903,185465)));
        Theta3 = math.reshape(Theta3, [9, 6618]);
        callback();
      }
    };
    xhttp.open('GET', 'theta.txt', true);
    xhttp.send();
}

function startGame() {
    
    Board = math.zeros(1,9);
    document.querySelector(".endgame").style.display = "none";
    for (var i = 0; i < cells.length; i++) {
		cells[i].innerText = '';
		cells[i].addEventListener('click', turnClick, false);
        cells[i].style.color = 'black';
    }
    
    if (math.mod(countRounds, 2) === 0) {
        move = choice(Board);
        turn(move, aiPlayer);
    } 

}

function turnClick(square) {
    
	turn(square.target.id, huPlayer);
    if (checkWin(Board) != huPlayer & math.sum(math.abs(Board)) < 9) {
        move = choice(Board);
        turn(move, aiPlayer);
    }
    
}

function turn(squareId, player) {
	
    Board = math.subset(Board, math.index(0, parseInt(squareId)), player);
    cells[parseInt(squareId)].removeEventListener('click', turnClick, false);
    if (player == -1) {
        document.getElementById(squareId).innerText = 'X';
    } else {
        document.getElementById(squareId).innerText = 'O';
    }
    if (checkWin(Board) === player) {
        gameover(player);
    } else if (math.sum(math.abs(Board)) === 9) {
        gameover(0);
    }
    
}

function sigmoid(x) {
    return math.dotDivide(math.ones(math.size(x)), math.add(math.ones(math.size(x)), math.exp(math.multiply(-1, x))));
}

function output(Board) {
    var A1;
    var A2;
    var A3;
    var A4;
    
    A1 = math.concat(math.ones(1,1),Board);
    A2 = math.multiply(A1, math.transpose(Theta1));
    A2 = math.dotMultiply(A2, math.smaller(0,A2));
    A2 = math.concat(math.ones(1,1),A2);
    A3 = math.floor(math.multiply(A2, math.transpose(Theta2)))
    A3 = math.dotMultiply(A3, math.smaller(0,A3));
    A3 = math.concat(math.ones(1,1),A3);
    A4 = sigmoid(math.multiply(A3, math.transpose(Theta3)));
    return A4;
}

function choice(Board) {
    var scores;
    
    scores = output(Board);
    scores = math.subtract(scores, math.abs(Board))
    return iMax(scores);
    
}

function checkWin(Board) {
    var B;
    
    function check(B) {
        if (math.sum(math.subset(B, math.index([0, 1, 2],0))) === 3) {
            cells[0].style.color = "green";
            cells[3].style.color = "green";
            cells[6].style.color = "green";
            return 1;
        } else if (math.sum(math.subset(B, math.index([0, 1, 2],1))) === 3) {
            cells[1].style.color = "green";
            cells[4].style.color = "green";
            cells[7].style.color = "green";
            return 1;
        } else if (math.sum(math.subset(B, math.index([0, 1, 2],2))) === 3) {
            cells[2].style.color = "green";
            cells[5].style.color = "green";
            cells[8].style.color = "green";
            return 1;
        } else if (math.sum(math.subset(B, math.index(0,[0, 1, 2]))) === 3) {
            cells[0].style.color = "green";
            cells[1].style.color = "green";
            cells[2].style.color = "green";
            return 1;
        } else if (math.sum(math.subset(B, math.index(1,[0, 1, 2]))) === 3) {
            cells[3].style.color = "green";
            cells[4].style.color = "green";
            cells[5].style.color = "green";
            return 1;
        } else if (math.sum(math.subset(B, math.index(2,[0, 1, 2]))) === 3) {
            cells[6].style.color = "green";
            cells[7].style.color = "green";
            cells[8].style.color = "green";
            return 1;
        } else if (math.trace(B) === 3) {
            cells[0].style.color = "green";
            cells[4].style.color = "green";
            cells[8].style.color = "green";
            return 1;
        } else if (math.sum(math.subset(B, math.index(0,2)),math.subset(B, math.index(1,1)),math.subset(B, math.index(2,0))) === 3) {
            cells[2].style.color = "green";
            cells[4].style.color = "green";
            cells[6].style.color = "green";
            return 1;
        } else {
            return 0;
        }
    }
    
    B = math.clone(Board)
    B = math.reshape(B, [3,3]);
    if (check(B) === 1) {
        return 1;
    } else if (check(math.multiply(-1,B)) === 1) {
        return -1;
    } else {
        return 0;
    }
}

function iMax(m) {
    var l = math.subset(math.size(m),math.index(1));
    if (l === 0) {
        return -1;
    }

    var max = math.subset(m, math.index(0,0));
    var maxIndex = 0;

    for (var i = 1; i < l; i++) {
        if (math.subset(m, math.index(0,i)) > max) {
            maxIndex = i;
            max = math.subset(m, math.index(0,i));
        }
    }

    return maxIndex;
}

function gameover(player) {
    
    countRounds += 1;
    
    if (player === huPlayer) {
        document.querySelector(".endgame .text").innerText = 'You win!';
    } else if (player === aiPlayer) {
        document.querySelector(".endgame .text").innerText = 'Nouri wins!';
    } else {
        document.querySelector(".endgame .text").innerText = 'Tied!';
    }
    document.querySelector(".endgame").style.display = "block";
    for (var i = 0; i < cells.length; i++) {
		cells[i].removeEventListener('click', turnClick, false);
    }
    
}
