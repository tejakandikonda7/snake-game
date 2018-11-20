import 'dart:html';
import 'dart:math';
import 'dart:collection';
import 'dart:async';  
const int CELL_SIZE = 10;
int score=0,score2=0;
CanvasElement canvas,canvas2;  
CanvasRenderingContext2D ctx,ctx2;
Keyboard keyboard = new Keyboard(); 
Keyboard2 keyboard2 = new Keyboard2();
void main() {  
  canvas = querySelector('#canvas')..focus();
  ctx = canvas.getContext('2d');
  new Game()..run();
}
void drawCell(Point coords, String color) {  
  ctx..fillStyle = color
    ..strokeStyle = "white";

  final int x = coords.x * CELL_SIZE;
  final int y = coords.y * CELL_SIZE;

  ctx..fillRect(x, y, CELL_SIZE, CELL_SIZE)
    ..strokeRect(x, y, CELL_SIZE, CELL_SIZE);
}
void clear() {  
  ctx..fillStyle = "white"
    ..fillRect(0, 0, canvas.width, canvas.height);
  
}
class Keyboard {  
  HashMap<int, num> _keys = new HashMap<int, num>();

  Keyboard() {
    window.onKeyDown.listen((KeyboardEvent event) {
      _keys.putIfAbsent(event.keyCode, () => event.timeStamp);
    });

    window.onKeyUp.listen((KeyboardEvent event) {
      _keys.remove(event.keyCode);
    });
  }

  bool isPressed(int keyCode) => _keys.containsKey(keyCode);
}
class Keyboard2 {  
  HashMap<int, num> _keys2 = new HashMap<int, num>();

  Keyboard2() {
    window.onKeyDown.listen((KeyboardEvent event) {
      _keys2.putIfAbsent(event.keyCode, () => event.timeStamp);
    });

    window.onKeyUp.listen((KeyboardEvent event) {
      _keys2.remove(event.keyCode);
    });
  }

