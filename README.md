
# Heroes App

## Video Demo
[![Video Demo](https://img.youtube.com/vi/68fkHUG-jVY/0.jpg)](https://youtu.be/68fkHUG-jVY)

## Pantallazos
<div style="display: flex; flex-wrap: wrap; gap: 10px;">
    <a href="https://live.staticflickr.com/65535/54044731669_2718bd0c7a_o.png" target="_blank">
        <img src="https://live.staticflickr.com/65535/54044731669_2718bd0c7a_o.png" width="200px">
    </a>
    <a href="https://live.staticflickr.com/65535/54044858920_37b883f6a1_o.png" target="_blank">
        <img src="https://live.staticflickr.com/65535/54044858920_37b883f6a1_o.png" width="200px">
    </a>
    <a href="https://live.staticflickr.com/65535/54044663983_e2a8b064c7_o.png" target="_blank">
        <img src="https://live.staticflickr.com/65535/54044663983_e2a8b064c7_o.png" width="200px">
    </a>
    <a href="https://live.staticflickr.com/65535/54043546422_4e1f86a4fa_o.png" target="_blank">
        <img src="https://live.staticflickr.com/65535/54043546422_4e1f86a4fa_o.png" width="200px">
    </a>
    <a href="https://live.staticflickr.com/65535/54044859660_17434930b8_o.png" target="_blank">
        <img src="https://live.staticflickr.com/65535/54044859660_17434930b8_o.png" width="200px">
    </a>
</div>

## Descripción
Heroes App es una aplicación móvil que muestra una lista de héroes del universo de Dragon Ball, permitiendo al usuario ver información detallada de cada héroe. La aplicación utiliza la API de Dragon Ball desarrollada por KeepCoding para obtener y mostrar los datos de los héroes.

## Funcionalidades
- Pantalla de login con autenticación JWT hacia la API.
- Visualización de una lista de héroes de Dragon Ball.
- Posibilidad de seleccionar un héroe para ver sus detalles.
- En la pantalla de detalles, se muestra un botón solo si el héroe tiene transformaciones disponibles.

## Arquitectura
La aplicación sigue un patrón de diseño MVVM (Model-View-ViewModel) para asegurar una separación clara de responsabilidades y facilitar el mantenimiento y la escalabilidad.

### Pantallas principales:
1. **Pantalla de Login**: Permite al usuario autenticarse en la aplicación mediante JWT.
2. **Pantalla de Lista de Héroes**: Muestra una lista de héroes obtenida de la API.
3. **Pantalla de Detalles del Héroe**: Muestra detalles específicos de cada héroe seleccionado, con un botón que aparece solo si el héroe tiene transformaciones disponibles.

## Requisitos del Proyecto
- **Xcode**: 12.0 o superior.
- **iOS**: 13.0 o superior.
- **Swift**: 5.0 o superior.

## Instalación
1. Clona el repositorio en tu máquina local.
   ```bash
   git clone https://github.com/hernirg85/HeroesApp.git
   ```
2. Abre el archivo `.xcodeproj` en Xcode.
3. Ejecuta la aplicación en un simulador o dispositivo físico.

## Uso
1. Al abrir la aplicación, serás llevado a la pantalla de login.
2. Inicia sesión utilizando las credenciales proporcionadas por la API de Dragon Ball.
3. Después de iniciar sesión, verás una lista de héroes. Puedes hacer clic en cualquiera de ellos para ver sus detalles.
4. Si el héroe tiene transformaciones, verás un botón adicional en la pantalla de detalles.

## Contacto
**Autor**: Hernán Rodríguez  
**Correo**: [hernanrg85@gmail.com](mailto:hernanrg85@gmail.com)

