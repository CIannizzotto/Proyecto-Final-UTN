import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

String currentPath;
String returnPath;
String fileContent = "";
String aux="";
File[] filesInCurrentFolder;
File previousPath;
float backButtonX = 950;
float backButtonY = 20;
float backButtonDiameter = 35;
PImage carpeta;
PImage txt;
PImage backButton;
PImage newTxt;
PImage newFolder;
boolean showingTextContent = false;

void setup() {
  size(1000, 800);
  carpeta = loadImage("Carpeta.png");
  txt = loadImage("Texto.png");
  backButton = loadImage("VolverAtras.png");
  newTxt = loadImage("NewTxt.png");
  newFolder = loadImage("NewFolder.png");
  carpeta.resize(20, 20);
  txt.resize(20, 20);
  backButton.resize(20,20);
  newTxt.resize(20,20);
  newFolder.resize(20,20);
  currentPath = sketchPath("data"); // Inicialmente muestra el contenido de la carpeta "data"
  filesInCurrentFolder = listFiles(currentPath);
}

void draw() {
    background(255);
    if(showingTextContent){
    fill(0);
    text(fileContent, 20, 20, width - 40, height - 60);
    fill(50, 100, 200);
    }
    else{
    displayFolderContents(currentPath);
}   
    noStroke();
    fill(34,177,76);
    ellipse(backButtonX -100, backButtonY, backButtonDiameter,backButtonDiameter);
    image(newTxt, backButtonX-109, backButtonY-10);
    fill(34,177,76);
    ellipse(backButtonX -50, backButtonY, backButtonDiameter,backButtonDiameter);
    image(newFolder, backButtonX-59, backButtonY-10);
    fill(50, 100, 200);
    ellipse(backButtonX, backButtonY, backButtonDiameter,backButtonDiameter);
    image(backButton, backButtonX-9, backButtonY-10);
}

void displayFolderContents(String path) {
  File folder = new File(path);
  File[] files = folder.listFiles();
  
  float y = 45;

  if (files != null) {
    for (File file : files) {
      if (file.isDirectory()) {
        image(carpeta, 5, y);
        fill(50, 100, 200);
      } else {
        image(txt, 5, y);
        fill(0);
      }

      rect(30, y, width - 45, 20);
      fill(255);
      text(file.getName(), 40, y + 15);

      y += 25;
    }
}
}

void mousePressed() {
  int selectedItem = -1;
  if(mouseY>=45){
  selectedItem = int((mouseY - 45) / 25);
  }
    if(!showingTextContent){
    if (filesInCurrentFolder != null && selectedItem >= 0 && selectedItem < filesInCurrentFolder.length) {
      if (filesInCurrentFolder[selectedItem].isDirectory()) {
        // Si es una carpeta, abrir la carpeta seleccionada
        previousPath = new File(currentPath);
        currentPath = filesInCurrentFolder[selectedItem].getPath();
        filesInCurrentFolder = listFiles(currentPath);
      } else {
        // Si es un archivo, mostrar el contenido de texto
        previousPath = new File(currentPath);
        fileContent = readFile(filesInCurrentFolder[selectedItem]);
        showingTextContent = true;
        if (fileContent.isEmpty()) {
        // Si no hay contenido de archivo, manejar la selección de elementos de la carpeta
        print("Archivo Vacio.\n");
        showingTextContent = false;
        }
      }
      redraw();
    }
}
    float distancia = dist(backButtonX, backButtonY,mouseX, mouseY);
    if (distancia < backButtonDiameter/2) {
        // Acción de volver atrás
        volverAtras();
    }
}
void volverAtras() {
   String[] partes;
  
  showingTextContent = false;
  // Obtén el directorio padre de la ruta actual
  previousPath = new File(currentPath);
  returnPath = previousPath.getPath();
  partes = split(returnPath, "\\");
  
  int indiceData = -1;
  for (int i = 0; i < partes.length; i++) {
    if ("data".equals(partes[i])) {
    indiceData = i;
    break;
    }
  }
  StringBuilder resultado = new StringBuilder();
  if (indiceData != -1) {
    for (int i = indiceData; i < partes.length-1; i++) {
    resultado.append(partes[i]).append("\\");
    }
  }
  aux=resultado.toString();
  if(aux==""){
  aux="data";
  }
  currentPath=sketchPath(aux);
  filesInCurrentFolder = listFiles(currentPath);
}

File[] listFiles(String path) {
  File folder = new File(path);
  return folder.listFiles();
}

String readFile(File file) {
  StringBuilder content = new StringBuilder();

  try {
    BufferedReader reader = new BufferedReader(new FileReader(file));
    String line;

    while ((line = reader.readLine()) != null) {
      content.append(line).append('\n');
    }

    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }

  return content.toString();
}
