#include <Servo.h> // Incluye la librería Servo para controlar el servomotor.

const int trigPin = 10;    // Define el pin para el trigger del sensor de ultrasonido.
const int echoPin = 11;    // Define el pin para el echo del sensor de ultrasonido.
long duration;             // Variable para almacenar la duración del pulso.
int distance;              // Variable para almacenar la distancia calculada.
Servo myServo;             // Crea un objeto Servo para controlar el servomotor.

void setup() {
  pinMode(trigPin, OUTPUT);      // Configura el trigPin como salida.
  pinMode(echoPin, INPUT);       // Configura el echoPin como entrada.
  Serial.begin(9600);            // Inicia la comunicación serial a 9600 baudios.
  myServo.attach(12);            // Adjunta el servomotor al pin 12.
}

void loop() {
  // Bucle para mover el servomotor de 15 a 165 grados (derecha a izquierda).
  for (int i = 15; i <= 165; i++) {
    myServo.write(i);            // Mueve el servomotor al ángulo actual.
    delay(30);                   // Pausa para que el servomotor se mueva.
    distance = calculateDistance(); // Calcula la distancia.
    
    Serial.print(i);             // Ángulo actual.
    Serial.print(",");           // Separador.
    Serial.print(distance);      // Distancia medida.
    Serial.print(".");           // Fin de la lectura.
  }

  // Bucle para mover el servomotor de 165 a 15 grados (izquierda a derecha).
  for (int i = 165; i >= 15; i--) {
    myServo.write(i);
    delay(30);
    distance = calculateDistance();

    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}

int calculateDistance() {
  // Activa la medición del sensor de ultrasonido.
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Mide la duración del pulso de eco.
  duration = pulseIn(echoPin, HIGH);

  // Calcula la distancia en centímetros.
  distance = duration * 0.034 / 2;
  return distance;
}
