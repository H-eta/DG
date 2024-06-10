PImage[] headImages = new PImage[9];  // character head
PImage[] bodyImages = new PImage[6];  // character body
PImage selectedHeadImage;
PImage selectedBodyImage;

PImage[] character = new PImage[2];

float[] character_imageX = new float[2];
float[] character_imageY = new float[2];

float [] character_width = new float[2];
float [] character_height = new float[2];

float maxImageWidth = 150; // largura max p img
float headY, bodyY;
boolean animationComplete = false;
float headTargetY, bodyTargetY; // final position
float linhaY;


PImage[] images = new PImage[5]; // array to hold the images
int numImages = 5;

PImage[] back_images = new PImage[4]; // array to hold the background images
int num_back_Images = 4;

// arrays to store the random positions of the images
float[] imageX = new float[numImages];
float[] imageY = new float[numImages];

float[] back_imageX = new float[num_back_Images];
float[] back_imageY = new float[num_back_Images];

// curtain Animation variables
PImage[] curtainFrames = new PImage[20]; // array to hold the animation frames
int curtainCurrentFrame = 0;
boolean curtainAnimationPlaying = false; // flag to indicate if the curtain animation is playing
boolean curtainAnimationEnded = false; // flag to indicate if the curtain animation has ended

int curtainClosingCurrentFrame = curtainFrames.length - 1;
boolean curtainClosingAnimationPlaying = false; // flag to indicate if the curtain animation is playing
boolean curtainClosingAnimationEnded = false; // flag to indicate if the curtain animation has ended

// curtain clickable thingy
PImage[] click_thingy = new PImage[2];
int num_click_thingy = 1;
int click_flag = 0;

PImage moon;
float moonX, moonY;
float targetMoonY;

boolean floor_disappear_flag = false;
boolean curtain_closing_flag = false;

// floor images
PImage[] floor_images = new PImage[2]; // array to hold the floor images
int num_floor_images = 2;
float[] rand_floor_left_images_x = new float[num_floor_images];
float[] rand_floor_right_images_x = new float[num_floor_images];
float[] rand_floor_images_y = new float[num_floor_images];


float[] current_floor_left_images_x = new float[num_floor_images];
float[] current_floor_right_images_x = new float[num_floor_images];
float[] current_floor_images_y = new float[num_floor_images];

// arrays to store random positions for scenario images
float[] rand_imageX = new float[numImages];
float[] rand_imageY = new float[numImages];

float[] rand_back_imageX = new float[num_back_Images];
float[] rand_back_imageY = new float[num_back_Images];

float animationProgress = 0.0; // tracks the progress of the animation (0.0 to 1.0)
boolean animatingDown = true; // direction of animation

int startTime = 0;
int aux_light_timer = 0;
int light_timer = 0;

PImage light; // image for the light
boolean lightVisible = false; // flag to indicate if the light should be visible
int lightOpacity = 0; // start with 0 opacity
int fadeInSpeed = 30; // speed of the fade-in effect
int fadeOutSpeed = 30; // speed of the fade-out effect

// variables for controlling the shadow effect
int shadowAlpha = 100; // opacity of the shadow
int shadowOffset = 2; // offset of the shadow

PImage[] scissorFrames = new PImage[21]; // array to hold the animation frames
int scissorCurrentFrame = 0;
boolean scissorAnimationPlaying = false; // flag to indicate if the scissor animation is playing

ArrayList<PImage> frames;
boolean isSaving = false;


void settings() {
  size(displayWidth, displayHeight);
  fullScreen();
}

