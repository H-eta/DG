PImage[] images = new PImage[8]; // Array to hold the images
int numImages = 8; // Update the number of images
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
PImage[] curtainFrames = new PImage[20]; // Array to hold the animation frames
int curtainCurrentFrame = 0; // Index of the current frame
boolean curtainAnimationPlaying = false; // Flag to indicate if the curtain animation is playing
boolean curtainAnimationEnded = false; // Flag to indicate if the curtain animation has ended

int curtainClosingCurrentFrame = curtainFrames.length - 1;
boolean curtainClosingAnimationPlaying = false; // Flag to indicate if the curtain animation is playing
boolean curtainClosingAnimationEnded = false; // Flag to indicate if the curtain animation has ended

// Curtain clickable thingy
PImage[] click_thingy = new PImage[2];
int num_click_thingy = 1;
int click_flag = 0;

boolean floor_disappear_flag = false;
boolean curtain_closing_flag = false;

// floor images
PImage[] floor_images = new PImage[2]; // Array to hold the floor images
int num_floor_images = 2; // Update the number of images
float[] rand_floor_left_images_x = new float[num_floor_images];
float[] rand_floor_right_images_x = new float[num_floor_images];
float[] rand_floor_images_y = new float[num_floor_images];


float[] current_floor_left_images_x = new float[num_floor_images];
float[] current_floor_right_images_x = new float[num_floor_images];
float[] current_floor_images_y = new float[num_floor_images];

// Define arrays to store random positions for scenario images
float[] rand_imageX = new float[numImages];
float[] rand_imageY = new float[numImages];

float animationProgress = 0.0; // Tracks the progress of the animation (0.0 to 1.0)
boolean animatingDown = true; // Direction of animation

int startTime = 0; // Store the current time
int curtain_start_time = 0;

void settings() {
  //size(windowWidth, windowHeight); // Set the size of the window
  size(displayWidth, displayHeight);
  fullScreen();
}

void setup() {
  loadImages(); // Load the images from the folder
  loadCurtainFrames(); // Load curtain animation frames
  generateRandomPositions(); // Generate initial random positions
  
  // Initialize current positions off-screen to start the animation
  current_floor_left_images_x[0] = -floor_images[0].width;
  current_floor_right_images_x[1] = displayWidth;
  for (int i = 0; i < num_floor_images; i++) {
    current_floor_images_y[i] = displayHeight + floor_images[i].height;
  }
  
  // Generate random positions for non-floor images on both sides
  for (int i = 0; i < numImages; i++) {
    if (rand_imageX[i] < displayWidth / 2) {
      // For images on the left side
      //imageX[i] = random(minXLeft, maxXLeft - images[i].width * 0.3);
      imageX[i] = -images[i].width*0.8*2;
    } else {
      // For images on the right side
      imageX[i] = displayWidth + images[i].width*0.8*2;
    }
    // For both sides
    imageY[i] = random(rand_floor_images_y[0], rand_floor_images_y[0] + images[i].height/4 * 0.8);
  }
  
  
}

void animateClickThingy() {
  // Adjust animation progress based on direction
  if (animatingDown) {
    animationProgress += 0.04; // Adjust the speed of animation as needed
    if (animationProgress >= 1.0) {
      animationProgress = 1.0;
      animatingDown = false;
    }
  } else {
    animationProgress -= 0.04; // Adjust the speed of animation as needed
    if (animationProgress <= 0.0) {
      animationProgress = 0.0;
      curtainAnimationPlaying = true; // Start the curtain animation
    }
  }

  // Calculate the new height of the click_thingy image based on the animation progress
  float maxHeight = click_thingy[0].height * 1.2; // Max height is 1.2 times the original height
  float newHeight = click_thingy[0].height + (maxHeight - click_thingy[0].height) * animationProgress;

  // Calculate yPosition based on the animation progress
  float originalYPosition = 0 - click_thingy[0].height / 6;
  float yPosition;
  if (animatingDown) {
    yPosition = originalYPosition;
  } else {
    yPosition = originalYPosition - (1.0 - animationProgress) * click_thingy[0].height;
  }

  // Draw the stretched image
  image(click_thingy[0], 0, yPosition, click_thingy[0].width, newHeight);
}

