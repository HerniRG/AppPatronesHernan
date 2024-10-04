
# Heroes App

## Descripción
Heroes App es una aplicación móvil que muestra una lista de héroes del universo de Dragon Ball, permitiendo al usuario ver información detallada de cada héroe. La aplicación utiliza la API de Dragon Ball desarrollada por KeepCoding para obtener y mostrar los datos de los héroes.

## Funcionalidades
- Visualización de una lista de héroes de Dragon Ball.
- Posibilidad de seleccionar un héroe para ver sus detalles.
- Implementación de un mecanismo de `logout` para cerrar sesión y volver a la pantalla de login.
- Manejo de estados de carga y error con opción de reintentar la carga de datos.

## Arquitectura
La aplicación sigue un patrón de diseño MVVM (Model-View-ViewModel) para asegurar una separación clara de responsabilidades y facilitar el mantenimiento y la escalabilidad.

### Pantallas principales:
1. **Pantalla de Login**: Permite al usuario autenticarse en la aplicación.
2. **Pantalla de Lista de Héroes**: Muestra una lista de héroes obtenida de la API.
3. **Pantalla de Detalles del Héroe**: Muestra detalles específicos de cada héroe seleccionado.

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
4. Puedes cerrar sesión utilizando el botón de "Logout" en la pantalla de lista de héroes.

## API
La aplicación utiliza la **API de Dragon Ball** proporcionada por KeepCoding. Esta API permite obtener la información detallada de los héroes del universo de Dragon Ball, incluyendo su nombre, foto, descripción y transformaciones.

### Endpoints principales:
- `/api/heros/all`: Obtiene la lista completa de héroes.
- `/api/heros/:id`: Obtiene los detalles de un héroe específico.

### Autenticación
La API utiliza autenticación basada en token (JWT). El token debe ser enviado en los encabezados de cada petición:

```http
Authorization: Bearer <token>
```

## Estructura del Proyecto
```
HeroesApp/
├── Models/
│   ├── Hero.swift
│   ├── Transformation.swift
├── Views/
│   ├── HeroesListViewController.swift
│   ├── HeroDetailsViewController.swift
│   ├── HeroTableViewCell.swift
├── ViewModels/
│   ├── HeroesListViewModel.swift
│   ├── HeroDetailsViewModel.swift
├── Network/
│   ├── APIClient.swift
│   ├── NetworkModel.swift
├── Builders/
│   ├── LoginBuilder.swift
│   ├── HeroeDetailsBuilder.swift
│   ├── HeroesListBuilder.swift
└── Resources/
    ├── Assets.xcassets
    ├── LaunchScreen.storyboard
    ├── Main.storyboard
```

## Dependencias
- **URLSession**: Para realizar peticiones de red a la API de Dragon Ball.
- **DispatchWorkItem**: Utilizado para gestionar las tareas asíncronas de descarga de imágenes.

## Contacto
**Autor**: Hernán Rodríguez  
**Correo**: [hernanrg85@gmail.com](mailto:hernanrg85@gmail.com)

