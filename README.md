# 🎟️ BOOKIT — Aplicación de Reserva de Entradas de Cine

<p align="center">
  <img src="assets/icons/logo.png" alt="Logo de BOOKIT" width="120"/>
</p>

Aplicación multiplataforma desarrollada en **Flutter** como proyecto final para la asignatura de **Interfaces Persona-Computador (IPC)** en el Grado en Ingeniería Informática (EPSA - UPV).

**BOOKIT** ofrece una experiencia completa e intuitiva de taquilla digital: desde la autenticación de usuarios y la exploración de la cartelera con transiciones animadas hasta el cálculo dinámico de sesiones según el metraje de cada película y la selección interactiva de butacas en sala.

**Autor:** Andrés Alcaraz Verdú

---

## 📱 Funcionalidades Principales

* **Autenticación y Gestión de Cuentas (`login_screen.dart`):**
  * Inicio de sesión y modal desplegable (`DraggableScrollableSheet`) para el registro de nuevos usuarios con validación de campos vacíos y comprobación de correos duplicados.
  * Utilidades de desarrollo integradas en la cabecera para acceso rápido con usuario de prueba y reseteo con confirmación de la base de datos local.
* **Cartelera Dinámica (`main_screen.dart`):**
  * Catálogo de películas cargado asíncronamente desde `lib/data/peliculas.json` mostrando póster, título, estudio, duración y sinopsis.
  * Transiciones visuales fluidas hacia la ficha de reserva mediante animaciones **`Hero`**.
* **Generación Algorítmica de Sesiones (`reserva_screen.dart`):**
  * Selector interactivo de fecha y hora con validación de estado (habilitación reactiva del paso a butacas).
  * Cálculo automático de pases disponibles entre las 15:00 y las 23:00 en función de la duración en minutos de cada película.
* **Mapa Interactivo de Butacas (`asiento_screen.dart`):**
  * Matriz bidimensional de sala de cine con código de colores en tiempo real: asientos disponibles (gris), ocupados/bloqueados (rosa) y selección activa del usuario (cian).
* **Gestión de Reservas (`mis_reservas_screen.dart`):**
  * Listado de entradas adquiridas por el usuario activo con detalles de película, día, sesión, fila y asiento.
  * Flujo de **modificación de reserva** (reemplazo directo redirigiendo a la película seleccionada) y **cancelación** con diálogo de confirmación.
* **Perfil de Usuario y Persistencia (`perfil_screen.dart`, `usuarios_data.dart`):**
  * Edición en vivo de nombre, correo electrónico y contraseña mediante cuadros de diálogo modales.
  * Persistencia local estructurada en JSON dentro del directorio `AppData` del dispositivo, manteniendo las sesiones y listas de reservas por usuario entre reinicios de la aplicación.
  * Opciones de cierre de sesión y eliminación definitiva de cuenta con borrado en cascada de sus reservas asociadas.

---

## 🛠️ Arquitectura y Estructura del Proyecto

El código fuente sigue una separación clara entre capa de datos, modelos de dominio y vistas de interfaz (`lib/`):

```text
bookit-cinema-app/
├── assets/
│   └── icons/
│       └── logo.png                 # Logotipo oficial de la aplicación
├── lib/
│   ├── data/
│   │   ├── peliculas.json           # Catálogo estático de películas en cartelera
│   │   ├── peliculas_data.dart      # Servicio de lectura y deserialización de cartelera
│   │   └── usuarios_data.dart       # Persistencia local JSON de usuarios y reservas en AppData
│   ├── models/
│   │   ├── pelicula.dart            # Modelo de datos de Película (fromJson / toJson)
│   │   ├── pelicula_reservada.dart  # Modelo de datos de Reserva (película, fecha, hora, fila, asiento)
│   │   └── usuario.dart             # Modelo de Usuario y lista de reservas asociadas
│   ├── views/
│   │   ├── login_screen.dart        # Pantalla de acceso, registro y herramientas de depuración
│   │   ├── main_screen.dart         # Contenedor principal con barra de navegación inferior y cartelera
│   │   ├── reserva_screen.dart      # Ficha de película, animación Hero y cálculo de sesiones
│   │   ├── asiento_screen.dart      # Selector matricial de butacas de la sala
│   │   ├── mis_reservas_screen.dart # Gestión, modificación y borrado de entradas reservadas
│   │   └── perfil_screen.dart       # Edición de credenciales, cierre de sesión y baja de usuario
│   └── main.dart                    # Punto de entrada y configuración de tema/fuentes (Google Fonts)
└── pubspec.yaml                     # Dependencias (google_fonts, path_provider, etc.) y assets
