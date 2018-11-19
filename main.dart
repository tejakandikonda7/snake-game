import 'dart:html';
import 'dart:collection'; 
import 'dart:async';
import 'dart:math';
const int CELL_SIZE = 10; 
 int score=0,score2=0;
CanvasElement canvas,canvas2;
CanvasRenderingContext2D ctx,ctx2;
Keyboard keyboard = new Keyboard();
Keyboard2 keyboard2 = new Keyboard2();
void main() {  
  player1();
  player2();
}
void player1(){
  canvas = querySelector('#canvas')..focus();
  ctx = canvas.getContext('2d');
  querySelector('#score').text = 'Score:'+score.toString();
  new Game()..run();
}
void player2(){
   canvas2 = querySelector('#canvas2')..focus();
  ctx2 = canvas2.getContext('2d');
  querySelector('#score2').text = 'Score:'+score2.toString();
  new Game2()..run2();
}
void drawCell(Point coords, String color) {  
  ctx..fillStyle = color
    ..strokeStyle = "white";

  final int x = coords.x * CELL_SIZE;
  final int y = coords.y * CELL_SIZE;

  ctx..fillRect(x, y, CELL_SIZE, CELL_SIZE)
    ..strokeRect(x, y, CELL_SIZE, CELL_SIZE);
  
}
void drawCell2(Point coords, String color) { 
   ctx2..fillStyle = color
    ..strokeStyle = "white";
    final int x = coords.x * CELL_SIZE;
  final int y = coords.y * CELL_SIZE;
  ctx2..fillRect(x, y, CELL_SIZE, CELL_SIZE)
    ..strokeRect(x, y, CELL_SIZE, CELL_SIZE);
}
void clear() {  
  ctx..fillStyle = "white"
    ..fillRect(0, 0, canvas.width, canvas.height);
}
void clear2() { 
  ctx2..fillStyle = "white"
    ..fillRect(0, 0, canvas2.width, canvas2.height);
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
// for snake 1
class Snake {
  Point get head => _body.first;  
// directions
static const Point LEFT = const Point(-1, 0);  
static const Point RIGHT = const Point(1, 0);  
static const Point UP = const Point(0, -1);  
static const Point DOWN = const Point(0, 1);  
 static Point snakeHead = const Point(5, 5);  
static Point moveRight = const Point(1, 0);
static const int START_LENGTH = 6;
  Point newSnakeHead = snakeHead + moveRight; // Point(6, 5) 
  // coordinates of the body segments
List<Point> _body;  
  // current travel direction
Point _dir = RIGHT;

  Snake() {  
  int i = 6 - 1+score;
  _body = new List<Point>.generate(i,
    (int index) => new Point(i--, 0));
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
class Game {
// smaller numbers make the game run faster
static const num GAME_SPEED = 50; 
  num _lastTimeStamp = 0; 
  // a few convenience variables to simplify calculations
int _rightEdgeX;  
int _bottomEdgeY; 
  Snake _snake;  
Point _food; 
  Game() {  
  _rightEdgeX = canvas.width ~/ CELL_SIZE;
  _bottomEdgeY = canvas.height ~/ CELL_SIZE;

  init();
}
  void init() {  
  _snake = new Snake();
  _food = _randomPoint();
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
    querySelector('#score').text = 'Score:'+score.toString();
  }

  // check death conditions
  if (_snake.head.x <= -1 ||
    _snake.head.x >= _rightEdgeX ||
    _snake.head.y <= -1 ||
    _snake.head.y >= _bottomEdgeY ||
    _snake.checkForBodyCollision()) {
    _snake = new Snake();
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
    _checkForCollisions();
  }

  // keep looping
  run();
}
}
// for snake 2
class Snake2 {
  Point get head2 => _body2.first;  
// directions
static const Point LEFT = const Point(-1, 0);  
static const Point RIGHT = const Point(1, 0);  
static const Point UP = const Point(0, -1);  
static const Point DOWN = const Point(0, 1);  
 static Point snakeHead = const Point(5, 5);  
static Point moveRight = const Point(1, 0);
//static const int START_LENGTH = 6;
  Point newSnakeHead = snakeHead + moveRight; // Point(6, 5) 
  // coordinates of the body segments
List<Point> _body2;  
  // current travel direction
Point _dir2 = RIGHT;

  Snake2() {  
  int i = 6- 1+score2;
  _body2 = new List<Point>.generate(i,
    (int index) => new Point(i--, 0));
}
  void _checkInput2() {  
  if (keyboard2.isPressed2(KeyCode.A) && _dir2 != RIGHT) {
    _dir2 = LEFT;
  }
  else if (keyboard2.isPressed2(KeyCode.D) && _dir2 != LEFT) {
    _dir2 = RIGHT;
  }
  else if (keyboard2.isPressed2(KeyCode.W) && _dir2 != DOWN) {
    _dir2 = UP;
  }
  else if (keyboard2.isPressed2(KeyCode.S) && _dir2 != UP) {
    _dir2 = DOWN;
  }
}
  void grow2() {  
  // add new head based on current direction
  _body2.insert(0, head2 + _dir2);
}
  void _move2() {  
  // add a new head segment
  grow2();

  // remove the tail segment
  _body2.removeLast();
}
  void _draw2() {  
  // starting with the head, draw each body segment
  for (Point p in _body2) {
    drawCell2(p, "green");
  }
}
  bool checkForBodyCollision2() {  
  for (Point p in _body2.skip(1)) {
    if (p == head2) {
      return true;
    }
  }

  return false;
}
  void update2() {  
  _checkInput2();
  _move2();
  _draw2();
}
}
class Game2 {
// smaller numbers make the game run faster
static const num GAME_SPEED = 50; 
  num _lastTimeStamp2 = 0; 
  // a few convenience variables to simplify calculations
int _rightEdgeX2;  
int _bottomEdgeY2; 
  Snake2 _snake2;  
Point _food2; 
  Game2() {  
  _rightEdgeX2 = canvas2.width ~/ CELL_SIZE;
  _bottomEdgeY2 = canvas2.height ~/ CELL_SIZE;

  init2();
}
  void init2() {  
  _snake2 = new Snake2();
  _food2 = _randomPoint2();
}
  Point _randomPoint2() {  
  Random random2 = new Random();
  return new Point(random2.nextInt(_rightEdgeX2),
    random2.nextInt(_bottomEdgeY2));
}
  void _checkForCollisions2() {  
  // check for collision with food
  if (_snake2.head2 == _food2) {
    _snake2.grow2();
    _food2 = _randomPoint2();
    score2++;
    querySelector('#score2').text = 'Score:'+score2.toString();
  }

  // check death conditions
  if (_snake2.head2.x <= -1 ||
    _snake2.head2.x >= _rightEdgeX2 ||
    _snake2.head2.y <= -1 ||
    _snake2.head2.y >= _bottomEdgeY2 ||
    _snake2.checkForBodyCollision2()) {
    _snake2 = new Snake2();
  }
}
  Future run2() async {  
  update2(await window.animationFrame);
}
 

  void update2(num delta2) {  
  final num diff = delta2 - _lastTimeStamp2;

  if (diff > GAME_SPEED) {
    _lastTimeStamp2 = delta2;
    clear2();
    drawCell2(_food2, "blue");
    _snake2.update2();
    _checkForCollisions2();
  }

  // keep looping
  run2();
}
}