void setup() {
  loadImages(); // load the images from the folder
  loadCurtainFrames(); // load curtain animation frames
  generateRandomPositions(); // generate initial random positions
  loadScissorFrames(); // load scissor animation frames
  
  loadHeadImages();
  loadBodyImages();
  selectRandomHeadImage(); // selected a random head
  selectRandomBodyImage(); // selected a random body
  initializeAnimation();
  
  // initialize current positions off-screen to start the animation
  current_floor_left_images_x[0] = -floor_images[0].width;
  current_floor_right_images_x[1] = displayWidth;
  for (int i = 0; i < num_floor_images; i++) {
    current_floor_images_y[i] = displayHeight + floor_images[i].height;
  }
  
  for (int i = 0; i < numImages; i++) {
    if (rand_imageX[i] < displayWidth / 2) {
      // For images on the left side
      imageX[i] = -images[i].width*2;
    } else {
      // For images on the right side
      imageX[i] = displayWidth + images[i].width*2;
    }
    // For both sides
    if (i == 0 || i == 1 || i == 2){
      imageY[i] = random(rand_floor_images_y[0] - images[i].height/4, displayHeight - 2*images[i].height);
    } else if (i == 3 || i == 4){
      imageY[i] = random(displayHeight - images[i].height, displayHeight - images[i].height/2);
    }
  }  
  
  
  for (int i = 0; i < num_back_Images; i++) {
    if (rand_back_imageX[i] < displayWidth / 2) {
      // For images on the left side
      back_imageX[i] = -back_images[i].width*2;
    } else {
      // For images on the right side
      back_imageX[i] = displayWidth + back_images[i].width*2;
    }
    // For both sides
    if (i == 0 || i == 1){
      back_imageY[i] = random(rand_floor_images_y[0] - back_images[i].height/2, rand_floor_images_y[0]);
    } else if (i == 3 || i == 2) {
      back_imageY[i] = random(rand_floor_images_y[0] - back_images[i].height/3, rand_floor_images_y[0] - back_images[i].height/2);
    }
  }    
  
  frames = new ArrayList<PImage>();
  frameRate(30);
  
}

void animateClickThingy() {
  // animation progress based on direction
  if (animatingDown) {
    animationProgress += 0.04;
    if (animationProgress >= 1.0) {
      animationProgress = 1.0;
      animatingDown = false;
    }
  } else {
    animationProgress -= 0.04;
    if (animationProgress <= 0.0) {
      animationProgress = 0.0;
      curtainAnimationPlaying = true; // start the curtain animation
    }
  }

  // new height of the click_thingy image based on the animation progress
  float maxHeight = click_thingy[0].height * 1.2;
  float newHeight = click_thingy[0].height + (maxHeight - click_thingy[0].height) * animationProgress;

  // yPosition based on the animation progress
  float originalYPosition = 0 - click_thingy[0].height / 6;
  float yPosition;
  if (animatingDown) {
    yPosition = originalYPosition;
  } else {
    yPosition = originalYPosition - (1.0 - animationProgress) * click_thingy[0].height;
  }

  image(click_thingy[0], 0, yPosition, click_thingy[0].width, newHeight);
}

