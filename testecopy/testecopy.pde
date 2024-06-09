PImage[] headImages = new PImage[9];
PImage[] bodyImages = new PImage[5];
PImage selectedHeadImage;
PImage selectedBodyImage;

float maxImageWidth = 120; // largura max p img
float headY, bodyY;
boolean animationComplete = false; //  verificar se a animação foi concluída
float headTargetY, bodyTargetY; // posições final das img
float linhaY;

void setup() {
  size(1280, 720);
  frameRate(7);
  loadHeadImages();
  loadBodyImages();
  selectRandomHeadImage(); // Escolher uma cabeça aleatória
  selectRandomBodyImage(); // Escolher um corpo aleatório
  initializeAnimation();
}

void draw() {
  background(4, 12, 23);

  if (!animationComplete) {
    animateImages();
  }

  displayImages();
}

//void mousePressed() {
//  selectRandomHeadImage(); // Seleciona uma nova cabeça aleatória
//  selectRandomBodyImage(); // Seleciona um novo corpo aleatório
//  initializeAnimation(); // Recomeçar a animação
//}

void mouseMoved() {

  if (mouseX >= width / 3 && mouseX <= width * 2 / 3 && mouseY >= 0 && mouseY <= height / 3 && animationComplete ) {
    if (bodyY < height) {
      bodyY += 20;
    }
    if (headY < height) {
      headY += 20;
    }
    if (linhaY < height) {
      linhaY += 20;
    }
  }
}

void initializeAnimation() {

  headY = -maxImageWidth-270;
  bodyY = -maxImageWidth-200;

  // Calcular proporções e tamanhos
  float headAspectRatio = selectedHeadImage.height / (float) selectedHeadImage.width;
  float headWidth = maxImageWidth * 0.8; // Diminuir o tamanho das cabeças
  float headHeight = headWidth * headAspectRatio;

  float bodyAspectRatio = selectedBodyImage.height / (float) selectedBodyImage.width;
  float bodyWidth = maxImageWidth;
  float bodyHeight = bodyWidth * bodyAspectRatio;

  // Posições alvo para centralizar as imagens
  headTargetY = (height - headHeight - bodyHeight) / 2; // Posição final da cabeça
  bodyTargetY = headTargetY + headHeight;

  // Ajuste especial para head1
  if (selectedHeadImage == headImages[0]) { // Se a imagem selecionada for a head1
    headTargetY += maxImageWidth * 0.5; // Deslocar a cabeça um pouco mais para baixo
  }

  if (selectedHeadImage == headImages[8]) { // Se a imagem selecionada for a head1
    headTargetY += maxImageWidth * 0.1; // Deslocar a cabeça um pouco mais para baixo
  }

  animationComplete = false; // Reiniciar a animação
}

void animateImages() {
  //vel animação
  float speed = 30;

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

  // Verificar se a animação está completa
  if (headY == headTargetY && bodyY == bodyTargetY) {
    animationComplete = true;
  }
}

void displayImages() {
  float headAspectRatio = selectedHeadImage.height / (float) selectedHeadImage.width; // Proporção altura-largura
  float headWidth = maxImageWidth * 0.8; // Diminuir o tamanho das cabeças
  float headHeight = headWidth * headAspectRatio;

  float bodyAspectRatio = selectedBodyImage.height / (float) selectedBodyImage.width; // Proporção do corpo
  float bodyWidth = maxImageWidth; // Largura máxima para o corpo
  float bodyHeight = bodyWidth * bodyAspectRatio; // Altura para manter a proporção

  float headCenterX = (width - headWidth) / 2; // Centralizar horizontalmente
  float bodyCenterX = (width - bodyWidth) / 2; // Centralizar horizontalmente

  // linha
  stroke(250);
  strokeWeight(2);
  float headMiddleX = headCenterX + headWidth / 2;
  //line(headMiddleX, headY-width, headMiddleX, headY+40);
  line(headMiddleX, linhaY, headMiddleX, headY+20);

  // corpo
  image(selectedBodyImage, bodyCenterX, bodyY, bodyWidth, bodyHeight);

  //  cabeça
  image(selectedHeadImage, headCenterX, headY, headWidth, headHeight);
}

void loadHeadImages() {
  String[] headImageNames = { "head/head1.png", "head/head2.png", "head/head3.png", "head/head4.png", "head/head5.png", "head/head6.png", "head/head7.png", "head/head8.png", "head/head9.png" }; // Caminho para as imagens das cabeças
  for (int i = 0; i < headImages.length; i++) {
    headImages[i] = loadImage(headImageNames[i]);
  }
}

void loadBodyImages() {
  String[] bodyImageNames = { "body/body1.png", "body/body2.png", "body/body3.png", "body/body4.png", "body/body5.png"   }; // Caminho para as imagens do corpo
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
