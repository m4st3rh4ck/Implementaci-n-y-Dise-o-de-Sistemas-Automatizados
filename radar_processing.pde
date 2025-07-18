import processing.serial.*; // Importa la librería para la comunicación serial.
import java.awt.event.KeyEvent; // Importa la librería para manejar eventos de teclado (aunque no se usa directamente en este código, es común en Processing).
import java.io.IOException; // Importa la librería para manejar excepciones de entrada/salida.

Serial myPort; // Declara un objeto Serial para la comunicación con el puerto.
// Declara variables.
String angle = ""; // Almacenará el valor del ángulo como String.
String distance = ""; // Almacenará el valor de la distancia como String.
String data = ""; // Almacenará los datos crudos leídos del puerto serial.
String noObject; // Mensaje para indicar si el objeto está dentro o fuera de rango.
float pixsDistance; // Distancia convertida de centímetros a píxeles.
int iAngle, iDistance; // Versiones enteras del ángulo y la distancia.
int index1 = 0; // Índice de la primera coma en la cadena de datos.
int index2 = 0; // Variable no utilizada en este código.
PFont orcFont; // Variable para una fuente personalizada (no utilizada en este código).

void setup() {
  size(1200, 700); // Define el tamaño de la ventana de visualización. **CAMBIAR ESTO A LA RESOLUCIÓN DE TU PANTALLA**
  smooth(); // Suaviza los bordes de las formas gráficas.
  myPort = new Serial(this, "COM7", 9600); // Inicializa la comunicación serial en el puerto "COM7" a 9600 baudios.
  myPort.bufferUntil('.'); // Lee los datos del puerto serial hasta que encuentra el carácter '.'. Es decir, lee algo como: ángulo,distancia.
}

void draw() {
  fill(98, 245, 31); // Establece el color de relleno a verde (verde brillante).

  // Simula el desenfoque de movimiento y el desvanecimiento lento de la línea en movimiento.
  noStroke(); // Desactiva el contorno para las siguientes formas.
  fill(0, 4); // Establece el color de relleno a negro con muy poca opacidad (crea un efecto de rastro).
  rect(0, 0, width, height - height * 0.065); // Dibuja un rectángulo para el efecto de rastro, cubriendo la mayor parte de la pantalla.

  fill(98, 245, 31); // Establece el color de relleno a verde de nuevo.
  // Llama a las funciones para dibujar el radar.
  drawRadar(); // Dibuja los arcos y líneas estáticas del radar.
  drawLine(); // Dibuja la línea de barrido del radar.
  drawObject(); // Dibuja el objeto detectado.
  drawText(); // Dibuja los textos informativos en la pantalla.
}

void serialEvent(Serial myPort) { // Se activa automáticamente cuando hay nuevos datos en el puerto serial.
  // Lee los datos del puerto serial hasta el carácter '.' y los guarda en la variable String "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0, data.length() - 1); // Elimina el último carácter (el punto) de la cadena.

  index1 = data.indexOf(","); // Encuentra la posición del carácter ',' y la guarda en la variable "index1".
  angle = data.substring(0, index1); // Extrae la subcadena desde la posición "0" hasta "index1" (el valor del ángulo).
  distance = data.substring(index1 + 1, data.length()); // Extrae la subcadena desde "index1 + 1" hasta el final (el valor de la distancia).

  // Convierte las variables String (texto) a Integer (números enteros).
  iAngle = int(angle); // Convierte el ángulo a entero.
  iDistance = int(distance); // Convierte la distancia a entero.
}

void drawRadar() {
  pushMatrix(); // Guarda el estado de transformación actual (posición, rotación, escala).
  translate(width / 2, height - height * 0.074); // Mueve el origen de las coordenadas al centro inferior de la pantalla, ajustado.
  noFill(); // Las siguientes formas no tendrán relleno.
  strokeWeight(2); // Establece el grosor del contorno en 2 píxeles.
  stroke(98, 245, 31); // Establece el color del contorno a verde.

  // Dibuja los arcos que representan las líneas de distancia del radar.
  arc(0, 0, (width - width * 0.0625), (width - width * 0.0625), PI, TWO_PI); // Arco exterior.
  arc(0, 0, (width - width * 0.27), (width - width * 0.27), PI, TWO_PI);
  arc(0, 0, (width - width * 0.479), (width - width * 0.479), PI, TWO_PI);
  arc(0, 0, (width - width * 0.687), (width - width * 0.687), PI, TWO_PI);

  // Dibuja las líneas que representan los ángulos del radar.
  line(-width / 2, 0, width / 2, 0); // Línea horizontal (0 y 180 grados).
  line(0, 0, (-width / 2) * cos(radians(30)), (-width / 2) * sin(radians(30))); // Línea a 30 grados.
  line(0, 0, (-width / 2) * cos(radians(60)), (-width / 2) * sin(radians(60))); // Línea a 60 grados.
  line(0, 0, (-width / 2) * cos(radians(90)), (-width / 2) * sin(radians(90))); // Línea a 90 grados.
  line(0, 0, (-width / 2) * cos(radians(120)), (-width / 2) * sin(radians(120))); // Línea a 120 grados.
  line(0, 0, (-width / 2) * cos(radians(150)), (-width / 2) * sin(radians(150))); // Línea a 150 grados.
  line((-width / 2) * cos(radians(30)), 0, width / 2, 0); // Esta línea parece un duplicado o error en el original, apunta a una línea horizontal.
  popMatrix(); // Restaura el estado de transformación guardado anteriormente.
}