void draw() {
  //print(curtainClosingAnimationPlaying);
  background(4, 12, 23); // background color
  
  if (click_flag == 0){
    image(curtainFrames[0], 0, 0);
    image(click_thingy[0], 0, 0 - click_thingy[0].height / 6);
  }
  else if (click_flag == 1){
    if (!curtainAnimationPlaying && !curtainAnimationEnded) {
      image(curtainFrames[0], 0, 0);
    }
    animateClickThingy();
  }
  
  // Check if the curtain animation is still playing
  if (curtainAnimationPlaying && click_flag == 1) {
    // Display curtain animation frame
    if (!curtain_closing_flag){
      image(curtainFrames[curtainCurrentFrame], 0, 0);
    }
    curtainCurrentFrame++; // Move to the next frame
    if (curtainCurrentFrame >= curtainFrames.length) {
      // If it reaches the last frame, stop the animation
      curtainCurrentFrame = curtainFrames.length - 1; // Set current frame to the last frame
      curtainAnimationPlaying = false; // Set curtain animation flag to false
      curtainAnimationEnded = true; // Set curtain animation ended flag to true
    }
  }
    
  // Display other elements if curtain animation has ended
  if (curtainAnimationEnded) {
    if (!floor_disappear_flag){
      // Update current positions smoothly towards target positions
      current_floor_left_images_x[0] = lerp(current_floor_left_images_x[0], rand_floor_left_images_x[0], 0.05);
      current_floor_right_images_x[1] = lerp(current_floor_right_images_x[1], rand_floor_right_images_x[1], 0.05);
      for (int i = 0; i < num_floor_images; i++) {
        current_floor_images_y[i] = lerp(current_floor_images_y[i], rand_floor_images_y[i], 0.05);
      }
       // Update current positions smoothly towards target positions for non-floor images
      for (int i = 0; i < numImages; i++) {
        if (imageX[i] < displayWidth / 2) { // Check if it's a non-floor image on the left side
          imageX[i] = lerp(imageX[i], rand_imageX[i], 0.05);
        } else {
          imageX[i] = lerp(imageX[i], rand_imageX[i], 0.05);
        }
        imageY[i] = lerp(imageY[i], rand_imageY[i], 0.05); // Smoothly move the image towards its target y position
      }
      // Display each floor image at its interpolated position
      //for (int i = 0; i < num_floor_images; i++) {
      //  if (i == 0) {
          // Flip the first floor image horizontally
      // draw the left floor (the one that stays below)
      pushMatrix();
      translate(current_floor_left_images_x[0] + floor_images[0].width, current_floor_images_y[0]);
      scale(-1, 1);
      image(floor_images[0], 0, 0);
      popMatrix();
      
      // Display each image at its position
      for (int i = 0; i < numImages; i++) {
        float newWidth = images[i].width * 0.8;
        float newHeight = images[i].height * 0.8;
        if (imageX[i] < displayWidth / 2) { // Check if it's a non-floor image on the left side
          pushMatrix(); // Save the current transformation matrix
          scale(-1, 1); // Flip the image along the x-axis
          image(images[i], -imageX[i] - images[i].width * 0.8, imageY[i], newWidth, newHeight); // Draw the flipped image
          popMatrix(); // Restore the previous transformation matrix
        }
      }
      
       // } else if (i == 1) {
      // draw the right floor (the one that stays above)
      image(floor_images[1], current_floor_right_images_x[1], current_floor_images_y[1]);
      
      
      // Display each image at its position
      for (int i = 0; i < numImages; i++) {
        float newWidth = images[i].width * 0.8;
        float newHeight = images[i].height * 0.8;
        if (imageX[i] >= displayWidth / 2) { // Check if it's a non-floor image on the left side
          image(images[i], imageX[i], imageY[i], newWidth, newHeight); // Draw the image normally
        }
      }
        //}    
      //}
    } else if (floor_disappear_flag) {
      // Move floor images off the screen
      current_floor_left_images_x[0] = lerp(current_floor_left_images_x[0], -floor_images[0].width, 0.05);
      current_floor_right_images_x[1] = lerp(current_floor_right_images_x[1], displayWidth, 0.05);
      for (int i = 0; i < num_floor_images; i++) {
        current_floor_images_y[i] = lerp(current_floor_images_y[i], displayHeight + floor_images[i].height, 0.05);
      }
      // Display each floor image at its interpolated position
      //for (int i = 0; i < num_floor_images; i++) {
      //  if (i == 0) {
      pushMatrix();
      translate(current_floor_left_images_x[0] + floor_images[0].width, current_floor_images_y[0]);
      scale(-1, 1);
      image(floor_images[0], 0, 0);
      popMatrix();
       // } else if (i == 1) {
      image(floor_images[1], current_floor_right_images_x[1], current_floor_images_y[1]);
       // }    
       if (millis() - startTime > 500) {  // Check if 0.5 seconds have passed
        curtain_closing_flag = true;
        curtainClosingAnimationPlaying=true;
      }
    }
    
    
    
    if (curtainClosingAnimationPlaying){
      // Display curtain animation frame
      image(curtainFrames[curtainClosingCurrentFrame], 0, 0);
      curtainClosingCurrentFrame--; // Move to the next frame
      if (curtainClosingCurrentFrame <= 0) {
        // If it reaches the last frame, stop the animation
        curtainClosingCurrentFrame = 0; // Set current frame to the last frame
        curtainClosingAnimationPlaying = false; // Set curtain animation flag to false
        curtainClosingAnimationEnded = true; // Set curtain animation ended flag to true
      }
    }
    
    drawButton(); // Draw the button
    
     // Ensure no curtain frame is displayed if the closing animation ended
    if (!curtain_closing_flag) {
      image(curtainFrames[curtainFrames.length - 1], 0, 0);
    }
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
    //startTime = millis();  // Store the current time
    //floor_disappear_flag = true;
  }
  
  // Check if the mouse is clicked within the curtain thingy area
  if (mouseX > 0 && mouseX < click_thingy[0].width && mouseY > 0 && mouseY < click_thingy[0].height && click_flag == 0) {
    click_flag = 1;
  }
}

