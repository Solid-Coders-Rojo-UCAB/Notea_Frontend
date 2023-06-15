# notea_frontend

Frontend for an AI integrated Notes App, developed in TypeScript (NestJs).

## Comando para correr la aplicación Flutter

### `flutter run -d chrome --web-port=9999`

Por ahora tenemos conflicto con el backend, ya que nest nos bloquea las peticiones que vienen de [http://localhost:$$$$]
por lo que se hizo una configuración para que las peticiones que entran por el [http://localhost:9999] siempre serán
permitidas.
