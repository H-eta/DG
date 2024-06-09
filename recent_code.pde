PImage[] images = new PImage[7]; // Array to hold the images
int numImages = 7; // Update the number of images
int windowWidth = 800; // Width of the window
int windowHeight = 600; // Height of the window
boolean saveImage = false; // Flag to indicate whether to save the image

// Arrays to store the random positions of the images
float[] imageX = new float[numImages];
float[] imageY = new float[numImages];

// Define boundaries for non-floor image placement
float minXLeft = 50; // Minimum X position for left side
float maxXLeft = windowWidth / 2 - 50; // Maximum X position for left side
float minXRight = windowWidth / 2 + 50; // Minimum X position for right side
float maxXRight = windowWidth - 50; // Maximum X position for right side
float minY = 150; // Minimum Y position
float maxY = 300; // Maximum Y position

// Define boundaries for floor image placement
float floorMinX_left = -400; // Minimum X position for floor images
float floorMaxX_left = windowWidth/2 + 50; // Maximum X position for floor images
float floorMinX_right = windowWidth/2 - 50; // Minimum X position for floor images
float floorMaxX_right = windowWidth - 50; // Maximum X position for floor images

float floorMinY = 300; // Minimum Y position for floor images
float floorMaxY = 600; // Maximum Y position for floor images

// specific vertical boundaries for the scenario curly mountain placement
float minY_3 = 180;
float maxY_3 = 500;

// specific vertical boundaries for the scenario dog grave placement
float minY_2 = 250;
float maxY_2 = 350;

// Curtain Animation variables
PImage[] curtainFrames = new PImage[33]; // Array to hold the animation frames
int curtainCurrentFrame = 0; // Index of the current frame
boolean curtainAnimationPlaying = true; // Flag to indicate if the curtain animation is playing
boolean curtainAnimationEnded = false; // Flag to indicate if the curtain animation has ended

// Curtain clickable thingy
PImage[] click_thingy = new PImage[2];
int num_click_thingy = 2;
int click_flag = 0;

// floor images
PImage[] floor_images = new PImage[2]; // Array to hold the floor images
int num_floor_images = 2; // Update the number of images
float[] rand_floor_left_images_x = new float[num_floor_images];
float[] rand_floor_right_images_x = new float[num_floor_images];
float[] rand_floor_images_y = new float[num_floor_images];


void settings() {
  //size(windowWidth, windowHeight); // Set the size of the window
  size(displayWidth, displayHeight);
  fullScreen();
}

void setup() {
  loadImages(); // Load the images from the folder
  loadCurtainFrames(); // Load curtain animation frames
  generateRandomPositions(); // Generate initial random positions
}

void draw() {
  print(click_flag);
  background(4, 12, 23); // background color
  
  if (click_flag == 0){
    for (int i = 0; i < num_click_thingy; i++){
      image(click_thingy[i], 50, 50);
    }
  }
  
  // Check if the curtain animation is still playing
  if (curtainAnimationPlaying && click_flag == 1) {
    // Display curtain animation frame
    image(curtainFrames[curtainCurrentFrame], 0, 0);
    curtainCurrentFrame++; // Move to the next frame
    if (curtainCurrentFrame >= curtainFrames.length) {
      // If it reaches the last frame, stop the animation
      curtainCurrentFrame = curtainFrames.length - 1; // Set current frame to the last frame
      curtainAnimationPlaying = false; // Set curtain animation flag to false
      curtainAnimationEnded = true; // Set curtain animation ended flag to true
    }
  }

  // Display other elements if curtain animation has ended
  //if (curtainAnimationEnded) {
    // Display each image at its position
  //  for (int i = 0; i < numImages; i++) {
  //    if (i < 5) {
  //      float newWidth = images[i].width * 0.3;
  //      float newHeight = images[i].height * 0.3;
  //      if (imageX[i] > windowWidth / 2) { // Check if it's a non-floor image on the right side
  //        pushMatrix(); // Save the current transformation matrix
  //        scale(-1, 1); // Flip the image along the x-axis
  //        image(images[i], -imageX[i] - images[i].width * 0.3, imageY[i], newWidth, newHeight); // Draw the flipped image
  //        popMatrix(); // Restore the previous transformation matrix
  //      } else {
  //        image(images[i], imageX[i], imageY[i], newWidth, newHeight); // Draw the image normally
  //      }
  //    } else {
  //      float newWidth = images[i].width * 0.3;
  //      float newHeight = images[i].height * 0.3;
  //      image(images[i], imageX[i], imageY[i], newWidth, newHeight); // Draw floor images scaled down
  //    }
  //  }
    
    // Display other elements if curtain animation has ended
  if (curtainAnimationEnded) {
    // Display each image at its position
    for (int i = 0; i < num_floor_images; i++) {
      //image(floor_images[i], rand_floor_images_x[i], rand_floor_images_y[i]); // Draw floor images scaled down
      if (i == 0){
        image(floor_images[0], rand_floor_left_images_x[0], rand_floor_images_y[0]); // Draw floor images scaled down
      }
      else if (i == 1) {
        image(floor_images[1], rand_floor_right_images_x[1], rand_floor_images_y[1]); // Draw floor images scaled down
      }    
    }
    
    drawButton(); // Draw the button
    
    // Draw the last frame of the curtain animation above all other elements
    image(curtainFrames[curtainFrames.length - 1], 0, 0);
  }
}

