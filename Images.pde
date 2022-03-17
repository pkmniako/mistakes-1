PImage tex[];
PImage image_debug;

PImage epic_egg;

void loadImages()
{
  tex = new PImage[40];
  println("Loading Textures...");
  tex[0] = loadImage("data/main_background.png"); //main_background
  tex[1] = loadImage("data/main_button_timemode.png"); //main_button_timemode
  tex[2] = loadImage("data/main_button_normalmode.png"); //main_button_normalmode
  tex[3] = loadImage("data/main_copyright.png"); //main_copyright
  tex[4] = loadImage("data/main_text.png"); //main_text
  tex[5] = loadImage("data/main_title.png"); //main_title
  tex[6] = loadImage("data/main_button_selector.png"); //main_button_selector
  
  image_debug = loadImage("data/debug.png"); //debug
  tex[7] = loadImage("data/main_credits.png");
  
  tex[8] = loadImage("data/overlay_sonic.png"); //overlay_sonic
  tex[9] = loadImage("data/overlay_eggman.png"); //overlay_eggman
  tex[10] = loadImage("data/tile_0.png"); //tile_0
  tex[11] = loadImage("data/tile_1.png"); //tile_1
  tex[12] = loadImage("data/tile_2.png"); //tile_2
  tex[13] = loadImage("data/tile_3.png"); //tile_3
  tex[14] = loadImage("data/tile_4.png"); //tile_4
  tex[15] = loadImage("data/tile_5.png"); //tile_5
  tex[16] = loadImage("data/tile_6.png"); //tile_6
  tex[17] = loadImage("data/tile_7.png"); //tile_7
  tex[18] = loadImage("data/tile_8.png"); //tile_8
  tex[19] = loadImage("data/tile_9.png"); //tile_9
  tex[20] = loadImage("data/tile_10.png"); //tile_10
  tex[21] = loadImage("data/tile_11.png"); //tile_11
  tex[22] = loadImage("data/tile_12.png"); //tile_12
  tex[23] = loadImage("data/tile_13.png"); //tile_13
  tex[24] = loadImage("data/tile_14.png"); //tile_14
  
  tex[25] = loadImage("data/clear.png"); //clear
  tex[26] = loadImage("data/timeout.png"); //timeout
  tex[27] = loadImage("data/message_continue.png"); //message_continue
  tex[28] = loadImage("data/overlay_time.png"); //overlay_time
  tex[29] = loadImage("data/overlay_level.png"); //overlay_level
  
  tex[30] = loadImage("data/timer_0.png"); //timer_0
  tex[31] = loadImage("data/timer_1.png"); //timer_1
  tex[32] = loadImage("data/timer_2.png"); //timer_2
  tex[33] = loadImage("data/timer_3.png"); //timer_3
  tex[34] = loadImage("data/timer_4.png"); //timer_4
  tex[35] = loadImage("data/timer_5.png"); //timer_5
  tex[36] = loadImage("data/timer_6.png"); //timer_6
  tex[37] = loadImage("data/timer_7.png"); //timer_7
  tex[38] = loadImage("data/timer_8.png"); //timer_8
  tex[39] = loadImage("data/timer_9.png"); //timer_9
  
  epic_egg = loadImage("data/overlay_eggman_9.png");
  println("Textures Loaded!");
}

PImage rescaleImage(PImage input, float scale)
{
  int newWidth = floor(input.width * scale);
  int newHeight = floor(input.height * scale);
  PImage output = createImage(newWidth, newHeight, RGB);
  
  input.loadPixels();
  output.loadPixels();
  
  for(int y = 0; y < output.height; y++) {
    for(int x = 0; x < output.width; x++) {
      output.pixels[x + (y * output.width)] = input.pixels[floor(x/scale) + (floor(y/scale) * input.width)];
    }
  }
  
  return output;
}

void renderTimerNumbers(int[] timer)
{
  int n2 = timer[1]%10;
  int n1 = timer[1]/10;
  int n4 = timer[0]%10;
  int n3 = timer[0]/10;
  
  render.image(tex[30 + n1],94,7);
  render.image(tex[30 + n2],99,7);
  render.image(tex[30 + n3],106,7);
  render.image(tex[30 + n4],111,7);
}
