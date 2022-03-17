int minesMult = 6; //8 orig
int rockMult = 4; //4 orig

void generateMap(int d) //d: difficulty
{
  println("[Generator] Clearing board...");
  gameMap_visible = new char[9][9];
  for(int y = 0; y < 9; y++)
    for(int x = 0; x < 9; x++)
      gameMap_visible[x][y] = 13;
  gameMap = new char[9][9];
  if(d < 0 || d > 7)
  {
    println("[ERROR] To generate a board, difficulty must be between 0 and 7 (Not " + d + ")");
    return;  
  }
  println("[Generator] Generating board (Difficulty " + d + ")");
  boolean finished = false;
  while(!finished)
  {
    println("[Generator] Generating rocks...");
    for(int y = 0; y < 9; y++)
      for(int x = 0; x < 9; x++)
      {
        if(random(0,255) < (8-(d + 1))*rockMult && gameMap[x][y] != 11)
        {
          gameMap[x][y] = 12;
          gameMap_visible[x][y] = 12;
        }
      }
    println("[Generator] Generating mines...");
    for(int y = 0; y < 9; y++)
      for(int x = 0; x < 9; x++)
      {
        if(random(0,255) < (d + 1)*minesMult && gameMap[x][y] != 12)
          gameMap[x][y] = 11;
      }
      
    println("[Generator] Checking validity...");
    for(int y = 0; y < 9; y++)
      for(int x = 0; x < 9; x++)
      {
        if (gameMap[x][y] == 11)
        {
          finished = true;
          break;  
        }
      }
  }
    
  
  println("[Generator] Board generated!");
}