void keyPressed() {
  if (key == ESC) {
    exit();  // Close the window when "Escape" key is pressed
  }
}

void mousePressed() {
  // Check if the mouse is clicked within the button area
  if (mouseX > 600 && mouseX < 750 && mouseY > 500 && mouseY < 550) {
    generateRandomPositions(); // Generate new random positions
  }
  
  // Check if the mouse is clicked within the curtain thingy area
  if (mouseX > 0 && mouseX < click_thingy[1].width && mouseY > 0 && mouseY < click_thingy[1].height && click_flag == 0) {
    click_flag = 1;
  }
}

void loadImages() {
  // Load images from the folder
  for (int i = 0; i < numImages; i++) {
    String imageName;
    imageName = "images/image" + (i+1) + ".png"; // Change image names accordingly
    images[i] = loadImage(imageName);
  }
  // Load curtain thingy
  for (int i = 0; i < num_click_thingy; i++) {
    String imageName_2;
    imageName_2 = "click_images/curtain_pull_" + (i+1) + ".png"; // Change image names accordingly
    click_thingy[i] = loadImage(imageName_2);
  }
  // Load floor images
  for (int i = 0; i < num_floor_images; i++) {
    String imageName_3;
    imageName_3 = "floor_images/floor_" + (i+1) + ".png"; // Change image names accordingly
    PImage floor_i = loadImage(imageName_3);
    floor_i.resize(displayWidth, floor_i.height/4);
    floor_images[i] = floor_i;
    //floor_images[i] = loadImage(imageName_3);
  }
}

void loadCurtainFrames() {
  curtainFrames = new PImage[33]; // Assuming you have 33 frames for the curtain animation
  
  // Load curtain animation frames
  for (int i = 0; i < curtainFrames.length; i++) {
    String imageName = "curtain_animation_b_and_w/curtain_animation." + nf(i + 1, 4) + ".png";
    PImage frame = loadImage(imageName);
    frame.resize(displayWidth, displayHeight); // Resize the frame to half of its original size
    curtainFrames[i] = frame;
  }
}


void generateRandomPositions() {
  // Generate random positions for non-floor images on both sides
  for (int i = 0; i < 5; i++) {
    int randomInt = int(random(2)); // Generate a random integer (0 or 1)
    if (randomInt == 0) {
      // For images on the left side
      imageX[i] = random(minXLeft, maxXLeft - images[i].width * 0.3);
    } else {
      // For images on the right side
      imageX[i] = random(minXRight, maxXRight - images[i].width * 0.3);
    }
    // For both sides
    if (i != 2 && i != 1 && i != 0){
      imageY[i] = random(minY, maxY - images[i].height * 0.3);
    } else if (i == 2 || i == 0){
        imageY[i] = random(minY_3, maxY_3 - images[i].height * 0.3);
    } else if (i == 1){
        imageY[i] = random(minY_2, maxY_2 - images[i].height * 0.3);
    }
  }
  
  // Generate random positions for floor images
  for (int i = 5; i < numImages; i++) {
    int randomInt = int(random(2)); // Generate a random integer (0 or 1)
    if (randomInt == 0) {
      imageX[i] = random(floorMinX_left, floorMaxX_left - images[i].width);
    } else {
      imageX[i] = random(floorMinX_right, floorMaxX_right - images[i].width);
    }
    imageY[i] = random(floorMinY, floorMaxY - images[i].height);
  }
  
  // Generate random position for floor images
  rand_floor_left_images_x[0] = random(0, displayWidth - floor_images[0].width);
  rand_floor_right_images_x[1] = random(displayWidth - floor_images[1].width, displayWidth - floor_images[1].width/2);
  for (int i = 0; i < num_floor_images; i++){
    rand_floor_images_y[i] = random(displayHeight - floor_images[i].height, displayHeight - floor_images[i].height/2);
  }
}

void drawButton() {
  // Draw the button
  fill(200);
  rect(600, 500, 150, 50);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Change Position", 675, 525);
}