void loadImages() {
  // Load images from the folder
  for (int i = 0; i < numImages; i++) {
    String imageName;
    imageName = "images/image" + (i) + ".png"; // Change image names accordingly
    images[i] = loadImage(imageName);
  }
  // Load curtain thingy
  for (int i = 0; i < num_click_thingy; i++) {
    String imageName_2;
    imageName_2 = "click_thingy" + ".png"; // Change image names accordingly
    click_thingy[i] = loadImage(imageName_2);
  }
  // Load floor images
  for (int i = 0; i < num_floor_images; i++) {
    String imageName_3;
    imageName_3 = "floor_image/mountain" + ".png"; // Change image names accordingly
    PImage floor_i = loadImage(imageName_3);
    floor_i.resize(displayWidth, floor_i.height/3);
    floor_images[i] = floor_i;
    //floor_images[i] = loadImage(imageName_3);
  }
}

void loadCurtainFrames() {  
  // Load curtain animation frames
  for (int i = 0; i < curtainFrames.length; i++) {
    String imageName = "new_curtain_animation/frame" + nf(i, 4) + ".png";
    PImage frame = loadImage(imageName);
    frame.resize(displayWidth, displayHeight); // Resize the frame to half of its original size
    curtainFrames[i] = frame;
  }
}

// Function to check if two images overlap
boolean checkOverlap(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  return (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2);
}

