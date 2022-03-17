int[] up = {0,-1};
int[] left = {-1,0};
int[] down = {0,1};
int[] right = {1,0};

class Cursor
{
  char x, y;
  
  Cursor(int x, int y)
  {
    if(x < 0 || x > 8 || y < 0 || y > 8)
    {
      println("[ERROR] Invalid cursor coordinates (" + x + "," + y + ")");
      this.x = 0;
      this.y = 0;
    }
    //println("Cursor generated at (" + x + "," + y + ")");
    this.x = (char)x;
    this.y = (char)y;
  }
  
  void move(int[] dir)
  {
    x = (char)(x + dir[0]);
    y = (char)(y + dir[1]);
    if(x == 65535) x = 0; else if (x > 8) x = 8;
    if(y == 65535) y = 0; else if (y > 8) y = 8;
  }
}

void digTile(Cursor c)
{
  if(gameMap_visible[c.x][c.y] == 9 || gameMap_visible[c.x][c.y] == 12)
    return;
  char tile = gameMap[c.x][c.y];
  
  if(tile == 11)
  {
    println("Digged a... MINE!");
    showBoard();
    endRound(2);
    return;
  }
    
  int mineCount = 0;
  if(c.x != 0 && gameMap[c.x-1][c.y] == 11)
    mineCount++;
  if(c.x != 8 && gameMap[c.x+1][c.y] == 11)
    mineCount++;
  if(c.y != 0 && gameMap[c.x][c.y-1] == 11)
    mineCount++;
  if(c.y != 8 && gameMap[c.x][c.y+1] == 11)
    mineCount++;
  if(c.x != 0 && c.y != 0 && gameMap[c.x-1][c.y-1] == 11)
    mineCount++;
  if(c.x != 8 && c.y != 0 && gameMap[c.x+1][c.y-1] == 11)
    mineCount++;
  if(c.x != 0 && c.y != 8 && gameMap[c.x-1][c.y+1] == 11)
    mineCount++;
  if(c.x != 8 && c.y != 8 && gameMap[c.x+1][c.y+1] == 11)
    mineCount++;
      
  println("Digged a tile... there are " + mineCount + " near!");
  gameMap_visible[c.x][c.y] = (char)mineCount;
  
  
  if(tile == 0 && mineCount == 0)
  {
    if(c.x != 0 && gameMap[c.x-1][c.y] != 11 && gameMap_visible[c.x-1][c.y] == 13)
      digTile(new Cursor(c.x-1,c.y));
    if(c.x != 8 && gameMap[c.x+1][c.y] != 11 && gameMap_visible[c.x+1][c.y] == 13)
      digTile(new Cursor(c.x+1,c.y));
    if(c.y != 0 && gameMap[c.x][c.y-1] != 11 && gameMap_visible[c.x][c.y-1] == 13)
      digTile(new Cursor(c.x,c.y-1));
    if(c.y != 8 && gameMap[c.x][c.y+1] != 11 && gameMap_visible[c.x][c.y+1] == 13)
      digTile(new Cursor(c.x,c.y+1));
    if(c.x != 0 && c.y != 0 && gameMap[c.x-1][c.y-1] != 11 && gameMap_visible[c.x-1][c.y-1] == 13)
      digTile(new Cursor(c.x-1,c.y-1));
    if(c.x != 8 && c.y != 0 && gameMap[c.x+1][c.y-1] != 11 && gameMap_visible[c.x+1][c.y-1] == 13)
      digTile(new Cursor(c.x+1,c.y-1));
    if(c.x != 0 && c.y != 8 && gameMap[c.x-1][c.y+1] != 11 && gameMap_visible[c.x-1][c.y+1] == 13)
      digTile(new Cursor(c.x-1,c.y+1));
    if(c.x != 8 && c.y != 8 && gameMap[c.x+1][c.y+1] != 11 && gameMap_visible[c.x+1][c.y+1] == 13)
      digTile(new Cursor(c.x+1,c.y+1));
  }
}

void markTile()
{
  if( gameMap_visible[cursor.x][cursor.y] == 13)
    gameMap_visible[cursor.x][cursor.y] = 9;
  else if( gameMap_visible[cursor.x][cursor.y] == 9 )
    gameMap_visible[cursor.x][cursor.y] = 13;
}

void showBoard()
{
  for(int y = 0; y < 9; y++)
    for(int x = 0; x < 9; x++)
      if( gameMap[x][y] == 11 )
        gameMap_visible[x][y] = 11; 
}

/*
  Returns 0 if board is still playable
  Returns 1 if board has been beaten  
  Returns -1 if mine has been digged
*/
int checkGameStatus()
{
  for(int y = 0; y < 9; y++)
    for(int x = 0; x < 9; x++)
    {
      if(gameMap_visible[x][y] == 11) //There's a bomb digged, returning -1
        return -1;
      if((gameMap_visible[x][y] != 9 && gameMap[x][y] == 11) || gameMap_visible[x][y] == 13 || (gameMap_visible[x][y] == 9 && gameMap[x][y] != 11)) //There's a unmarked bomb, return 0
        return 0;
    }
  return 1;
}

void endRound(int mode) //mode = 1, win; mode = 2, fail
{
  if(mode == 1)
    subscene = 1;
  else
    subscene = 2;
    
  timer_rt = time_wait;
  if(scalarDifficulty < 7) scalarDifficulty++;
  
  println("Board ended in state " + checkGameStatus());
}

void newClassicGame()
{
  cursor = new Cursor(0,0);
  timer[1] = 0; timer[0] = 0; timer_rt = 0;
  scene = 1; subscene = 0;
  gameMode = 0;
  generateMap(4);
}

void newTimedGame()
{
  cursor = new Cursor(0,0);
  timer[1] = 5; timer[0] = 0; timer_rt = 5*60;
  scene = 1; subscene = 0;
  gameMode = 1;
  println("New Timed Game! Difficulty: " + scalarDifficulty);
  generateMap(scalarDifficulty);
  
  switch(scalarDifficulty) {
    case 3:
      stop_music();
      music_medium.loop();
      break;
    case 5:
      stop_music();
      music_hard.loop();
      break;
    case 7:
      stop_music();
      music_fucked.loop();
      break;
  }
}