  bool isPressed2(int keyCode) => _keys2.containsKey(keyCode);
}
 class Snake {
  Point get head => _body.first; 
  static const int START_LENGTH = 6; 
  // coordinates of the body segments
List<Point> _body; 
  // current travel direction
Point _dir = RIGHT; 
// directions
static const Point LEFT = const Point(-1, 0);  
static const Point RIGHT = const Point(1, 0);  
static const Point UP = const Point(0, -1);  
static const Point DOWN = const Point(0, 1);
 static Point snakeHead = const Point(5, 5);  
static Point moveRight = const Point(1, 0);

Point newSnakeHead = snakeHead + moveRight; // Point(6, 5)  
  Snake() {  
  int i = START_LENGTH - 1;
  _body = new List<Point>.generate(START_LENGTH,
    (int index) => new Point(--i, 0));
  }
    void _checkInput() {  
  if (keyboard.isPressed(KeyCode.LEFT) && _dir != RIGHT) {
    _dir = LEFT;
  }
  else if (keyboard.isPressed(KeyCode.RIGHT) && _dir != LEFT) {
    _dir = RIGHT;
  }
  else if (keyboard.isPressed(KeyCode.UP) && _dir != DOWN) {
    _dir = UP;
  }
  else if (keyboard.isPressed(KeyCode.DOWN) && _dir != UP) {
    _dir = DOWN;
  }
}
    void grow() {  
  // add new head based on current direction
  _body.insert(0, head + _dir);
}
    void _move() {  
  // add a new head segment
  grow();

  // remove the tail segment
  _body.removeLast();
}
    void _draw() {  
  // starting with the head, draw each body segment
  for (Point p in _body) {
    drawCell(p, "green");
  }
}
 
    bool checkForBodyCollision() {  
  for (Point p in _body.skip(1)) {
    if (p == head) {
      return true;
    }
  }

  return false;
}
    void update() {  
  _checkInput();
  _move();
  _draw();

}
}
class Snake2 extends Snake {
  Point get head => _body.first; 
  static const int START_LENGTH = 6; 
  // coordinates of the body segments
List<Point> _body; 
  // current travel direction
Point _dir = RIGHT; 
// directions
static const Point LEFT = const Point(-1, 0);  
static const Point RIGHT = const Point(1, 0);  
static const Point UP = const Point(0, -1);  
static const Point DOWN = const Point(0, 1);
 static Point snakeHead = const Point(5, 5);  
static Point moveRight = const Point(1, 0);

Point newSnakeHead = snakeHead + moveRight; // Point(6, 5)  
  Snake2() {  
  int i = START_LENGTH - 1;
  _body = new List<Point>.generate(START_LENGTH,
    (int index) => new Point(--i,10));
  }
    void _checkInput() {  
  if (keyboard2.isPressed2(KeyCode.A) && _dir != RIGHT) {
    _dir = LEFT;
  }
  else if (keyboard2.isPressed2(KeyCode.D) && _dir != LEFT) {
    _dir = RIGHT;
  }
  else if (keyboard2.isPressed2(KeyCode.W) && _dir != DOWN) {
    _dir = UP;
  }
  else if (keyboard2.isPressed2(KeyCode.S) && _dir != UP) {
    _dir = DOWN;
  }
}
    void grow() {  
  // add new head based on current direction
  _body.insert(0, head + _dir);
}
    void _move() {  
  // add a new head segment
  grow();

  // remove the tail segment
  _body.removeLast();
}
    void _draw() {  
  // starting with the head, draw each body segment
  for (Point p in _body) {
    drawCell(p, "red");
  }
}
    bool checkForBodyCollision() {  
  for (Point p in _body.skip(1)) {
    if (p == head) {
      return true;
    }
  }

  return false;
}
    void update() {  
  _checkInput();
  _move();
  _draw();

}
}
class Game {
// smaller numbers make the game run faster
static const num GAME_SPEED = 100;
  num _lastTimeStamp = 0; 
  // a few convenience variables to simplify calculations
int _rightEdgeX;  
int _bottomEdgeY; 
  Snake _snake;
  Snake2 _snake2;  
Point _food;  
  Game() {  
  _rightEdgeX = canvas.width ~/ CELL_SIZE;
  _bottomEdgeY = canvas.height ~/ CELL_SIZE;

  init();
}
   void init() { 
  _snake = new Snake();
     querySelector('#score').text = '    Player 1 Score:'+score.toString();
  _snake2=new Snake2();
     querySelector('#score2').text = '    Player 2 Score:'+score2.toString();
  _food = _randomPoint();
}
  void init2(int k) { 
    if(k==1){
  _snake = new Snake();
    }
    if(k==2){
  _snake2=new Snake2();
    }
}
  Point _randomPoint() {  
  Random random = new Random();
  return new Point(random.nextInt(_rightEdgeX),
    random.nextInt(_bottomEdgeY));
}
  void _checkForCollisions() {  
  // check for collision with food
  if (_snake.head == _food) {
    _snake.grow();
    _food = _randomPoint();
     score++;
    querySelector('#score').text = 'Player 1 Score:'+score.toString();
  }
     if (_snake2.head == _food) {
    _snake2.grow();
    _food = _randomPoint();
        score2++;
    querySelector('#score2').text = '    Player 2 Score:'+score2.toString();
  }

  // check death conditions
  if (_snake.head.x <= -1 ||
    _snake.head.x >= _rightEdgeX ||
    _snake.head.y <= -1 ||
    _snake.head.y >= _bottomEdgeY ||
    _snake.checkForBodyCollision()) {
    init2(1);
  }
    if (_snake2.head.x <= -1 ||
    _snake2.head.x >= _rightEdgeX ||
    _snake2.head.y <= -1 ||
    _snake2.head.y >= _bottomEdgeY ||
    _snake2.checkForBodyCollision()) {
    init2(2);
  }
}
  Future run() async {  
  update(await window.animationFrame);
}
  void update(num delta) {  
  final num diff = delta - _lastTimeStamp;

  if (diff > GAME_SPEED) {
    _lastTimeStamp = delta;
    clear();
    drawCell(_food, "blue");
    _snake.update();
    _snake2.update();
    _checkForCollisions();
  }

  // keep looping
  run();
}
}