// Function to adjust positions to avoid overlap
//void adjustPositions() {
  // Flag to indicate if any adjustment is made
//  for (int i = 0; i < numImages - 1; i++) {
//    for (int j = i + 1; j < numImages; j++) {
//      if (checkOverlap(rand_imageX[i], rand_imageY[i], images[i].width * 0.8, images[i].height * 0.8, 
//                       rand_imageX[j], rand_imageY[j], images[j].width * 0.8, images[j].height * 0.8)) {
        // Adjust positions to avoid overlap
        // Example: Move one of the images along the x-axis
//        if (rand_imageX[i] + images[i].width*0.8 < displayWidth - curtainFrames[curtainFrames.length - 1].width/8 - images[i].width * 0.8){
//          rand_imageX[i] += images[i].width*0.8; // Move image i to the right
//        } else {
//          rand_imageX[i] -= images[i].width*0.8; // Move image i to the left
//        }
        // You can implement more sophisticated logic here to adjust positions
//      }
//    }
//  }
//}

void adjustPositions() {
  // Flag to indicate if any adjustment is made
  boolean adjusted = true;
  
  // Loop until no more adjustments are needed
  while (adjusted) {
    // Assume no adjustments are needed initially
    adjusted = false;
    
    // Loop through all pairs of images
    for (int i = 0; i < numImages - 1; i++) {
      for (int j = i + 1; j < numImages; j++) {
        // Check overlap between image i and image j
        if (checkOverlap(rand_imageX[i], rand_imageY[i], images[i].width * 0.8, images[i].height * 0.8, 
                         rand_imageX[j], rand_imageY[j], images[j].width * 0.8, images[j].height * 0.8)) {
          // Adjust positions to avoid overlap
          float offsetX = images[i].width * 0.8; // Move image i by its width to the right
          //float offsetY = images[i].height * 0.8; // Move image i by its height down
          
          // Check if image i is on the left side, if not, adjust offset to the left
          if (rand_imageX[i] >= displayWidth / 2) {
            offsetX = -offsetX; // Move image i to the left
          }
          
          // Move image i by the calculated offset
          rand_imageX[i] += offsetX;
          //rand_imageY[i] += offsetY;
          
          // Set adjusted flag to true
          adjusted = true;
        }
      }
    }
  }
}

void generateRandomPositions() {   
  // Generate random position for floor images
  rand_floor_left_images_x[0] = random(- floor_images[0].width/6, - floor_images[0].width/20);
  rand_floor_right_images_x[1] = random(displayWidth - floor_images[1].width, displayWidth - floor_images[1].width + floor_images[1].width/6);
  for (int i = 0; i < num_floor_images; i++){
    rand_floor_images_y[i] = random(displayHeight + floor_images[i].height/4 - floor_images[i].height, displayHeight + floor_images[i].height/6 - floor_images[i].height);
  }
  
  // Generate random positions for non-floor images on both sides
  for (int i = 0; i < numImages; i++) {
    int randomInt = int(random(2)); // Generate a random integer (0 or 1)
    if (randomInt == 0) {
      // For images on the left side
      //imageX[i] = random(minXLeft, maxXLeft - images[i].width * 0.3);
      rand_imageX[i] = random(curtainFrames[curtainFrames.length - 1].width/8, displayWidth/2 - images[i].width * 0.8);
    } else {
      // For images on the right side
      rand_imageX[i] = random(displayWidth/2, displayWidth - curtainFrames[curtainFrames.length - 1].width/8 - images[i].width * 0.8);
    }
    // For both sides
    rand_imageY[i] = random(rand_floor_images_y[0], rand_floor_images_y[0] + images[i].height/4 * 0.8);
  }
  
  // After generating positions, adjust positions to avoid overlap
  adjustPositions();
  
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
