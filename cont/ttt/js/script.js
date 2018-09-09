var Board;
var Theta;
const huPlayer = -1;
const aiPlayer = 1;
const cells = document.querySelectorAll('.cell');

loadTheta();
startGame();


function loadTheta() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      Theta = this.responseText;
      document.getElementByID('demo').innerText = Theta;
      Theta = Theta.split(';')
      document.getElementByID('demo').innerText = Theta;
    }
  };
  xhttp.open('GET', 'theta.txt', true);
  xhttp.send();
}

function startGame() {
    for (var i = 0; i < cells.length; i++) {
		cells[i].innerText = '';
		cells[i].addEventListener('click', turnClick, false);
        Board = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    }
}

function turnClick(square) {
	turn(square.target.id, huPlayer)
}

function turn(squareId, player) {
	Board[squareId] = player;
    if (player == -1) {
        document.getElementById(squareId).innerText = 'X';
    } else {
        document.getElementById(squareId).innerText = 'O';
    }
}
