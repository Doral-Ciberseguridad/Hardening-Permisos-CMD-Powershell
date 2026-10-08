# Esta línea obliga a que el usuario ejecute el script con permisos de administrador. Considero que esto es necesario.
#Requires -RunAsAdministrator   




# Imprimo en pantalla el texto que explica en que consiste mi programa
Write-Host ""
Write-Host "Este script usa icalcs para restringir y bloquear CMD, todos los tipos de Powershell y otras herramientas de ejecucion de comandos nativas de Windows"
Write-Host "a todos los usuarios que no se llamen 'Admin' o 'Administrador'. El objetivo es evitar el uso malintencionado de estas herramientas por parte de los atacantes."
Write-Host 
Read-Host 'Presiona Enter para continuar'





# Imprimo en pantalla el titulo del primer paso
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "PASO 1 - OBTENER Y LISTAR LOS IDENTIFICADORES SID DE TODOS LOS USUARIOS DEL SISTEMA "
Write-Host "(Cada SID es distinto en cada ordenador)"


# Obtengo el SID del usuario "Admin" 
$usuario_admin='Admin'
$usuario_admin = New-Object System.Security.Principal.NTAccount($usuario_admin) 
$sid_admin = $usuario_admin.Translate([System.Security.Principal.SecurityIdentifier]) 
Write-Host ""
Write-Host "El SID del usuario Admin es -->   " $sid_admin.Value


# Obtengo el SID del usuario "Administrador" 
$usuario_administrador='Administrador'
$usuario_administrador = New-Object System.Security.Principal.NTAccount($usuario_administrador) 
$sid_administrador = $usuario_administrador.Translate([System.Security.Principal.SecurityIdentifier]) 
Write-Host ""
Write-Host "El SID del usuario Administrador es -->   " $sid_administrador.Value


# Listo los SID de todos los usuarios
$listaUsuarios = Get-LocalUser | Select-Object -ExpandProperty Name
Write-Host ""
Write-Host "Estos son los SID de los demas usuarios del sistema:"
# Elimino los caracteres raros innecesarios para que la salida sea limpia:
foreach ($usuario in $listaUsuarios) {
    $SID_usuario = Get-LocalUser -Name $usuario | Select-Object SID 
    $SID_usuario = $SID_usuario -replace "@", ""
    $SID_usuario = $SID_usuario -replace "{", ""
    $SID_usuario = $SID_usuario -replace "}", ""
    Write-Host $SID_usuario
}   
Start-Sleep -Seconds 3





# Imprimo en pantalla el título del segundo paso
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "PASO 2 - BLOQUEAR POWERSHELL/CMD A USUARIOS QUE NO TENGAN SID DE ADMIN O ADMINISTRADOR"
Write-Host "Bloqueando permisos..."
Start-Sleep -Seconds 2
Write-Host ""

# Uso un bucle for para guardar el SID de cada usuario de manera limpia sin caracteres extraños.
foreach ($usuario in $listaUsuarios) {

    # Aquí obtengo el nombre de usuario
    $objUsuario = Get-LocalUser -Name $usuario -ErrorAction SilentlyContinue
    if (-not $objUsuario -or -not $objUsuario.SID) { continue }
    
    # Aquí es donde obtengo el valor SID
    $SID_usuario = $objUsuario.SID.Value.Trim()
    # Vuelvo a limpiar los caracteres innecesarios
    $SID_usuario = $SID_usuario -replace '[@{}]', ''

    if (-not $SID_usuario) { continue }

    Write-Host "Procesando SID: $SID_usuario"

    # Uso un condicional if para comprobar si el SID que se está evaluando es el de Admin/Administrador
    if ($SID_usuario -ne $sid_admin.Value -and $SID_usuario -ne $sid_administrador.Value) {
        $regla = $usuario + ":F"

        # En caso que sea un usuario normal bloqueo todas estas aplicaciones a ese usuario
        icacls "$env:windir\System32\cmd.exe" /deny $regla
        Write-Host "Se ha bloqueado CMD (64-bit) al usuario $usuario"

        icacls "$env:windir\SysWOW64\cmd.exe" /deny $regla
        Write-Host "Se ha bloqueado CMD (32-bit) al usuario $usuario"

        icacls "$env:windir\System32\WindowsPowerShell\v1.0\powershell.exe" /deny $regla
        Write-Host "Se ha bloqueado PowerShell (64-bit) al usuario $usuario"

        icacls "$env:windir\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" /deny $regla
        Write-Host "Se ha bloqueado PowerShell (32-bit) al usuario $usuario"

        icacls "$env:windir\System32\WindowsPowerShell\v1.0\powershell_ise.exe" /deny $regla
        Write-Host "Se ha bloqueado PowerShell ISE (64-bit) al usuario $usuario"

        icacls "$env:windir\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe" /deny $regla
        Write-Host "Se ha bloqueado PowerShell ISE (32-bit) al usuario $usuario"

        $rutaPWSH7 = "$env:ProgramFiles\PowerShell\7\pwsh.exe"
        if (Test-Path $rutaPWSH7) {
            icacls $rutaPWSH7 /deny $regla
            Write-Host "Se ha bloqueado PowerShell 7 al usuario $usuario"
        }

        icacls "$env:windir\System32\bitsadmin.exe" /deny $regla
        Write-Host "Se ha bloqueado Bitsadmin al usuario $usuario"

        icacls "$env:windir\System32\cscript.exe" /deny $regla
        Write-Host "Se ha bloqueado CScript al usuario $usuario"

        icacls "$env:windir\System32\wscript.exe" /deny $regla
        Write-Host "Se ha bloqueado WScript al usuario $usuario"

    # En caso de que sea Admin/Administrador no bloqueo las aplicaciones porque quiero conservar su acceso
    } elseif ($SID_usuario -eq $sid_admin.Value -or $SID_usuario -eq $sid_administrador.Value) {
        Write-Host "Este SID es el mismo que el de Admin/Administrador. No se le deniega permisos."

    # En caso de que haya algun error lo imprimo por pantalla
    } else {
        Write-Host "Ha habido un error a la hora de comparar los SID."
    }
}
Start-Sleep -Seconds 2





# Imprimo el mensaje final
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "Fin del programa."
Write-Host ""
