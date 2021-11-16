---
date: 2021-11-8
title: "Implantación de paginas web y su monitorización con New Relic utilizando kubernetes"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - TFC
tags:
    - New Relic
    - Kubernetes
    - Web
    - Despligue
    - Monitorización
    - Logs
    - Metricas
---

![PracticaImg](images/proyecto/portada.png "Portada principal")


<ol>
  <li><a href="#newrelic">New Relic</a></li>
  <li><a href="#web">Pagina web</a></li>
  <li><a href="#kubernetes">Kubernetes</a></li>
  <li><a href="#integracion">Integración</a></li>
</ol>



Este proyecto contemplará la utilización de **New Relic** para obtener metricas y logs de una **web** desplegada a traves de **kubernetes**, para comenzar explicaremos un poco que es **New Relic** y como funciona.

<hr id="newrelic" >




# New Relic

## ¿Que es New Relic?

New Relic es una herramienta de medición del rendimiento de una infraestructura de servicios, desde backend hasta frontend: medición del rendimiento de navegadores, APIs, servidores, aplicaciones móviles… ¿Qué nos permite hacer?

**Este software es capaz de realizar las siguientes tareas (entre otras muchas):**

- Monitorizar Conexiones HTTP (tiempos de respuesta, nº de peticiones…).
- Monitorización de errores (avisos cuando se detectan fallos de ejecución o conexión).
- Fijar alertas sobre datos de referencia (tiempos de respuesta, errores de autenticación…).
- Estadísticas de rendimiento en distintos dispositivos (uso de memoria, velocidad de respuesta,…).
- Estadísticas de usuarios que la usen según el SO utilizado.

**Esta herramienta además soporta diferentes plataformas:**
Aplicaciones WEB (APM)

**Permite monitorizar aplicaciones web en los siguientes lenguajes:**

- Ruby
- PHP
- Java (la miraremos un poco más en detalle)
- .NET
- Python
- NodeJs

**Aplicaciones Móviles (Mobile)**
<hr>

**Permite monitorizar nuestras aplicaciones para móviles (Android, iOS y Titanium).**
Navegadores (Browser)

**Permite monitorizar nuestro sitio sobre el navegador del usuario (tiempo de respuesta, tiempo de carga de elementos…).**
Usuarios (Synthetics)

**Permite simular usuarios (tanto flujo como interacciones) para anticiparse a los errores. Usa el servicio de alertas para avisar de esto.**
Servidores (Servers)

**Nos da una vista del servidor desde la perspectiva de la propia aplicación.**
Otros

Además de las características arriba descritas, nos ofrece un amplio abanico de **Plugins** para ayudarnos con ellas, e incluso añadir nuevas funcionalidades, soporte en la nube y integración con kubernete que veremos mas adelante.

## ¿Como funciona?

**New Relic** consta con varias aplicaciones, para no hablar de todas ellas veremos las que utilizaremos en este proyecto:

- **New Relic Browser**: New Relic monitoriza todo lo relacionado a las peticiones HTTP y HTTPs que realizamos dentro de un navegador, desde los tiempos de carga con histogramas, percentiles y gráficos con segmentación hasta reportes geográficos, rendimiento con toda la parte de backend y alertas relacionadas con peticiones AJAX y errores del Javascript. Lógicamente todos los tableros de monitorización son personalizables. 


![PracticaImg](images/proyecto/newrelic-browser-ejemplo.png "Ejemplo de new relic browser")

- **New Relic Synthetics**: Permite monitorizar una aplicación móvil en todo su ciclo de vida, incluso en la fase de preproducción, desde la fase de desarrollo hasta las pruebas de testeo. Y una vez lanzado, también facilita la recolección de insights para medir el rendimiento. 

Ya tenemos una idea de que es **New Relic**, que datos recoge y como funciona, ahora daremos paso al proyecto comenzando con la instalacion de **New Relic**.

<hr>

Para instalar **New Relic** primero deberemos acceder a su [website](https://newrelic.com/), nos registraremos:
![PracticaImg](images/proyecto/newrelic-singin.png "registro new relic")


Una vez registrado procederemos a su instalación:
![PracticaImg](images/proyecto/newrelic-instalacion.png "instalación new relic")

<hr id="web" >




<hr id="kubernete" >




<hr id="integracion" >