void draw() {
  background(21,24,27); // background color
  
  
  if (click_flag == 0){
    image(curtainFrames[0], 0, 0);
    image(click_thingy[0], 0, 0 - click_thingy[0].height / 6);
  }
  else if (click_flag == 1){
    if (!curtainAnimationPlaying && !curtainAnimationEnded) {
      image(curtainFrames[0], 0, 0);
    }
    animateClickThingy();
    aux_light_timer = millis();
  }
  
  // check if the curtain animation is still playing
  if (curtainAnimationPlaying && click_flag == 1) {
    if (!curtain_closing_flag){
      image(curtainFrames[curtainCurrentFrame], 0, 0);
    }
    curtainCurrentFrame++; // next frame
    if (curtainCurrentFrame >= curtainFrames.length) {
      // if it reaches the last frame, stop the animation
      curtainCurrentFrame = curtainFrames.length - 1;
      curtainAnimationPlaying = false;
      curtainAnimationEnded = true;
    }
  }
    
  // display other elements if curtain animation has ended
  if (curtainAnimationEnded) {
    if (!floor_disappear_flag){
      
      float new_moon_Width = moon.width * 0.9;
      float new_moon_Height = moon.height * 0.9;
      // moon
      moonY = lerp(moonY, targetMoonY, 0.3);
      image(moon, moonX, moonY, new_moon_Width, new_moon_Height);
      
      // update current positions smoothly towards target positions
      current_floor_left_images_x[0] = lerp(current_floor_left_images_x[0], rand_floor_left_images_x[0], 0.3);
      current_floor_right_images_x[1] = lerp(current_floor_right_images_x[1], rand_floor_right_images_x[1], 0.3);
      for (int i = 0; i < num_floor_images; i++) {
        current_floor_images_y[i] = lerp(current_floor_images_y[i], rand_floor_images_y[i], 0.3);
      }
      
      for (int i = 0; i < numImages; i++) {
        if (imageX[i] < displayWidth / 2) {
          imageX[i] = lerp(imageX[i], rand_imageX[i], 0.3);
        } else {
          imageX[i] = lerp(imageX[i], rand_imageX[i], 0.3);
        }
        imageY[i] = lerp(imageY[i], rand_imageY[i], 0.3);
      }
      
      for (int i = 0; i < num_back_Images; i++) {
        if (back_imageX[i] < displayWidth / 2) {
          back_imageX[i] = lerp(back_imageX[i], rand_back_imageX[i], 0.3);
        } else {
          back_imageX[i] = lerp(back_imageX[i], rand_back_imageX[i], 0.3);
        }
        back_imageY[i] = lerp(back_imageY[i], rand_back_imageY[i], 0.3);
      }

      if (lightVisible || lightOpacity > 0){
        // loop through each scenario image
        for (int i = 0; i < numImages; i++) {
          // distance between mouse/light image and scenario image center
          float imageCenterX = imageX[i] + images[i].width / 2;
          float imageCenterY = imageY[i] + images[i].height / 2;
          float distance = dist(mouseX, mouseY, imageCenterX, imageCenterY);
          
          // Calculate opacity and size based on distance
          float shadowAlpha = map(distance, 0, 100, 255, 0); // map distance to alpha (closer = more opaque)
          
          float shadowSize_x = images[i].width;
          float shadowSize_y = images[i].height;
          float shadowX = imageX[i];
          float shadowY = imageY[i];
          
          // check if the distance is within a certain threshold to show shadow
          if (distance < 100 && lightVisible) {
            shadowSize_x *= 1.5; // Increase shadow size
            shadowSize_y *= 1.5;
            shadowY -= (shadowSize_x - images[i].width) / 2;
            shadowX -= (shadowSize_x - images[i].width) / 2;
          } else {
              shadowX = imageX[i];
          }
          // check if the image is flipped
          if (imageX[i] < displayWidth / 2) {
            pushMatrix();
            scale(-1, 1);
            shadowX = -shadowX - shadowSize_x;
        }
          // draw a semi-transparent version of the scenario image to create a shadow effect
          tint(0, shadowAlpha);
          image(images[i], shadowX, shadowY, shadowSize_x, shadowSize_y);
          noTint();
          
          // restore original transformation if the image was flipped
          if (imageX[i] < displayWidth / 2) {
              popMatrix();
          }
        }
        
        for (int i = 0; i < num_back_Images; i++) {
          float back_imageCenterX = back_imageX[i] + back_images[i].width / 2;
          float back_imageCenterY = back_imageY[i] + back_images[i].height / 2;
          float back_distance = dist(mouseX, mouseY, back_imageCenterX, back_imageCenterY);
          
          float back_shadowAlpha = map(back_distance, 0, 100, 255, 0);
          
          float back_shadowSize_x = back_images[i].width;
          float back_shadowSize_y = back_images[i].height;
          float back_shadowX = back_imageX[i];
          float back_shadowY = back_imageY[i];
          
          if (back_distance < 100 && lightVisible) {
            back_shadowSize_x *= 1.5;
            back_shadowSize_y *= 1.5;
            back_shadowY -= (back_shadowSize_x - back_images[i].width) / 2;
            back_shadowX -= (back_shadowSize_x - back_images[i].width) / 2;
          } else {
              back_shadowX = back_imageX[i];
          }

          if (back_imageX[i] < displayWidth / 2) {
            pushMatrix();
            scale(-1, 1);
            back_shadowX = -back_shadowX - back_shadowSize_x;
        }

          tint(0, back_shadowAlpha);
          image(back_images[i], back_shadowX, back_shadowY, back_shadowSize_x, back_shadowSize_y);
          noTint();
          
          if (back_imageX[i] < displayWidth / 2) {
              popMatrix();
          }
        }
      }
      
      pushMatrix();
      translate(current_floor_left_images_x[0] + floor_images[0].width, current_floor_images_y[0]);
      scale(-1, 1);
      image(floor_images[0], 0, 0);
      popMatrix();
      
      
      for (int i = 0; i < num_back_Images; i++) {
        if (back_imageX[i] < displayWidth / 2) {
          pushMatrix();
          scale(-1, 1);
          image(back_images[i], -back_imageX[i] - back_images[i].width, back_imageY[i]);
          popMatrix();
        }
      }
      
      for (int i = 0; i < numImages; i++) {
        float newWidth = images[i].width;
        float newHeight = images[i].height;
        if (imageX[i] < displayWidth / 2) {
          pushMatrix();
          scale(-1, 1);
          image(images[i], -imageX[i] - images[i].width, imageY[i], newWidth, newHeight);
          popMatrix();
        }
      }
      
      image(floor_images[1], current_floor_right_images_x[1], current_floor_images_y[1]);
      
      for (int i = 0; i < num_back_Images; i++) {
        if (back_imageX[i] >= displayWidth / 2) {
          image(back_images[i], back_imageX[i], back_imageY[i]);
        }
      }
      
      for (int i = 0; i < numImages; i++) {
        float newWidth = images[i].width;
        float newHeight = images[i].height;
        if (imageX[i] >= displayWidth / 2) {
          image(images[i], imageX[i], imageY[i], newWidth, newHeight);
        }
      }
      
      if (millis() - light_timer > 7000 && millis() - light_timer < 25000) {  // give some time for things to be positioned
        lightVisible = true;
      }
      
      // update the opacity of the light image if it's visible
      if (lightVisible && lightOpacity < 255) {
        lightOpacity += fadeInSpeed; // increase opacity gradually
      }
      
      if (!lightVisible && lightOpacity > 0) {
        lightOpacity -= fadeOutSpeed; // decrease opacity gradually
      }
      
      if (millis() - light_timer >= 25000){
        lightVisible = false;
        scissorAnimationPlaying = true;
      }
      
      
      for (int i = 0; i < 1; i++){
        float character_head_imageCenterX = character_imageX[0];
        float character_head_imageCenterY = character_imageY[0] + character_height[0] / 2;
        
        float head_distance = dist(mouseX, mouseY, character_head_imageCenterX, character_head_imageCenterY);
        
        float character_head_shadowAlpha = map(head_distance, 0, 100, 255, 0);
               
        float character_head_shadowSize_x = character_width[0];
        float character_head_shadowSize_y = character_height[0];
        float character_head_shadowX = character_imageX[0];
        float character_head_shadowY = character_imageY[0];
        
        
        if (head_distance < 100 && lightVisible) {
          character_head_shadowSize_x *= 1.5;
          character_head_shadowSize_y *= 1.5;
          character_head_shadowY -= (character_head_shadowSize_x - character_height[0]) / 2;
          character_head_shadowX -= (character_head_shadowSize_x - character_width[0]) / 2;
        }
        
        tint(0, character_head_shadowAlpha);
        image(selectedHeadImage, character_head_shadowX, character_head_shadowY, character_head_shadowSize_x, character_head_shadowSize_y);
        noTint();
      }
      
      for (int i = 0; i < 1; i++) {
        float character_body_imageCenterX = character_imageX[1];
        float character_body_imageCenterY = character_imageY[1];
        
        float body_distance = dist(mouseX, mouseY, character_body_imageCenterX, character_body_imageCenterY);

        float character_body_shadowAlpha = map(body_distance, 0, 100, 255, 0);

        float character_body_shadowSize_x = character_width[1];
        float character_body_shadowSize_y = character_height[1];
        float character_body_shadowX = character_imageX[1];
        float character_body_shadowY = character_imageY[1];
        
        if (body_distance < 100 && lightVisible) {
          character_body_shadowSize_x *= 1.5;
          character_body_shadowSize_y *= 1.5;
          character_body_shadowY -= (character_body_shadowSize_x - character_height[1]/2) / 2;
          character_body_shadowX -= (character_body_shadowSize_x - character_width[1]) / 2;
        }
        
        tint(0, character_body_shadowAlpha);
        image(selectedBodyImage, character_body_shadowX, character_body_shadowY, character_body_shadowSize_x, character_body_shadowSize_y);
        noTint();
      }
      
      
      if (!animationComplete) {
        animateImages();
      }
    
      displayImages();
      
      if (lightVisible || lightOpacity > 0){
        tint(255, lightOpacity);
        image(light, mouseX, mouseY);
        noTint();
      }
      
      if (scissorAnimationPlaying) {
        float xPos;
        
        if (scissorCurrentFrame < scissorFrames.length) {
            xPos = map(scissorCurrentFrame, 0, scissorFrames.length - 1, displayWidth, -scissorFrames[0].width);
        } else {
            int reversedFrame = scissorFrames.length * 2 - scissorCurrentFrame - 1;
            xPos = map(reversedFrame, 0, scissorFrames.length - 1, displayWidth, -scissorFrames[0].width);
        }
        
        image(scissorFrames[scissorCurrentFrame % scissorFrames.length], xPos, 50);
        
        scissorCurrentFrame += 2;
    
        if (scissorCurrentFrame >= scissorFrames.length * 2) {
            scissorAnimationPlaying = false;
        }
        if (xPos < 0){
            floor_disappear_flag = true;
        }
        
        if (xPos <= displayWidth*2/3) {
          if (bodyY < displayHeight) {
            bodyY += 120;
          }
          if (headY < displayHeight) {
            headY += 120;
          }
          if (linhaY < displayHeight) {
            linhaY += 120;
          }
        }
      }
      
    } else if (floor_disappear_flag) {
      // move floor images off the screen
      current_floor_left_images_x[0] = lerp(current_floor_left_images_x[0], -floor_images[0].width, 0.05);
      current_floor_right_images_x[1] = lerp(current_floor_right_images_x[1], displayWidth, 0.05);
      for (int i = 0; i < num_floor_images; i++) {
        current_floor_images_y[i] = lerp(current_floor_images_y[i], displayHeight + floor_images[i].height, 0.05);
      }
      for (int i = 0; i < numImages; i++) {
        if (rand_imageX[i] < displayWidth / 2) {
          imageX[i] = lerp(imageX[i], -images[i].width * 2, 0.05);
        } else {
          imageX[i] = lerp(imageX[i], displayWidth + images[i].width * 2, 0.05);
        }
        imageY[i] = lerp(imageY[i], imageY[i], 0.05);
      }
      
      for (int i = 0; i < num_back_Images; i++) {
        if (rand_back_imageX[i] < displayWidth / 2) {
          back_imageX[i] = lerp(back_imageX[i], -back_images[i].width * 2, 0.05);
        } else {
          back_imageX[i] = lerp(back_imageX[i], displayWidth + back_images[i].width * 2, 0.05);
        }
        back_imageY[i] = lerp(back_imageY[i], back_imageY[i], 0.05);
      }
      
      // moon moving upwards
      moonY = lerp(moonY, -moon.height*2, 0.05);
      
      image(moon, moonX, moonY);
      
      pushMatrix();
      translate(current_floor_left_images_x[0] + floor_images[0].width, current_floor_images_y[0]);
      scale(-1, 1);
      image(floor_images[0], 0, 0);
      popMatrix();
      
      for (int i = 0; i < num_back_Images; i++) {
        if (back_imageX[i] < displayWidth / 2) {
          pushMatrix();
          scale(-1, 1);
          image(back_images[i], -back_imageX[i] - back_images[i].width, back_imageY[i]);
          popMatrix();
        }
      }
      
      for (int i = 0; i < numImages; i++) {
        float newWidth = images[i].width;
        float newHeight = images[i].height;
        if (imageX[i] < displayWidth / 2) {
          pushMatrix();
          scale(-1, 1);
          image(images[i], -imageX[i] - images[i].width, imageY[i], newWidth, newHeight);
          popMatrix();
        }
      }
      
      image(floor_images[1], current_floor_right_images_x[1], current_floor_images_y[1]);
      
      for (int i = 0; i < num_back_Images; i++) {
        if (back_imageX[i] >= displayWidth / 2) {
          image(back_images[i], back_imageX[i], back_imageY[i]);
        }
      }
      
      for (int i = 0; i < numImages; i++) {
        float newWidth = images[i].width;
        float newHeight = images[i].height;
        if (imageX[i] >= displayWidth / 2) {
          image(images[i], imageX[i], imageY[i], newWidth, newHeight);
        }
      }
    }
    
    if (millis() - light_timer > 28000) {
        curtain_closing_flag = true;
        curtainClosingAnimationPlaying=true;
      }
    
    
    // curtains closing
    if (curtainClosingAnimationPlaying){
      image(curtainFrames[curtainClosingCurrentFrame], 0, 0);
      curtainClosingCurrentFrame--;
      if (curtainClosingCurrentFrame <= 0) {
        curtainClosingCurrentFrame = 0;
        curtainClosingAnimationPlaying = false;
        curtainClosingAnimationEnded = true;
      }
    }
    
    if (!curtain_closing_flag) {
      image(curtainFrames[curtainFrames.length - 1], 0, 0);
    }
  }

  frames.add(get());

  if (curtainClosingAnimationEnded) {
    noLoop();
    isSaving = true;
    thread("saveFrames");
  }
}

