# Randomusers

> **AVISO CRÍTICO:** La persistencia remota se realiza mediante **CloudKit**. Por lo tanto, el usuario debe iniciar sesión en el simulador de iPhone con una cuenta de iCloud válida, o de lo contrario la persistencia remota fallará.

**Desarrollado por:** Mikel Cobián

---

## Persistencia Remota con CloudKit

> **Punto Crítico:** La persistencia remota se realiza mediante **CloudKit**.  
> **Importante:** El usuario debe iniciar sesión en el simulador de iPhone con una cuenta de iCloud válida para asegurar el correcto funcionamiento de CloudKit.

---

## Descripción del Proyecto

Randomusers es una aplicación móvil (Android/iOS) que muestra información de usuarios aleatorios. El proyecto fue desarrollado como parte de un test técnico para RandomUser Inc., una empresa que desea exhibir datos aleatorios de usuarios de forma dinámica y atractiva. La aplicación permite:

- Visualizar una lista de usuarios con su nombre, apellido, correo electrónico, foto y teléfono.
- Cargar más usuarios mediante un mecanismo de _infinite scroll_.
- Eliminar usuarios de la lista (los eliminados no se vuelven a mostrar).
- Filtrar usuarios por nombre, apellido o correo electrónico, actualizando la lista una vez que se deja de escribir.
- Visualizar detalles completos de un usuario al seleccionarlo.
- Ejecutar pruebas (tests) en las partes críticas de la aplicación para asegurar su correcto funcionamiento.

---

## Requisitos del Proyecto

### Requisitos Obligatorios (SHOULD)
- **Lista de Usuarios:**  
  Mostrar una lista con la siguiente información:
  - Nombre y apellido.
  - Correo electrónico.
  - Foto.
  - Teléfono.

- **Interfaz de Usuario:**  
  Utilizar el framework de UI que se considere más adecuado para implementar la interfaz.

- **Scroll Infinito:**  
  Implementar un mecanismo de _infinite scroll_ para la carga dinámica de más usuarios.

- **Eliminación de Usuarios:**  
  Permitir eliminar usuarios de la lista; los usuarios eliminados no deben volver a aparecer.

- **Filtrado de Usuarios:**  
  Posibilidad de filtrar la lista por nombre, apellido o correo electrónico. La lista se actualizará automáticamente una vez que el usuario deje de escribir.

- **Detalle del Usuario:**  
  Al presionar sobre un usuario de la lista, se mostrará una vista con información detallada del mismo.

- **Testing:**  
  Incluir pruebas en las partes más importantes de la aplicación.

### Características Adicionales (NICE TO HAVE)
- **Persistencia de Datos:**  
  Persistir la información de los usuarios entre sesiones de la aplicación.

- **Gestión de Usuarios en Lista Negra:**  
  Incluir una funcionalidad para comprobar los usuarios que han sido eliminados (lista negra).

---

## Consideraciones Técnicas

- **Usuarios Duplicados:**  
  La aplicación debe evitar mostrar usuarios duplicados. Si la API devuelve el mismo usuario más de una vez, se almacenará y mostrará solo una instancia.

- **Arquitectura:**  
  El diseño del proyecto sigue los principios SOLID y una Clean Architecture para asegurar la mantenibilidad y escalabilidad del código.

- **Control de Versiones:**  
  El código se entrega a través de un repositorio público (por ejemplo, GitHub o Bitbucket) o en un archivo zip con el repositorio git incluido. Se recomienda el uso de mensajes de commit descriptivos para documentar las decisiones tomadas.

- **Documentación de Decisiones:**  
  Si existen funcionalidades incompletas o decisiones de diseño que no sean evidentes, se debe incluir una breve explicación en este documento.

---

## API Utilizada

- **Endpoint para obtener usuarios:**  
  [http://api.randomuser.me/?results=40](http://api.randomuser.me/?results=40)

- **Documentación completa:**  
  [https://randomuser.me/documentation](https://randomuser.me/documentation)

- **Ejemplo de respuesta JSON:**  
  [https://randomuser.me/documentation#results](https://randomuser.me/documentation#results)

---
