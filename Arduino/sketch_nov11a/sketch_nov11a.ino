#include <SPI.h>
#include <SD.h>

// Define el pin CS (Chip Select) del shield SD
const int chipSelect = 4; // Puedes cambiar este valor según tu configuración

void setup() {
  // Inicializa la comunicación serial
  Serial.begin(9600);
  Serial.println("Iniciando...");
  if(SD.begin(chipSelect)==1){
    Serial.println("Se inicializó la tarjeta SD correctamente.");
  }else{
    Serial.println("Error al inicializar la tarjeta SD");
  }
  delay(3000);
  // Inicializa la tarjeta SD con el pin CS especificado
}

void loop() {
  // Intenta abrir el archivo "temp.txt" en modo de lectura
  File dataFile = SD.open("temp.txt");
  // Si el archivo se abre correctamente, lee desde él y muestra el contenido en el monitor serial
  if (dataFile) {
    Serial.println("Contenido de data.txt:");

    while (dataFile.available()) {
      Serial.write(dataFile.read());
    }

    // Cierra el archivo
    dataFile.close();
  } else {
    // Si hay un error al abrir el archivo, muestra un mensaje en el monitor serial
    Serial.println("Error al abrir temp.txt");
  }

  // Espera unos segundos antes de volver a leer el archivo
  delay(2000);
}