void saveFrames() {
  for (int i = 0; i < frames.size(); i++) {
    frames.get(i).save("animation_name-" + nf(i, 6) + ".png");
  }
  isSaving = false;
}

void keyPressed() {
  if (key == ESC) {
    exit();
  }
}

void mousePressed() {
  // check if the mouse is clicked within the curtain thingy area
  if (mouseX > 0 && mouseX < click_thingy[0].width && mouseY > 0 && mouseY < click_thingy[0].height && click_flag == 0) {
    click_flag = 1;
    light_timer = millis();
  }
}

void loadImages() {
  for (int i = 0; i < numImages; i++) {
    String imageName;
    imageName = "images/image" + (i) + ".png";
    PImage load_image = loadImage(imageName);
    load_image.resize(int(2*load_image.width), int(2*load_image.height));
    images[i] = load_image;
  }
  
  for (int i = 0; i < num_back_Images; i++) {
    String imageName;
    imageName = "back_images/image" + (i) + ".png";
    PImage load_image = loadImage(imageName);
    load_image.resize(int(load_image.width), int(load_image.height));
    back_images[i] = load_image;
  }
  
  for (int i = 0; i < num_click_thingy; i++) {
    String imageName_2;
    imageName_2 = "click_thingy" + ".png";
    click_thingy[i] = loadImage(imageName_2);
  }
  
  for (int i = 0; i < num_floor_images; i++) {
    String imageName_3;
    imageName_3 = "floor_image/mountain" + ".png";
    PImage floor_i = loadImage(imageName_3);
    floor_i.resize(displayWidth, floor_i.height/3);
    floor_images[i] = floor_i;
  }
  
  moon = loadImage("moon.png");
  light = loadImage("light.png");
}

