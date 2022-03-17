PGraphics render;

int screenSizeMult = 3;

int scene = 0;
int subscene = 0;
long frame = 0;

int darkEffect; //Goes from 0 to 255
boolean debug = false;

//Scene 0 data
int bg_offset = 0;

//Screen 1 data
int gameMode = 0; //0: Regular, 1: Timed
int scalarDifficulty = 0;
char[][] gameMap;
char[][] gameMap_visible;
Cursor cursor;
int[] timer = new int[2]; //timer[0], seconds; timer[1], minutes
double timer_rt = 0; //Timer in seconds
int time_wait = 3;

void setup()
{
  size(360,357);  
  render = createGraphics(120,119);
  frameRate(60);
  
  surface.setSize(width,height);
  surface.setTitle("ソニックの地雷探しゲーム");
  
  loadImages();
  
  PImage icon = loadImage("data/icon");
  surface.setIcon(icon);
  
  init_music();
  stop_music();
  music_menu.loop();
}

void draw()
{
  render.beginDraw();
  
  bg_offset = (bg_offset + 1)%120;
    
  render.image(tex[0],-bg_offset,0); //BG 1
  render.image(tex[0],-bg_offset + 120,0); //BG 2
  
  if(scene == 0)
  {
    int selector_offset = 0; if(subscene != 0) selector_offset = 56;
    render.image(tex[5],10,2); //Title
    render.image(tex[1],10,84); //Button 1
    render.image(tex[2],66,84); //Button 2
    render.image(tex[6],10 + selector_offset,84); //Button Selector
    render.image(tex[4],62,70); //Random Text
    if(millis()%10000 < 5000)
      render.image(tex[3],0,105); //Copyright
    else
      render.image(tex[7],0,105);
  }
  
  else if (scene == 1)
  {    
    for(int y = 0; y < 9; y++) //Map Draw
      for(int x = 0; x < 9; x++)
      {
        render.image(tex[10 + gameMap_visible[x][y]], 10 + 11*x, 20 + 11*y);
        if(debug && gameMap_visible[x][y] == 13) render.image(rescaleImage(tex[10 + gameMap[x][y]], 0.5), 10 + 11*x, 20 + 11*y);
        if(x == cursor.x && y == cursor.y)
          render.image(tex[24], 10 + 11*x, 20 + 11*y);
      }
      
      
    //Top Overlay (Character)
    if(gameMode == 1 && scalarDifficulty >= 7) {
      render.image(epic_egg,0,0); 
    } else {
      render.image(tex[8 + gameMode],0,0);
    }
    
    if(timer_rt > 60 && gameMode == 1 && timer_rt%10 < 2)
    {
      render.image(tex[29],63,0);
      render.image(tex[30],94,7);
      render.image(tex[30 + scalarDifficulty + 1],99,7);
    }
    else
    {
      render.image(tex[28],63,0);
      renderTimerNumbers(timer);
    }
      
    if(gameMode == 1 || subscene != 0)
      timer_rt -= (1/frameRate);
    else  
      timer_rt += (1/frameRate);
    if(timer_rt < 0) timer_rt = -1;
    else if(timer_rt > 5997) timer_rt = 5998;
      
    if(timer_rt < 0 && gameMode == 1 && subscene == 0) {//End game if there's no time left
      timer[1] = 0;
      timer[0] = 0;
      subscene = 3; 
      timer_rt = time_wait;
    }
      
    if(subscene == 0)
    {
      timer[1] = (int)((timer_rt+gameMode)/60);
      timer[0] = (int)((timer_rt+gameMode)%60);
    }
    else if(timer_rt < 1)
      render.image(tex[27],0,75);
      
    if(subscene == 1)
      render.image(tex[25],0,0);
    else if(subscene == 3)
      render.image(tex[26],0,0);
  }
  
  //Dark Transition
  if(debug) render.image(image_debug,0,0);
  render.endDraw();
  image(rescaleImage(render,screenSizeMult),0,0);
  frame++;
}

void keyPressed()
{/*
  if(key == '+' && screenSizeMult < 8)
  {
    screenSizeMult++;
    println("Rising Screen Size to x" + screenSizeMult);
    surface.setSize(120*screenSizeMult,119*screenSizeMult);
  }
  if(key == '-' && screenSizeMult > 1)
  {
    screenSizeMult--;
    println("Lowering Screen Size to x" + screenSizeMult);
    surface.setSize(120*screenSizeMult,119*screenSizeMult);
  }*/
  
  if(scene == 0)
  {
    if(subscene == 0)
    {
      if (key == CODED && keyCode == RIGHT) {
          subscene = 1;
      }
      else if (key == 'x' || key == 'X')
      {
        println("Game mode selected: Timed");
        stop_music();
        music_easy.loop();
        scalarDifficulty = 0;
        newTimedGame();
      }
    }
    else
    {
      if (key == CODED && keyCode == LEFT) {
          subscene = 0;
      }
      else if (key == 'x' || key == 'X')
      {
        println("Game mode selected: Classic");
        stop_music();
        music_infinite.loop();
        newClassicGame();
      }
    }
  }
  
  else if(scene == 1 && subscene == 0)
  {
    if ((key >= '0' && key <= '7') && debug){
        println("[DEBUG] Generating new board");
        generateMap( Character.getNumericValue(key) );
    }
    else if (key == 'x' || key == 'X')
    {
      digTile(cursor);
      if(true) println("Current board state: " + checkGameStatus());
      if(checkGameStatus() != 0)
        endRound(checkGameStatus());
    }
    else if (key == 'z' || key == 'Z')
    {
      markTile();
      if(debug) println("Current board state: " + checkGameStatus());
      if(checkGameStatus() != 0)
        endRound(checkGameStatus());
    }
    else if (key == CODED) {
          if(keyCode == LEFT)
            cursor.move(left);
          else if(keyCode == RIGHT)
            cursor.move(right);
          else if(keyCode == UP)
            cursor.move(up);
          else if(keyCode == DOWN)
            cursor.move(down);
    }
  }
  else if(scene == 1 && subscene != 0 && timer_rt < 1)
  {
    if (key == 'x' || key == 'X')
    {
      if(subscene != 1) //Advance to next level
      {
        scene = 0; 
        subscene = 0;
        stop_music();
        music_menu.loop();
      }
      else
        if(gameMode == 1)
          newTimedGame();
        else
          newClassicGame();
    }
  }
}
