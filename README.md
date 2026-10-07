Pasos para ejecutar y usar esta herramienta:


1. Clona o descarga el repositorio en tu máquina ejecutando este comando:

```
git clone https://github.com/Doral-Ciberseguridad/Hardening-Permisos-CMD-Powershell.git
```


2. Asegúrate de contar con los privilegios necesarios del sistema ejecutando tu terminal como Administrador



3. Lanza el script de PowerShell haciendo clic derecho y seleccionando "Ejecutar con PowerShell" o desde tu terminal elevada ejecutando:

```
./Bloquear_permisos_usuarios_Powershell_CMD.ps1
```



4. Presiona Enter cuando se te solicite para continuar y visualizar en pantalla el listado de los identificadores SID de todos los usuarios del sistema

<img width="1292" height="116" alt="image" src="https://github.com/user-attachments/assets/514f8081-ef5d-49aa-b744-8b0846259216" />

Asegúrate de leer bien el mensaje inicial. Explica que es lo que se le va a hacer a tu equipo.




5. Comprueba cómo el script procesa cada SID de forma automática para restringir y bloquear el acceso a CMD, PowerShell, Bitsadmin y WScript a todos los usuarios que no sean Admin o Administrador

Si escribes Powershell en el buscador y lo intentas ejecutar con tu usuario normal no debería de dejarte.

<img width="852" height="893" alt="image" src="https://github.com/user-attachments/assets/32a94f1f-24a1-49d7-9c2d-b8bcfac6e148" />