void loadCurtainFrames() {  
  for (int i = 0; i < curtainFrames.length; i++) {
    String imageName = "new_curtain_animation/frame" + nf(i, 4) + ".png";
    PImage frame = loadImage(imageName);
    frame.resize(displayWidth, displayHeight);
    curtainFrames[i] = frame;
  }
}

void loadScissorFrames() {
  for (int i = 0; i < scissorFrames.length; i++) {
    String imageName = "new_scissor_animation/frame" + nf(i, 4) + ".png";
    PImage scissor_frame = loadImage(imageName);
    scissor_frame.resize(scissor_frame.width/4, scissor_frame.height/4);
    scissorFrames[i] = scissor_frame;
    
  }
}

// function to check if two images overlap
boolean checkOverlap(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  return (x1 < x2 + w2 && x1 + w1/2 > x2 && y1 < y2 + h2 && y1 + h1/2 > y2);
}

void adjustPositions() {
  boolean adjusted = true;

  // loop until no more adjustments are needed
  while (adjusted) {
    adjusted = false;

    for (int i = 0; i < numImages - 2 - 1; i++) {
      for (int j = i + 1; j < numImages; j++) {
        if (checkOverlap(rand_imageX[i], rand_imageY[i], images[i].width, images[i].height, 
                         rand_imageX[j], rand_imageY[j], images[j].width, images[j].height)) {
          
          boolean foundNewPosition = false;
          while (!foundNewPosition) {
            float newX = random(curtainFrames[curtainFrames.length - 1].width / 8, displayWidth - curtainFrames[curtainFrames.length - 1].width / 8 - images[i].width);
            float newY = rand_imageY[i];
            
            boolean overlaps = false;
            for (int k = 0; k < numImages; k++) {
              if (k != i && checkOverlap(newX, newY, images[i].width, images[i].height, 
                                         rand_imageX[k], rand_imageY[k], images[k].width, images[k].height)) {
                overlaps = true;
                break;
              }
            }
            
            if (!overlaps) {
              rand_imageX[i] = newX;
              foundNewPosition = true;
              adjusted = true;
            }
          }
        }
      }
    }
  }
}

