abstract class Button {
  // Created 6/16/2017
  // Snippets taken from :
  // http://processingjs.org/learning/topic/buttons/
  // https://processing.org/examples/button.html
  
  // To Do:
  // ---
  /// Nothing RN
  // ---
 
  // Location :
   // CircleButton = Center coordinates
   // Rectbutton = Top left coordinates
  // Size = Length & width of button
  
  // nColor = Normal color of button in a resting state
  // hColor = Highlighted color of button
  
  // isOver = If the mouse is over
  // isSelected = If the button is selected
  // isSelectable = If the button changes color when moused over
  
  PVector location, size;
  color nColor, hColor; 
  boolean isOver, isSelected, isSelectable;
  
  
  
  Button(float locX_, float locY_, float sizeX_, float sizeY_, color nColor_) {
    location = new PVector(locX_, locY_);
    size     = new PVector(sizeX_, sizeY_);
    nColor   = nColor_; 
    hColor   = nColor + 100;
    isSelectable = true;
  }
  
  Button(float locX_, float locY_, float sizeX_, float sizeY_, color nColor_, boolean isSelectable_) {
    location = new PVector(locX_, locY_);
    size     = new PVector(sizeX_, sizeY_);
    nColor   = nColor_; 
    hColor   = nColor + 100;
    isSelectable = isSelectable_;
  }
}

class CircleButton extends Button {
 
 PFont bFont;
 String bText;
 
 CircleButton(float locX_, float locY_, float diameter_, color nColor_) {
  super(locX_, locY_, diameter_, diameter_, nColor_);
  bFont = createFont("Arial", 24);
 }
 
 CircleButton(float locX_, float locY_, float diameter_, color nColor_, boolean isSelectable_) {
  super(locX_, locY_, diameter_, diameter_, nColor_, isSelectable_); 
  bFont = createFont("Arial", 24);
 }
 
 
 // If the button is selectable (able to be highlighted), see if the mouse is over the button and store it in isOver
 void update() {
  if (isSelectable) { 
  isOver = overButton(); 
  if (clickedButton())
  isSelected = true;
  }
 }
  
 // If the mouse is neither over the button, or if the button isn't selected, fill it as the normal color
 // If either is true fill it with the highlighted color  
 void display() {
  if (!(isOver || isSelected))
   fill(nColor);
  else fill(hColor); 
  ellipse(location.x, location.y, size.x, size.y);
  if (bText != null) {
   textAlign(CENTER);
   textFont(bFont);
   fill(0);
   if (int(bText) < 10)
    text(bText, location.x + 1, location.y + 7);
   else text(bText, location.x, location.y + 7);
  }
 }
 
 boolean overButton() {
   // Checks if the mouse is within the circle
   // If the line from the center of the circle to the mouse is less than the radius of the circle, return true
   float disX = location.x - mouseX; 
   float disY = location.y - mouseY; 
   return (sqrt(sq(disX) + sq(disY))) < size.x/2;
 }
 
   // If the mouse is down while over the circle, return true
 boolean clickedButton() {
   return isOver && mousePressed; 
 }
 
 void setText(String text_) {
  bText = text_; 
 }
}

class RectButton extends Button {
  
 // isHoldable :
  // After being pressed, if it's false will return to the normal color
 boolean isHoldable;
 
 RectButton(float locX_, float locY_, float sizeX, float sizeY, color nColor_) {
  super(locX_, locY_, sizeX, sizeY, nColor_); 
  isHoldable = true;
 }
 
 RectButton(float locX_, float locY_, float sizeX, float sizeY, color nColor_, boolean isSelectable_, boolean isHeld_) {
  super(locX_, locY_, sizeX, sizeY, nColor_, isSelectable_); 
  isHoldable = isHeld_;
 }
 
 
 // If isHoldable is false, make it so the button doesn't stay highlighted after being clicked
 void update() {
  if (!isHoldable)
  isSelected = false;
  if (isSelectable) { 
  isOver = overButton(); 
  if (clickedButton())
  isSelected = true;
  }
 }
  
 void display() {
  if (!(isOver || isSelected))
   fill(nColor);
  else fill(hColor); 
  rect(location.x, location.y, size.x, size.y);
 }
 
 boolean overButton() {
   return (mouseX >= location.x && mouseX <= location.x + size.x &&
           mouseY >= location.y && mouseY <= location.y + size.y);
 }
 
 boolean clickedButton() {
   return isOver && mousePressed; 
 }
}

class ScrollBar extends Button {
  
  boolean isActivated;
  float mouseOffset, initialY, previousY, maxHeight;
  
 ScrollBar(float locX_, float locY_, float sizeX, float sizeY, color nColor_) {
  super(locX_, locY_, sizeX, sizeY, nColor_); 
  initialY = locY_;
  maxHeight = height - (initialY + size.y);
 }
 
 void update() {
  isOver = overButton(); 
  if (clickedButton() && !isActivated) {
   isActivated = true;
   mouseOffset = mouseY - location.y;
  }
  previousY = location.y;
  if (isActivated && mousePressed)
   location.y = lerp(location.y, mouseY - mouseOffset, .5);
  else isActivated = false;
  location.y = constrain(location.y, initialY, maxHeight);
 }
 
 void display() {
  if (!(isOver || isActivated))
   fill(nColor);
  else fill(hColor); 
  rect(location.x, location.y, size.x, size.y);
 }
 
 float getScrollValue() {
  float scrollValue = map(location.y, initialY, maxHeight, 0, 4000); 
  return scrollValue;
 }
 
 void setLocationY(float scrollValue) {
  float locationY = map(-scrollValue, 0, 4000, initialY, maxHeight);
  location = new PVector(location.x, locationY);
 }
 
 boolean overButton() {
   return (mouseX >= location.x && mouseX <= location.x + size.x &&
           mouseY >= location.y && mouseY <= location.y + size.y);
 }
 
 boolean clickedButton() {
   return isOver && mousePressed; 
 }
 
 boolean wasMoved() {
  return location.y != previousY; 
 }
  
}