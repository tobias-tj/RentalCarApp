# 🚗 Aplicación de Alquiler de Vehículos

¡Bienvenido a mi aplicación de alquiler de vehículos! Este prototipo funcional está diseñado para facilitar a los usuarios la búsqueda y reserva de automóviles de manera rápida y sencilla.

## **Índice**
- [Características](#características)
- [Conceptos](#conceptos)
- [Instalación](#instalación)
- [Configuración](#configuración)

## **Características**
- **Inicio de Sesión y Registro**: Acceso rápido y seguro a la aplicación.
- **Exploración de Vehículos Favoritos**: Navega y guarda tus autos preferidos para reservas futuras.
- **Calendario de Reservas**: Visualiza tus próximas reservas y detalles de pago en un solo lugar.
- **Gestión Eficiente para Administradores**: Visualiza ventas, tendencias y genera reportes en PDF para una mejor toma de decisiones.

## **Conceptos**
Esta aplicación está diseñada para ofrecer una experiencia fluida tanto a usuarios como a administradores, permitiendo gestionar reservas, visualizar vehículos y acceder a reportes de ventas.

### **Pantalla de Inicio de Sesión (SignIn)**
"Accede a tu cuenta de forma rápida y segura. Con un diseño intuitivo, iniciar sesión es tan sencillo como ingresar tu correo electrónico y contraseña. ¡Vuelve a conectar con tus actividades y aprovecha al máximo tu experiencia en nuestra aplicación!"

### **Pantalla de Registro (SignUp)**
"Únete a nuestra comunidad en pocos pasos. Regístrate fácilmente proporcionando tu correo y creando una contraseña segura. Al registrarte, desbloqueas un mundo de funcionalidades y beneficios. ¡No esperes más y comienza tu viaje con nosotros hoy mismo!"

### **Pantalla Home para Usuarios**
"Descubre Tu Vehículo Perfecto. Navega por nuestra selección de automóviles de alquiler con un diseño intuitivo y atractivo. Cada vehículo cuenta con imágenes de alta calidad y especificaciones detalladas para facilitar tu elección. Guarda tus favoritos y realiza tu reserva de manera rápida y sencilla. Tu experiencia de viaje excepcional comienza aquí."

### **Proceso de Reservas**
1. **Selecciona tu Fecha**: Inicia el proceso eligiendo el rango de fechas en el que deseas reservar el vehículo de tu interés. Esta funcionalidad garantiza que tengas disponibilidad para tus planes.
2. **Confirma tu Elección**: Una vez que hayas seleccionado las fechas, la opción para reservar el vehículo se habilitará, permitiéndote proceder con confianza.
3. **Realiza tu Pago**: Al presionar el botón "Reservar", se abrirá automáticamente nuestra integración segura con Stripe, donde podrás ingresar tus datos de pago de manera rápida y segura.

### **Favoritos y Calendario**
- **Pantalla de Favoritos**: Visualiza todos tus vehículos preferidos en un solo lugar.
- **Calendario de Reservas**: Revisa tus reservas actuales con detalles de fecha de inicio, fecha de devolución y el total pagado.

### **Visualización de Ventas para Administradores**
Los administradores pueden ver las ventas mediante un gráfico de barras que muestra las tendencias de compra y el vehículo con mayor cantidad de reservas. Además, pueden generar un archivo PDF con todas las compras realizadas hasta la fecha, incluyendo el día de cada transacción.

## **Instalación**
1. Clona el repositorio:
   ```bash
   git clone https://github.com/tobias-tj/RentalCarApp

## **Configuración**

### **Para Android:**
1. **Archivo `google-services.json`**: 
   - Debes crear un archivo `google-services.json` y colocarlo en la carpeta `android/app/` para habilitar las funcionalidades de Firebase. 
   - Puedes crear este archivo desde la consola de Firebase al agregar tu proyecto de Android.

### **Para iOS:**
1. **Archivo `GoogleService-Info.plist`**: 
   - Descarga el archivo de configuración de Firebase para iOS y colócalo en la carpeta `ios/Runner/`. 
   - Asegúrate de seguir las instrucciones de la consola de Firebase para la correcta configuración de tu proyecto.