void generateRandomPositions() {   
  rand_floor_left_images_x[0] = random(- floor_images[0].width/6, - floor_images[0].width/20);
  rand_floor_right_images_x[1] = random(displayWidth - floor_images[1].width + floor_images[1].width/6, displayWidth - floor_images[1].width + floor_images[1].width/8);
  for (int i = 0; i < num_floor_images; i++){
    rand_floor_images_y[i] = random(displayHeight + floor_images[i].height/4 - floor_images[i].height, displayHeight + floor_images[i].height/8 - floor_images[i].height);
  }
  
  for (int i = 0; i < numImages; i++) {
    int randomInt = int(random(2));
    if (randomInt == 0) {
      rand_imageX[i] = random(curtainFrames[curtainFrames.length - 1].width/8 + images[i].width, displayWidth/2 - images[i].width);
    } else {
      rand_imageX[i] = random(displayWidth/2, displayWidth - curtainFrames[curtainFrames.length - 1].width/8 - 2*images[i].width);
    }
    if (i == 0 || i == 1 || i == 2){
      rand_imageY[i] = random(rand_floor_images_y[0] - images[i].height/4, displayHeight - 2*images[i].height);
    } else if (i == 3 || i == 4){
      rand_imageY[i] = random(displayHeight - int(images[i].height/1.5), displayHeight - images[i].height/2);
    }
  }
  
  for (int i = 0; i < num_back_Images; i++) {
    int randomInt = int(random(2));
    if (randomInt == 0) {
      if (i == 0 || i == 1){
        rand_back_imageX[i] = random(curtainFrames[curtainFrames.length - 1].width/8, displayWidth/2 - back_images[i].width);
      } else if (i == 2) {
        rand_back_imageX[i] = random(curtainFrames[curtainFrames.length - 1].width/8, curtainFrames[curtainFrames.length - 1].width/8 + back_images[i].width);
      } else if (i == 3) {
        rand_back_imageX[i] = rand_back_imageX[2] + back_images[i].width/2;
      }
    } else {
      if (i == 0 || i == 1){
        rand_back_imageX[i] = random(displayWidth/2, displayWidth - curtainFrames[curtainFrames.length - 1].width/8 - back_images[i].width);
      } else if (i == 2) {
        rand_back_imageX[i] = random(displayWidth/2 + back_images[i].width, displayWidth - curtainFrames[curtainFrames.length - 1].width/8 - back_images[i].width);
      } else if (i == 3) {
        rand_back_imageX[i] = rand_back_imageX[2] - back_images[i].width/2;
      }
    }
    if (i == 0 || i == 1){
      rand_back_imageY[i] = random(rand_floor_images_y[0] - back_images[i].height/3, rand_floor_images_y[0]);
    } else if (i == 3 || i == 2) {
      rand_back_imageY[i] = random(rand_floor_images_y[0] - back_images[i].height/2, rand_floor_images_y[0] - back_images[i].height/4);
    }
  }
  
  // after generating positions -> adjust positions to avoid overlap
  adjustPositions();
  
  moonX = random(curtainFrames[curtainFrames.length - 1].width/8, displayWidth - curtainFrames[curtainFrames.length - 1].width/8 - moon.width * 0.8);
  targetMoonY = random(0, rand_floor_left_images_x[0]);
  moonY = -moon.height*2;
  
}