void drawObject() {
  pushMatrix(); // Guarda el estado de transformación actual.
  translate(width / 2, height - height * 0.074); // Mueve el origen al centro inferior ajustado.
  strokeWeight(9); // Establece el grosor del punto del objeto en 9 píxeles.
  stroke(255, 10, 10); // Establece el color del contorno a rojo.

  pixsDistance = iDistance * ((height - height * 0.1666) * 0.025); // Convierte la distancia del sensor de cm a píxeles.
  // Limita el rango a 40 cm.
  if (iDistance < 40) {
    // Dibuja el objeto según el ángulo y la distancia. Dibuja una pequeña línea para representar el objeto.
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)), (width - width * 0.505) * cos(radians(iAngle)), -(width - width * 0.505) * sin(radians(iAngle)));
  }
  popMatrix(); // Restaura el estado de transformación.
}

void drawLine() {
  pushMatrix(); // Guarda el estado de transformación actual.
  strokeWeight(9); // Establece el grosor de la línea de barrido en 9 píxeles.
  stroke(30, 250, 60); // Establece el color del contorno a un verde brillante.
  translate(width / 2, height - height * 0.074); // Mueve el origen al centro inferior ajustado.
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), -(height - height * 0.12) * sin(radians(iAngle))); // Dibuja la línea de barrido del radar según el ángulo actual.
  popMatrix(); // Restaura el estado de transformación.
}

void drawText() { // Dibuja los textos en la pantalla.
  pushMatrix(); // Guarda el estado de transformación actual.

  if (iDistance > 40) {
    noObject = "Out of Range"; // Si la distancia es mayor a 40cm, el objeto está fuera de rango.
  } else {
    noObject = "In Range"; // Si la distancia es menor o igual a 40cm, el objeto está en rango.
  }

  fill(0, 0, 0); // Establece el color de relleno a negro.
  noStroke(); // Desactiva el contorno.
  rect(0, height - height * 0.0648, width, height); // Dibuja un rectángulo en la parte inferior para el fondo del texto.
  fill(98, 245, 31); // Establece el color de relleno a verde.
  textSize(25); // Establece el tamaño de la fuente a 25.

  text("10cm", width - width * 0.3854, height - height * 0.0833); // Dibuja el texto "10cm".
  text("20cm", width - width * 0.281, height - height * 0.0833); // Dibuja el texto "20cm".
  text("30cm", width - width * 0.177, height - height * 0.0833); // Dibuja el texto "30cm".
  text("40cm", width - width * 0.0729, height - height * 0.0833); // Dibuja el texto "40cm".

  textSize(40); // Establece el tamaño de la fuente a 40.
  text("FABRI creator", width - width * 0.875, height - height * 0.0277); // Dibuja el nombre del creador.
  text("Ángulo: " + iAngle + " °", width - width * 0.48, height - height * 0.0277); // Muestra el ángulo actual.
  text("Dist:", width - width * 0.26, height - height * 0.0277); // Dibuja el texto "Dist:".
  if (iDistance < 40) {
    text("        " + iDistance + " cm", width - width * 0.225, height - height * 0.0277); // Muestra la distancia si está en rango.
  }

  textSize(25); // Establece el tamaño de la fuente a 25.
  fill(98, 245, 60); // Establece el color de relleno a verde (ligeramente diferente).

  // Dibuja los marcadores de ángulo con rotación para alinearlos con las líneas radiales.
  translate((width - width * 0.4994) + width / 2 * cos(radians(30)), (height - height * 0.0907) - width / 2 * sin(radians(30)));
  rotate(-radians(-60)); // Rota el texto para que esté alineado.
  text("30°", 0, 0); // Dibuja el texto "30°".
  resetMatrix(); // Restablece todas las transformaciones.

  translate((width - width * 0.503) + width / 2 * cos(radians(60)), (height - height * 0.0888) - width / 2 * sin(radians(60)));
  rotate(-radians(-30));
  text("60°", 0, 0); // Dibuja el texto "60°".
  resetMatrix();

  translate((width - width * 0.507) + width / 2 * cos(radians(90)), (height - height * 0.0833) - width / 2 * sin(radians(90)));
  rotate(radians(0));
  text("90°", 0, 0); // Dibuja el texto "90°".
  resetMatrix();

  translate(width - width * 0.513 + width / 2 * cos(radians(120)), (height - height * 0.07129) - width / 2 * sin(radians(120)));
  rotate(radians(-30));
  text("120°", 0, 0); // Dibuja el texto "120°".
  resetMatrix();

  translate((width - width * 0.5104) + width / 2 * cos(radians(150)), (height - height * 0.0574) - width / 2 * sin(radians(150)));
  rotate(radians(-60));
  text("150°", 0, 0); // Dibuja el texto "150°".
  popMatrix(); // Restaura el estado de transformación final.
}
