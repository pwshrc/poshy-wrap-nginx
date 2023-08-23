#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command nginx)) {
    return
}

<#
.SYNOPSIS
    Reload your nginx config.
.COMPONENT
    nginx
#>
function nginx_reload {
    if (-not $Env:NGINX_PATH) {
        throw "`$Env:NGINX_PATH not set"
    }
    $FILE="${Env:NGINX_PATH}/logs/nginx.pid"
    if (Test-Path $FILE -ErrorAction SilentlyContinue) {
        Write-Output "Reloading NGINX…"
        $nginx_pid = (Get-Content $FILE).Trim()
        sudo kill -HUP $nginx_pid
    } else {
        Write-Error "Nginx pid file not found"
    }
}

<#
.SYNOPSIS
    Stop nginx.
.COMPONENT
    nginx
#>
function nginx_stop {
    if (-not $Env:NGINX_PATH) {
        throw "`$Env:NGINX_PATH not set"
    }
    $FILE="${Env:NGINX_PATH}/logs/nginx.pid"
    if (Test-Path $FILE -ErrorAction SilentlyContinue) {
        Write-Output "Stopping NGINX…"
        $nginx_pid = (Get-Content $FILE).Trim()
        sudo kill -INT $nginx_pid
    } else {
        Write-Error "Nginx pid file not found"
    }
}

<#
.SYNOPSIS
    Start nginx.
.COMPONENT
    nginx
#>
function nginx_start {
    if (-not $Env:NGINX_PATH) {
        throw "`$Env:NGINX_PATH not set"
    }
    $FILE="${Env:NGINX_PATH}/sbin/nginx"
    if (Test-x $FILE) {
        Write-Output "Starting NGINX…"
        sudo "${FILE}"
    } else {
        Write-Error "Couldn't start nginx"
    }
}

<#
.SYNOPSIS
    Restart nginx.
.COMPONENT
    nginx
#>
function nginx_restart() {
    nginx_stop
    if ($LASTEXITCODE -ne 0) {
        return
    }
    nginx_start
}


Export-ModuleMember -Function * -Alias *