void initializeAnimation() {

  headY = -maxImageWidth-270;
  bodyY = -maxImageWidth-200;

  // proportions and size
  float headAspectRatio = selectedHeadImage.height / (float) selectedHeadImage.width;
  float headWidth = maxImageWidth * 0.8; // resize head size
  float headHeight = headWidth * headAspectRatio;

  float bodyAspectRatio = selectedBodyImage.height / (float) selectedBodyImage.width;
  float bodyWidth = maxImageWidth;
  float bodyHeight = bodyWidth * bodyAspectRatio;

  // positions to center
  headTargetY = (height - headHeight - bodyHeight) / 2; // final head position
  bodyTargetY = headTargetY + headHeight;

  // special adjustment for head1
  if (selectedHeadImage == headImages[0]) { // if selected image is head1
    headTargetY += maxImageWidth * 0.5; // move it a bit down
  }

  if (selectedHeadImage == headImages[8]) {
    headTargetY += maxImageWidth * 0.15;
  }

  animationComplete = false;
}

void animateImages() {
  // animation speed
  float speed = 80;

  if (headY < headTargetY) {
    headY += speed;
    if (headY > headTargetY) {
      headY = headTargetY;
    }
  }

  if (bodyY < bodyTargetY) {
    bodyY += speed;
    if (bodyY > bodyTargetY) {
      bodyY = bodyTargetY;
    }
  }

  if (headY == headTargetY && bodyY == bodyTargetY) {
    animationComplete = true;
  }
}

void displayImages() {
  float headAspectRatio = selectedHeadImage.height / (float) selectedHeadImage.width; // width-height proportion
  float headWidth = maxImageWidth * 0.8;
  float headHeight = headWidth * headAspectRatio;

  float bodyAspectRatio = selectedBodyImage.height / (float) selectedBodyImage.width;
  float bodyWidth = maxImageWidth; // maximum body width
  float bodyHeight = bodyWidth * bodyAspectRatio;

  float headCenterX = (displayWidth - headWidth) / 2;
  float bodyCenterX = (displayWidth - bodyWidth) / 2;
  
  if (selectedBodyImage == bodyImages[5]) { 
    bodyCenterX -= 20; 
  }

  // line
  stroke(250);
  strokeWeight(2);
  float headMiddleX = headCenterX + headWidth / 2;
  line(headMiddleX, linhaY, headMiddleX, headY+20);

  image(selectedBodyImage, bodyCenterX, bodyY, bodyWidth, bodyHeight);

  image(selectedHeadImage, headCenterX, headY, headWidth, headHeight);
  
  character_imageX[0] = headCenterX;
  character_imageY[0] = headY;
  character_imageX[1] = bodyCenterX;
  character_imageY[1] = bodyY;
  
  character_width[0] = headWidth;
  character_height[0] = headHeight;
  character_width[1] = bodyWidth;
  character_height[1] = bodyHeight;
}

void loadHeadImages() {
  String[] headImageNames = { "head/head1.png", "head/head2.png", "head/head3.png", "head/head4.png", "head/head5.png", "head/head6.png", "head/head7.png", "head/head8.png", "head/head9.png" };
  for (int i = 0; i < headImages.length; i++) {
    headImages[i] = loadImage(headImageNames[i]);
  }
}

void loadBodyImages() {
  String[] bodyImageNames = { "body/body1.png", "body/body2.png", "body/body3.png", "body/body4.png", "body/body5.png", "body/body6.png"   };
  for (int i = 0; i < bodyImages.length; i++) {
    bodyImages[i] = loadImage(bodyImageNames[i]);
  }
}

void selectRandomHeadImage() {
  int randomIndex = int(random(0, headImages.length));
  selectedHeadImage = headImages[randomIndex];
}

void selectRandomBodyImage() {
  int randomIndex = int(random(0, bodyImages.length));
  selectedBodyImage = bodyImages[randomIndex];
}
