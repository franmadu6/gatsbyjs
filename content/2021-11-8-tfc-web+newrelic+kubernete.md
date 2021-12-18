---
date: 2021-11-8
title: "Implantación de aplicación web y su monitorización con New Relic utilizando kubernetes"
cover: "https://img.icons8.com/ios/452/work.png"
categories: 
    - TFC
tags:
    - New Relic
    - Kubernetes
    - Aplicación Web
    - Despligue
    - Monitorización
    - Logs
    - Metricas
    - Alertas
---

![PracticaImg](images/proyecto/portada.png "Portada principal")

1. <a href="#lista1">Monitorización y análisis de aplicaciones web con new relic: Aquí explicas las características de la herramienta.</a>
    <p>1.1  <a href="#lista11">¿Cómo funciona?</a></p>
    <p>1.2  <a href="#lista12">Instalación de New Relic: Dejando claro donde se está instalando.</a></p>
2. <a href="#lista2">New Relic One</a>
3. <a href="#lista3">Kuberntes: Explicas que vas a desplegar una aplicación web para monitorizarla con new relic, en kuberntes, y que para ello vas a usar minikube, para crear un cluster de ejmplo.</a>
    <p>3.1  <a href="#lista31">Instalación de minikube.</a></p>
    <p>3.2  <a href="#lista32">Instalaciión de kubectl.</a></p>
    <p>3.3  <a href="#lista33">Escenario: Desplieque de una aplicación web.</a></p>
4. <a href="#lista4">Monitorización de nuestra aplicación con new relic.</a>
    <p>4.1  <a href="#lista41">Monitorización de un cluster de kubernetes</a></p>
    <p>4.2  <a href="#lista42">Monitorizar Conexiones HTTP</a></p>
    <p>4.3  <a href="#lista43">Mostrar Eventos</a></p>
    <p>4.4  <a href="#lista44">Fijar alertas</a></p>
    <p>4.5  <a href="#lista45">Gestión de logs</a></p>
    <p>4.6  <a href="#lista46">Estadísticas de rendimiento</a></p>
    <p>4.7  <a href="#lista47">Creación y gestión de nuevas Dashboard</a></p>

<hr id="lista1" >
<br>
<details open>
<summary>

## 1. New Relic 
</summary>


<details open>
<summary>

## ¿Que es New Relic?
</summary>

New Relic es una herramienta de medición del rendimiento de una infraestructura de servicios, desde backend hasta frontend: medición del rendimiento de navegadores, APIs, servidores, aplicaciones móviles… ¿Qué nos permite hacer?

* Este software es capaz de realizar las siguientes tareas:

  * Monitorizar Conexiones HTTP (tiempos de respuesta, nº de peticiones…).
  * Monitorización de errores (avisos cuando se detectan fallos de ejecución o conexión).
  * Fijar alertas sobre datos de referencia (tiempos de respuesta, errores de autenticación…).
  * Estadísticas de rendimiento en distintos dispositivos (uso de memoria, velocidad de respuesta,…).
  * Estadísticas de usuarios que la usen según el SO utilizado.

* Esta herramienta además soporta diferentes plataformas:
Aplicaciones WEB (APM)

* Permite monitorizar aplicaciones web en los siguientes lenguajes:

  * Ruby
  * PHP
  * Java
  * NET
  * Python
  * NodeJs

* Permite monitorizar nuestras aplicaciones para móviles (Android, iOS y Titanium).  
Navegadores (Browser)

* Permite monitorizar nuestro sitio sobre el navegador del usuario (tiempo de respuesta, tiempo de carga de elementos…).  
Usuarios (Synthetics)

* Permite simular usuarios (tanto flujo como interacciones) para anticiparse a los errores. Usa el servicio de alertas para avisar de esto.  
Servidores (Servers)

* Nos da una vista del servidor desde la perspectiva de la propia aplicación.

Además de las características arriba descritas, nos ofrece un amplio abanico de **plugins** para ayudarnos con ellas, e incluso añadir nuevas funcionalidades, soporte en la nube y integración con kubernete que veremos mas adelante.
</details>

<hr id="lista11" >
<br>
<details open>
<summary>

## 1.1 ¿Como funciona?
</summary>

Recopila una serie de parámetros que monitoriza a traves de nuestro navegador, para ello se lanza un agente dentro de la maquina de la que se quiera recopilar información, dependiendo de si es para recolectar datos de nuestro propio sistema o un cluster de kubernetes que tenemos alojado en la misma, etc... dependiendo del tipo de dato que necesitemos New Relic los suministrará la instalación del agente adecuado.

Podremos crear vistas en las que tengamos metricas de diferentes agentes y ademas todo el sistema es codigo abierto por lo tanto podremos modificar tambien algun agente para adaptarlo a nuestra necesidades y asi tener una monitorización mas personalizada.

Podemos ver utilidades o ejemplos de monitorización como los siguientes:

- **New Relic Browser**: New Relic monitoriza todo lo relacionado a las peticiones HTTP y HTTPs que realizamos dentro de un navegador, desde los tiempos de carga con histogramas, percentiles y gráficos con segmentación hasta reportes geográficos, rendimiento con toda la parte de backend y alertas relacionadas con peticiones AJAX y errores del Javascript. Lógicamente todos los tableros de monitorización son personalizables. 

![PracticaImg](images/proyecto/newrelic-browser-ejemplo.png "Ejemplo de new relic browser")

- **New Relic Synthetics**: Permite monitorizar una aplicación móvil en todo su ciclo de vida, incluso en la fase de preproducción, desde la fase de desarrollo hasta las pruebas de testeo. Y una vez lanzado, también facilita la recolección de insights para medir el rendimiento. 

Ya tenemos una idea de que es New Relic, que datos recoge y como funciona, ahora daremos paso al proyecto comenzando con la instalacion de New Relic.
</details>

<hr id="lista12" >
<br>
<details open>
<summary>

## 1.2 Instalación de New Relic
</summary>

Realizaremos una instalación simple para poder para poder visualizar las metricas de nuestra maquina llamada **Central** en Openstacks. Para instalar New Relic primero deberemos acceder a su [website](https://newrelic.com/) para registrarnos y dar de alta nuestra cuenta que será necesaria para el acceso a nuestras vistas:

![PracticaImg](images/proyecto/newrelic-singin.png "registro new relic")

Una vez registrado procederemos a la implementación de new relic en nuestro entorno, para comenzar le daremos al icono [+ add more data]

![PracticaImg](images/proyecto/newrelic-addmoredata.png "newrelic-addmoredata.png")

Nos iremos a la sección de host y seleccionaremos Ubuntu:

![PracticaImg](images/proyecto/newrelic-instalacion.png "instalación new relic")

En el plan de instalación nos pedira que instalemos el agente de New Relic:

**Agente**: Algunas integraciones de New Relic requieren la instalación manual de un agente. La forma en que se configura el comportamiento de esos agentes depende del agente específico(APM, infraestructuras, navegadores, movil, otros...).

![PracticaImg](images/proyecto/newrelic-instalacion2.png "instalación new relic")

![PracticaImg](images/proyecto/newrelic30.png "instalación new relic")

El link que nos proporcionará es el de instalación del agente a nuestro sistema operativo:

**Nota**: Para no tener la web tan cargada he movido la captura de mi terminal a mi repositorio de Github:  
- <a href="https://github.com/franmadu6/tfc-data/blob/main/instalacion-newrelic-v" target="blank">Repositorio instalación New Relic</a>

Una vez la instalación haya sido finalizada volveremos al navegador y veremos como la pantalla ha cambiado, nos dejara darle a **See your data** para concluir la instalación, he de destaca que si nuestro equipo posee php, java, alguna base de datos, etc... Tambien lo detectaria el agente y nos lo instalaria al ejecutarlo.

![PracticaImg](images/proyecto/newrelic31.png "instalación new relic")

Y listo! Ya tendremos nuestro agente instalado y listo para usarse.

Estos son algunos datos de los que podemos obtener atraves de new relic, que profundizaremos en ellos mas adelante.

**Debian**
![PracticaImg](images/proyecto/newrelic32.png "instalación new relic")
![PracticaImg](images/proyecto/newrelic33.png "instalación new relic")
![PracticaImg](images/proyecto/newrelic34.png "instalación new relic")
</details>
</details>

<hr id="lista2" >
<br>
<details open>
<summary>

## 2. New Relic One
</summary>

Detectar, corregir y prevenir: esa es la promesa del monitoreo de software. ¿Pero qué pasa cuando las soluciones costosas impiden instrumentar todo y los enfoques poco sistemáticos producen un aumento en la cantidad de herramientas? Cuando los datos de desempeño de la aplicación, de la infraestructura y de los usuarios finales están dispersos por herramientas de monitoreo que no están conectadas, la detección y resolución de problemas puede ser innecesariamente compleja y puede consumir mucho tiempo.

Ahí es donde New Relic One marca la diferencia: una plataforma capaz de escalar masivamente y que recolecta y contextualiza todos los datos operativos—sin importar de dónde vengan—y simplifica la instrumentación, la ingestión de datos, la exploración, la correlación y el análisis basado en aprendizaje automático (machine learning), para reforzar la observabilidad de cada organización.

![PracticaImg](images/proyecto/new-relic-one-platform-es.png "new-relic-one-platform-es.png")


**Telemetry Data Platform**,todos los datos de telemetría en un solo lugar:

Recopile, explore y genere alertas en relación a todas las métricas, eventos, registros y rastros sin importar cuál sea su origen en una base de datos de telemetría abierta y unificada. Las integraciones—que vienen listas para usarse—con herramientas de código abierto como Prometheus y Grafana, por nombrar solo dos, eliminan el costo y la complejidad de administrar el almacenamiento de datos adicional.

![PracticaImg](images/proyecto/telemetry-data-platform-es.png "telemetry-data-platform-es.png")



**Todos sus datos en un solo lugar con Telemetry Data Platform.**

* Con Telemetry Data Platform, obtendrá lo siguiente:

  * Integraciones con más de 300 agentes y estándares como OpenTelemetry, lo que le permite ingerir y guardar todos los datos operativos en un solo lugar
  * Tiempos de consulta y respuesta ultra rápidos
  * La posibilidad de elegir entre crear paneles en New Relic One o conservar los flujos de trabajo existentes en Grafana
  * Alertas en tiempo real en relación a los datos
  * APIs y herramientas para crear aplicaciones personalizadas alojadas en New Relic One

**Full-Stack Observability**


Visualice y resuelva problemas de todo el stack en una experiencia unificada

Full-Stack Observability amplía la capacidad de Telemetry Data Platform, y proporciona una experiencia conectada que facilita entender en qué condición se encuentra el sistema dentro de su contexto, desde registros, infraestructura, aplicaciones y datos de la experiencia del usuario final. Elimine el trabajo extra y los puntos ciegos gracias a vistas especializadas que presentan los problemas automáticamente a sus equipos incluso antes de que a usted se le ocurra preguntar.

![PracticaImg](images/proyecto/kubernetes-cluster-explorer_1.png "kubernetes-cluster-explorer_1.png")

El explorador de clústeres de Kubernetes de New Relic reúne todos los elementos de observabilidad: métricas, eventos, registros y rastros.

Con Full-Stack Observability, obtendrá lo siguiente:

  * Toda la funcionalidad de New Relic que conoce y que tanto le agrada—APM, Infrastructure, Logs in Context, Distributed Tracing, Serverless, Browser, Mobile y Synthetics—todo en un solo paquete
  * Información contextual acerca de sus servicios distribuidos, aplicaciones y funciones sin servidor, sin importar cómo o dónde se hayan desarrollado
  * Visibilidad incomparable en los hosts de infraestructura, contenedores, recursos de nubes y clústers de Kubernetes
  * Análisis del rendimiento de extremo a extremo, desde los servicios de backend hasta la experiencia de los usuarios finales

**Applied Intelligence**


Detecte y resuelva problemas con más rapidez

Detecte, comprenda y resuelva los incidentes con más rapidez gracias a las potentes capacidades de AIOps. Applied Intelligence detecta y explica anomalías automáticamente antes de que se conviertan en incidentes, reduce el exceso de alertas repetidas gracias a que correlaciona las alertas relacionadas y diagnostica problemas enriqueciendo incidentes con contexto, lo que permite ir rápidamente a la raíz de los problemas.

![PracticaImg](images/proyecto/applied-intelligence-screenshot_1.png "applied-intelligence-screenshot_1.png")



Applied Intelligence utiliza el aprendizaje automático para automatizar las alertas.

Con Applied Intelligence, obtendrá lo siguiente:

  * Detección proactiva que detecta las anomalías antes de que se conviertan en incidentes
  * Inteligencia sobre incidentes que reduce el exceso de alertas repetidas y prioriza los problemas
  * Configuraciones con herramientas como Slack y PagerDuty para agilizar el diagnóstico y los tiempos de respuesta


**Observabilidad simplificada**

Con New Relic One podrá pasar menos tiempo resolviendo problemas y más tiempo diseñando software. Instrumente todo para eliminar los puntos ciegos, y hágalo a una escala de Petabytes. Practique la observabilidad del stack completo y aproveche Applied Intelligence y el aprendizaje automático para detectar problemas rápidamente y reducir el exceso de alertas repetidas. Bienvenido a la era de la observabilidad.

</details>

<hr id="lista3" >
<br>
<details open>
<summary>

## 3. Kubernetes: Explicas que vas a desplegar una aplicación web para monitorizarla con new relic, en kuberntes, y que para ello vas a usar minikube, para crear un cluster de ejmplo.
</summary>

EXPLICACIÓN SOBRE LA PRACTICA DE KUBERNETES


<hr id="lista31" >
<br>
<details open>
<summary>

## 3.1 Instalación de minikube
</summary>

Antes monitorizar nuestro cluster deberemos de confirgurarlo primero, para ello utilizaremos **minikube** para crear nuestros clusters, procederemos a su instalación.
```shell
vagrant@svKube:~$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 66.3M  100 66.3M    0     0  3995k      0  0:00:17  0:00:17 --:--:-- 3952k
vagrant@svKube:~$ sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

Al inicializarlo nos da varios errores en mi casa tuve que ejecutarlo con minikube start --vm-driver=none y instalar docker,docker.io y conntrack, este fue un poco el historial de comandos que ejecute.
```shell
vagrant@svKube:~$ minikube start
vagrant@svKube:~$ minikube start --vm-driver=none
root@svKube:/home/vagrant# apt install docker docker.io
root@svKube:/home/vagrant# minikube start --vm-driver=none
root@svKube:/home/vagrant# sudo apt-get install -y conntrack
```

Ahora si podremos ejecutarlo correctamente:
```shell
root@svKube:/home/vagrant# minikube start --vm-driver=none
😄  minikube v1.24.0 on Debian 10.11 (vbox/amd64)
✨  Using the none driver based on user configuration

🧯  The requested memory allocation of 1995MiB does not leave room for system overhead (total system memory: 1995MiB). You may face stability issues.
💡  Suggestion: Start minikube with less memory allocated: 'minikube start --memory=1995mb'

👍  Starting control plane node minikube in cluster minikube
🤹  Running on localhost (CPUs=2, Memory=1995MB, Disk=20029MB) ...
ℹ️  OS release is Debian GNU/Linux 10 (buster)
    > kubeadm.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubectl.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubelet.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubeadm: 43.71 MiB / 43.71 MiB [---------------] 100.00% 3.84 MiB p/s 12s
    > kubectl: 44.73 MiB / 44.73 MiB [---------------] 100.00% 3.86 MiB p/s 12s
    > kubelet: 115.57 MiB / 115.57 MiB [-------------] 100.00% 4.01 MiB p/s 29s

    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🤹  Configuring local host environment ...

❗  The 'none' driver is designed for experts who need to integrate with an existing VM
💡  Most users should use the newer 'docker' driver instead, which does not require root!
📘  For more information, see: https://minikube.sigs.k8s.io/docs/reference/drivers/none/

❗  kubectl and minikube configuration will be stored in /root
❗  To use kubectl or minikube commands as your own user, you may need to relocate them. For example, to overwrite your own settings, run:

    ▪ sudo mv /root/.kube /root/.minikube $HOME
    ▪ sudo chown -R $USER $HOME/.kube $HOME/.minikube

💡  This can also be done automatically by setting the env var CHANGE_MINIKUBE_NONE_USER=true
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: default-storageclass, storage-provisioner
💡  kubectl not found. If you need it, try: 'minikube kubectl -- get pods -A'
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

Podremos apreciar su correcta instalación observando que sus pods estan corriendo.
```shell
root@svKube:/home/vagrant# minikube kubectl -- get pods -A
NAMESPACE     NAME                             READY   STATUS    RESTARTS   AGE
kube-system   coredns-78fcd69978-hchrh         1/1     Running   0          2m23s
kube-system   etcd-svkube                      1/1     Running   0          2m36s
kube-system   kube-apiserver-svkube            1/1     Running   0          2m36s
kube-system   kube-controller-manager-svkube   1/1     Running   0          2m38s
kube-system   kube-proxy-hv5zs                 1/1     Running   0          2m23s
kube-system   kube-scheduler-svkube            1/1     Running   0          2m36s
kube-system   storage-provisioner              1/1     Running   0          2m35s
```

Para comenzar su monitorización con **New relic** deberemos instalar **Helm**, la principal función de Helm es definir, instalar y actualizar aplicaciones complejas de Kubernetes. 
```shell
root@svKube:/home/vagrant# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
root@svKube:/home/vagrant# chmod 700 get_helm.sh
root@svKube:/home/vagrant# ./get_helm.sh
Downloading https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
```

El comando que nos proporciona **New relic** para establece una conexión con nuestro cluster no es valido para minikube, para ejecutarlo correctamente simplemente deberemos modificar la linea:
kubectl create namespace kube-system ; helm upgrade --install newrelic-bundle newrelic/nri-bundle \
por:
minikube kubectl create namespace kube-system ; helm upgrade --install newrelic-bundle newrelic/nri-bundle \

```shell
helm repo add newrelic https://helm-charts.newrelic.com && helm repo update && \
minikube kubectl create namespace kube-system ; helm upgrade --install newrelic-bundle newrelic/nri-bundle \
 --set global.licenseKey=eu01xx48059720c231a1080bc348906513e7NRAL \
 --set global.cluster=minikube \
 --namespace=kube-system \
 --set newrelic-infrastructure.privileged=true \
 --set global.lowDataMode=true \
 --set ksm.enabled=true \
 --set kubeEvents.enabled=true 
 ```

![PracticaImg](images/proyecto/newrelic6.png "monitorización de minikube")
</details>

<hr id="lista32" >
<br>
<details open>
<summary>

## 3.2 Instalación de kubectl
</summary>

Instalaremos kubectl atraves del gestor de paquetes pues es la manera mas comoda y sencilla, en la cual añadiremos el repositorio de kubernete a nuestra maquina para utilizar su gestor:
```shell
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```  
  
  
**Nota**: Para no tener la web tan cargada he movido la captura de mi terminal a mi repositorio de Github:  
- <a href="https://github.com/franmadu6/tfc-data/blob/main/instalacion-kubectl-v" target="blank">Repositorio instalación kubectl</a>

Para verificar su instalación veremos que versión fue instalada:
```shell
ubuntu@controlador:~$  kubectl version --client
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.0", GitCommit:"ab69524f795c42094a6630298ff53f3c3ebab7f4", GitTreeState:"clean", BuildDate:"2021-12-07T18:16:20Z", GoVersion:"go1.17.3", Compiler:"gc", Platform:"linux/amd64"}
```
  
  
</details>

<hr id="lista33" >
<br>
<details open>
<summary>

## 3.3 Escenario: Desplieque de una aplicación web.
</summary>

![PracticaImg](images/proyecto/esquemakubevagrant.png "esquemakubevagrant.png")

- <a href="https://github.com/franmadu6/tfc-data/blob/main/Vagrantfile" target="blank">Vagrantfile</a>

Para esta demostración de como New Relic monitoriza un cluster que tenga desplegado una app web, crearemos un escenario con 3 maquinas que constaran de un controlador con 2 workers que se encargaran de balancear y replicar la aplicación web que instalaremos en el controlador.   
  

### Instalación de k3s en el controlador.

Ejecutaremos el siguiente comando el cual realizará una instalación automática de k3s:
```shell
vagrant@controlador:~$ curl -sfL https://get.k3s.io | sh -
[INFO]  Finding release for channel stable
[INFO]  Using v1.21.7+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.21.7+k3s1/sha256sum-amd64.txt
[INFO]  Skipping binary downloaded, installed k3s matches hash
[INFO]  Skipping installation of SELinux RPM
[INFO]  Skipping /usr/local/bin/kubectl symlink to k3s, already exists
[INFO]  Skipping /usr/local/bin/crictl symlink to k3s, already exists
[INFO]  Skipping /usr/local/bin/ctr symlink to k3s, already exists
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
[INFO]  systemd: Enabling k3s unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s.service → /etc/systemd/system/k3s.service.
[INFO]  systemd: Starting k3s
```

Una vez instalado podremos obtener información de los nodos:
```shell
vagrant@controlador:~$ sudo kubectl get nodes
NAME          STATUS   ROLES                  AGE   VERSION
controlador   Ready    control-plane,master   72m   v1.21.7+k3s1
```

### Parámetros necesarios para los workers

Necesitaremos la INTERNAL-IP que podremos obtener de la salida del siguiente comando:
```shell
vagrant@controlador:~$ sudo kubectl get nodes -o wide
NAME          STATUS   ROLES                  AGE   VERSION        INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                       KERNEL-VERSION    CONTAINER-RUNTIME
controlador   Ready    control-plane,master   73m   v1.21.7+k3s1   10.15.198.198   <none>        Debian GNU/Linux 10 (buster)   4.19.0-18-amd64   containerd://1.4.12-k3s1
```

Para vincular los nuevos nodos con el controlador necesitaremos además de la ip de controller su token de verificación:
```shell
vagrant@controlador:~$ sudo cat /var/lib/rancher/k3s/server/node-token
K105a63e1097066148871e29940800e6dc96e5f053d48087f632b9bd27044190d52::server:848c555ce0c19353f1a452c9c570e832
```


### Instalación de k3s en los workers.  

La siguiente acción que realizaremos se hará de igual manera en ambos workers y consistira en añadire tanto la ip y el token obtenidos anteriormente a variables de entorno:
```shell
vagrant@worker1:~$ k3s_url="https://10.15.198.198:6443"
vagrant@worker1:~$ k3s_token="K105a63e1097066148871e29940800e6dc96e5f053d48087f632b9bd27044190d52::server:848c555ce0c19353f1a452c9c570e832"
```

```shell
vagrant@worker1:~$ curl -sfL https://get.k3s.io | K3S_URL=${k3s_url} K3S_TOKEN=${k3s_token} sh
[INFO]  Finding release for channel stable
[INFO]  Using v1.21.7+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.21.7+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.21.7+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Skipping installation of SELinux RPM
[INFO]  Creating /usr/local/bin/kubectl symlink to k3s
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Creating /usr/local/bin/ctr symlink to k3s
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-agent-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s-agent.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s-agent.service
[INFO]  systemd: Enabling k3s-agent unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s-agent.service → /etc/systemd/system/k3s-agent.service.
[INFO]  systemd: Starting k3s-agent
```

Una vez realizada la instalación en ambas maquinas podremos comprobar que estan operativas chequeando los nodos disponibles desde el controlador.
```shell
vagrant@controlador:~$ sudo kubectl get nodes
NAME          STATUS   ROLES                  AGE     VERSION
controlador   Ready    control-plane,master   89m     v1.21.7+k3s1
worker1       Ready    <none>                 4m52s   v1.21.7+k3s1
worker2       Ready    <none>                 13s     v1.21.7+k3s1
```
  
### Gestionar el cluster desde fuera del escenario.  

Deberemos instalar **kubectl** como hemos echo <a href="#lista32">anteriormente</a>, nos iremos a nuestro controlador y copiaremos el archivo /etc/rancher/k3s/k3s.yaml:
  
- <a href="https://github.com/franmadu6/tfc-data/blob/main/k3s.yaml-controlador" target="blank">k3s.yaml-controlador</a>

Crearemos un nuevo fichero de configuración y cambiaremos su ip por la de nuestro controlador para que quede así: 

- <a href="https://github.com/franmadu6/tfc-data/blob/main/k3s.yaml-central" target="blank">k3s.yaml-central</a>


Cargaremos el fichero con las credenciales:
```shell
fran@debian:~$ export KUBECONFIG=~/.kube/config
```

Y ya podremos comprobar que tenemos nuestros nodos estan operativos desde nuestra maquina anfitriona:
```shell
fran@debian:~$ kubectl get nodes
NAME          STATUS   ROLES                  AGE    VERSION
controlador   Ready    control-plane,master   111m   v1.21.7+k3s1
worker1       Ready    <none>                 27m    v1.21.7+k3s1
worker2       Ready    <none>                 23m    v1.21.7+k3s1
```

### Despligue de Letschat.

Ahora realizaremos un despliegue de la aplicación Letschat, clonaremos el repositorio del centro, el cual aparte del ejemplo que vamos a utilizar posee varios mas sobre la utilizaicon de kubectl:
```shell
fran@debian:~/vagrant/proyectonewrelic$ git clone https://github.com/iesgn/kubernetes-storm.git
Clonando en 'kubernetes-storm'...
remote: Enumerating objects: 288, done.
remote: Counting objects: 100% (288/288), done.
remote: Compressing objects: 100% (213/213), done.
remote: Total 288 (delta 119), reused 224 (delta 60), pack-reused 0
Recibiendo objetos: 100% (288/288), 6.36 MiB | 3.15 MiB/s, listo.
Resolviendo deltas: 100% (119/119), listo.
```

Nos desplazaremos al ejemplo8 citado en la tarea y ejecutaremos el siguiente comando:
```shell
fran@debian:~/vagrant/proyectonewrelic$ ls
1  kubernetes-storm  Vagrantfile
fran@debian:~/vagrant/proyectonewrelic$ cd kubernetes-storm/unidad3/ejemplos-3.2/ejemplo8/
fran@debian:~/vagrant/proyectonewrelic/kubernetes-storm/unidad3/ejemplos-3.2/ejemplo8$ kubectl apply -f .
Warning: networking.k8s.io/v1beta1 Ingress is deprecated in v1.19+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
ingress.networking.k8s.io/ingress-letschat created
deployment.apps/letschat created
service/letschat created
deployment.apps/mongo created
service/mongo created
```

El fichero desplegará varios servicios, pasado unos segundos podremos observar que ya estará todo listo:
```shell
fran@debian:~/vagrant/proyectonewrelic/kubernetes-storm/unidad3/ejemplos-3.2/ejemplo8$ kubectl get all,ingress
NAME                            READY   STATUS              RESTARTS   AGE
pod/letschat-7c66bd64f5-p6z55   0/1     ContainerCreating   0          18s
pod/mongo-5c694c878b-5nwmp      0/1     ContainerCreating   0          18s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/kubernetes   ClusterIP   10.43.0.1       <none>        443/TCP          4h46m
service/letschat     NodePort    10.43.173.187   <none>        8080:32241/TCP   18s
service/mongo        ClusterIP   10.43.20.221    <none>        27017/TCP        18s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mongo      0/1     1            0           18s
deployment.apps/letschat   0/1     1            0           18s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/mongo-5c694c878b      1         1         0       18s
replicaset.apps/letschat-7c66bd64f5   1         1         0       18s

NAME                                         CLASS    HOSTS              ADDRESS                                    PORTS   AGE
ingress.networking.k8s.io/ingress-letschat   <none>   www.letschat.com   10.108.155.90,10.15.198.198,10.99.38.185   80      18s
```

Servicios desplegados:

  * mongo-deployment, mongo-srv: Despliegue y conexión con una base de datos mongo.
  * letschat-deployment, letschat-srv: Despligue y servicio de la aplicación letschat y su conexión con una base de datos.
  * ingress: Para poder acceder a la apliación mediante un nombre.


### Escalado

Para que podamos comprobar el funcionamiento de escalado bastara con ejecutar el siguiente comando:
```shell
fran@debian:~$ kubectl scale deployment letschat --replicas=6
deployment.apps/letschat scaled
```

Pasados unos segundos las replicas estaran ya escaladas.

Nota: Deberás de tener en cuenta la capicidad de tu ordenador a la hora de escalar las replicas, ya que el proceso podria suponer demasiado estres en la maquina dando lugar a una relentizacióń o incluso caida de alguna de las máquinas del escenario:
```shell
fran@debian:~$ kubectl get all
NAME                            READY   STATUS    RESTARTS   AGE
pod/mongo-5c694c878b-5nwmp      1/1     Running   0          12m
pod/letschat-7c66bd64f5-p6z55   1/1     Running   3          12m
pod/letschat-7c66bd64f5-lsjk9   1/1     Running   0          92s
pod/letschat-7c66bd64f5-6p76p   1/1     Running   0          92s
pod/letschat-7c66bd64f5-gzx4v   1/1     Running   0          92s
pod/letschat-7c66bd64f5-ml8ww   1/1     Running   0          92s
pod/letschat-7c66bd64f5-vbt4d   1/1     Running   0          92s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/kubernetes   ClusterIP   10.43.0.1       <none>        443/TCP          4h58m
service/letschat     NodePort    10.43.173.187   <none>        8080:32241/TCP   12m
service/mongo        ClusterIP   10.43.20.221    <none>        27017/TCP        12m

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mongo      1/1     1            1           12m
deployment.apps/letschat   6/6     6            6           12m

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/mongo-5c694c878b      1         1         1       12m
replicaset.apps/letschat-7c66bd64f5   6         6         6       12m
fran@debian:~$ kubectl get deploy,rs,po -o wide
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                 SELECTOR
deployment.apps/mongo      1/1     1            1           12m   mongo        mongo                  name=mongo
deployment.apps/letschat   6/6     6            6           12m   letschat     sdelements/lets-chat   name=letschat

NAME                                  DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES                 SELECTOR
replicaset.apps/mongo-5c694c878b      1         1         1       12m   mongo        mongo                  name=mongo,pod-template-hash=5c694c878b
replicaset.apps/letschat-7c66bd64f5   6         6         6       12m   letschat     sdelements/lets-chat   name=letschat,pod-template-hash=7c66bd64f5

NAME                            READY   STATUS    RESTARTS   AGE   IP          NODE      NOMINATED NODE   READINESS GATES
pod/mongo-5c694c878b-5nwmp      1/1     Running   0          12m   10.42.2.4   worker2   <none>           <none>
pod/letschat-7c66bd64f5-p6z55   1/1     Running   3          12m   10.42.1.4   worker1   <none>           <none>
pod/letschat-7c66bd64f5-lsjk9   1/1     Running   0          96s   10.42.1.7   worker1   <none>           <none>
pod/letschat-7c66bd64f5-6p76p   1/1     Running   0          96s   10.42.1.6   worker1   <none>           <none>
pod/letschat-7c66bd64f5-gzx4v   1/1     Running   0          96s   10.42.2.7   worker2   <none>           <none>
pod/letschat-7c66bd64f5-ml8ww   1/1     Running   0          96s   10.42.2.8   worker2   <none>           <none>
pod/letschat-7c66bd64f5-vbt4d   1/1     Running   0          96s   10.42.2.6   worker2   <none>           <none>
```

Volvemos a rebajar el número de replicas a 1 para cuidar los recursos de nuestra maquina, como podemos comprobar esto no es instantaneo y se van parando los procesos poco a poco.
```shell
fran@debian:~/vagrant/proyectonewrelic$ kubectl scale deploy letschat --replicas=1
deployment.apps/letschat scaled
fran@debian:~/vagrant/proyectonewrelic$ kubectl get deploy,rs,po -o wide
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                 SELECTOR
deployment.apps/mongo      1/1     1            1           18h   mongo        mongo                  name=mongo
deployment.apps/letschat   1/1     1            1           18h   letschat     sdelements/lets-chat   name=letschat

NAME                                  DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES                 SELECTOR
replicaset.apps/mongo-5c694c878b      1         1         1       18h   mongo        mongo                  name=mongo,pod-template-hash=5c694c878b
replicaset.apps/letschat-7c66bd64f5   1         1         1       18h   letschat     sdelements/lets-chat   name=letschat,pod-template-hash=7c66bd64f5

NAME                            READY   STATUS        RESTARTS   AGE   IP           NODE          NOMINATED NODE   READINESS GATES
pod/mongo-5c694c878b-tgsnk      1/1     Running       0          69m   10.42.1.8    worker1       <none>           <none>
pod/letschat-7c66bd64f5-9z6fl   1/1     Running       0          69m   10.42.0.24   controlador   <none>           <none>
pod/letschat-7c66bd64f5-ml8ww   0/1     Terminating   0          18h   <none>       worker2       <none>           <none>
pod/mongo-5c694c878b-5nwmp      0/1     Terminating   0          18h   <none>       worker2       <none>           <none>
pod/letschat-7c66bd64f5-vbt4d   0/1     Terminating   0          18h   <none>       worker2       <none>           <none>
pod/letschat-7c66bd64f5-gzx4v   0/1     Terminating   0          18h   <none>       worker2       <none>           <none>
pod/letschat-7c66bd64f5-xmj76   1/1     Terminating   0          69m   10.42.0.25   controlador   <none>           <none>
pod/letschat-7c66bd64f5-6p76p   1/1     Terminating   5          18h   10.42.1.6    worker1       <none>           <none>
pod/letschat-7c66bd64f5-p6z55   1/1     Terminating   8          18h   10.42.1.4    worker1       <none>           <none>
pod/letschat-7c66bd64f5-g7dsf   1/1     Terminating   2          69m   10.42.1.9    worker1       <none>           <none>
pod/letschat-7c66bd64f5-lsjk9   1/1     Terminating   6          18h   10.42.1.7    worker1       <none>           <none>
```

### Componente ingress

Para comprobar que el componente ingress este operativo (recordemos que sirve para poder acceder a la aplicación mediante un nombre) intentaremos acceder nuestra pagina de letschat generada anteriormente, para ello añadiremos la ip a nuestro fichero de hosts y accederemos via web:
```shell
vagrant@controlador:~$ sudo kubectl get ingress
NAME               CLASS    HOSTS              ADDRESS                                    PORTS   AGE
ingress-letschat   <none>   www.letschat.com   10.108.155.90,10.15.198.198,10.99.38.185   80      19h

sudo nano /etc/hosts
10.108.155.90	www.letschat.com
```

La API que se usa en el proyecto se ha quedado obsoleta y no nos permite acceder via web, deberemos actualizarla el contenido para adaptarlo a la versión v1, para ello deberemos modificar el siguiente fichero para que quede así:
```shell
fran@debian:~/vagrant/proyectonewrelic/kubernetes-storm/unidad3/ejemplos-3.2/ejemplo8$ cat ingress.yaml 
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-letschat
spec:
  rules:
  - host: www.letschat.com
    http:
      paths:
      - path: "/"
        pathType: Prefix
        backend:
          service:
            name: letschat
            port:
              number: 8080
```

Ahora si podremos acceder a la aplicación:
![PracticaImg](images/proyecto/letschat.png "letschat.png")

### Simulacro de fallo

Simularemos una situación real en la que uno de los workers llegara a caerse, como usamos vagrant bastará con apagar la maquina worker2.
```shell
fran@debian:~/vagrant/proyectonewrelic$ vagrant halt worker2
==> worker2: Attempting graceful shutdown of VM...
==> worker2: Forcing shutdown of VM...
```

Como podemos comprobar tras volver a listar deply,replpicaset y pods estan empezando a fallar ya que se perdio la conexión con el worker2 
```shell
fran@debian:~/vagrant/proyectonewrelic$ kubectl get deploy,rs,po -o wide
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                 SELECTOR
deployment.apps/mongo      1/1     1            1           17h   mongo        mongo                  name=mongo
deployment.apps/letschat   3/6     6            3           17h   letschat     sdelements/lets-chat   name=letschat

NAME                                  DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES                 SELECTOR
replicaset.apps/mongo-5c694c878b      1         1         1       17h   mongo        mongo                  name=mongo,pod-template-hash=5c694c878b
replicaset.apps/letschat-7c66bd64f5   6         6         3       17h   letschat     sdelements/lets-chat   name=letschat,pod-template-hash=7c66bd64f5

NAME                            READY   STATUS             RESTARTS   AGE    IP           NODE          NOMINATED NODE   READINESS GATES
pod/letschat-7c66bd64f5-vbt4d   1/1     Terminating        0          17h    10.42.2.6    worker2       <none>           <none>
pod/letschat-7c66bd64f5-gzx4v   1/1     Terminating        0          17h    10.42.2.7    worker2       <none>           <none>
pod/mongo-5c694c878b-5nwmp      1/1     Terminating        0          17h    10.42.2.4    worker2       <none>           <none>
pod/letschat-7c66bd64f5-ml8ww   1/1     Terminating        0          17h    10.42.2.8    worker2       <none>           <none>
pod/letschat-7c66bd64f5-lsjk9   0/1     CrashLoopBackOff   5          17h    10.42.1.7    worker1       <none>           <none>
pod/mongo-5c694c878b-tgsnk      1/1     Running            0          3m3s   10.42.1.8    worker1       <none>           <none>
pod/letschat-7c66bd64f5-g7dsf   1/1     Running            2          3m3s   10.42.1.9    worker1       <none>           <none>
pod/letschat-7c66bd64f5-xmj76   0/1     ImagePullBackOff   0          3m3s   10.42.0.25   controlador   <none>           <none>
pod/letschat-7c66bd64f5-p6z55   1/1     Running            8          17h    10.42.1.4    worker1       <none>           <none>
pod/letschat-7c66bd64f5-6p76p   1/1     Running            5          17h    10.42.1.6    worker1       <none>           <none>
pod/letschat-7c66bd64f5-9z6fl   0/1     ErrImagePull       0          3m3s   10.42.0.24   controlador   <none>           <none>
```

Existe un parámetro llamado pod-eviction-timeout que especifica el tiempo que trascurre hasta que otro nodo/nodos recogen la carga dejada por el caido cuyo valor pode defecto es de 5 minutos.

Si comprobamos 5 minutos despues de la caida, podemos apreciar lo siguiente:
```shell
fran@debian:~/vagrant/proyectonewrelic$ kubectl get deploy,rs,po -o wide
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                 SELECTOR
deployment.apps/mongo      1/1     1            1           19h   mongo        mongo                  name=mongo
deployment.apps/letschat   6/6     6            6           19h   letschat     sdelements/lets-chat   name=letschat

NAME                                  DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES                 SELECTOR
replicaset.apps/mongo-5c694c878b      1         1         1       19h   mongo        mongo                  name=mongo,pod-template-hash=5c694c878b
replicaset.apps/letschat-7c66bd64f5   6         6         6       19h   letschat     sdelements/lets-chat   name=letschat,pod-template-hash=7c66bd64f5

NAME                            READY   STATUS    RESTARTS   AGE    IP           NODE          NOMINATED NODE   READINESS GATES
pod/mongo-5c694c878b-tgsnk      1/1     Running   0          129m   10.42.1.8    worker1       <none>           <none>
pod/letschat-7c66bd64f5-9z6fl   1/1     Running   0          129m   10.42.0.24   controlador   <none>           <none>
pod/letschat-7c66bd64f5-q8zm4   1/1     Running   0          11m    10.42.0.26   controlador   <none>           <none>
pod/letschat-7c66bd64f5-gfqr2   1/1     Running   0          11m    10.42.1.12   worker1       <none>           <none>
pod/letschat-7c66bd64f5-vzt9s   1/1     Running   0          11m    10.42.1.13   worker1       <none>           <none>
pod/letschat-7c66bd64f5-dxpdr   1/1     Running   0          11m    10.42.1.11   worker1       <none>           <none>
pod/letschat-7c66bd64f5-44lxf   1/1     Running   0          11m    10.42.1.10   worker1       <none>           <none>
```

Tanto el controlador como el worker1 se han repartido la carga, siguen siendo 6 replicas y sigue estan operativa:
![PracticaImg](images/proyecto/letschatnodo1.png "letschatnodo1.png")
![PracticaImg](images/proyecto/letschatconnect.png "letschatconnect.png")

Ya hemos dado un buen repaso al cluster ahora comenzaremos con su monitorización y mas contenido que nos puede aportar new relic.
</details>
</details>


<hr id="lista4" >
<br>
<details open>
<summary>

## 4. Monitorización de nuestra aplicación con new relic.
</summary>

New Relic utiliza New Relic One que es su plataforma de monitorizacion,logs y alertas como ya hemos explicado anteriormente, ahora daremos paso a explicar detalladamente su uso.

Antes de entrar a detallar los diferentes aspectos y funciones de monitorización que pose New relic comenzaremos con la monitorización general, en mi caso la de mi maquina debian que actualmente es la que uso para el desarrollo del proyecto.
![PracticaImg](images/proyecto/newrelicrendhost.png "newrelicrendhost.png")

Como podemos observar a simple vista nos da bastantes datos diferentes como: el uso del CPU, la memoria usada, el trafico de red, disco usado, procesos que se estran ejecutando actualmente, media de carga, entre otros muchos. Es una interfaz sencilla y bastante detallada, de facil acceso ya que solo necesitaremos acceso a internet para poder acceder a su web donde mediante una cuenta podremos hacer uso de la plataforma.

<hr id="lista41" >
<br>
<details open>
<summary>

## 4.1 Monitorización de un cluster de kubernetes

</summary>

No iremos a [+ add more data] en la esquina superior derecha y selecionaremos en Cloud and platform technologies Kubernetes
![PracticaImg](images/proyecto/newrelic45.png "newrelic45.png")

Le daremos un nombre para que new relic lo identifique, el nombre que recibe el cluster en new relic es orientativo y no modifica nada en nuestro cluster.
![PracticaImg](images/proyecto/newrelic451.png "newrelic451.png")

Podremos seleccionar contenido adicional, en mi caso deje los que se marcaban por defecto, en especial los dos ultimos marcados que me parecian mas interesantes: recopilar datos de registro y reducir la cantidad de datos ingeridos, esto hará que los datos obtenidos sean los justos y necesarios para lograr una correcta monitorización aumentando así la velocidad de refresco de los mismos.
![PracticaImg](images/proyecto/newrelic452.png "newrelic452.png")

Iremos a nuestra maquina e instalaremos el codigo que nos proporciona.
```shell
helm repo add newrelic https://helm-charts.newrelic.com && helm repo update && \
minikube kubectl create namespace kube-system ; helm upgrade --install newrelic-bundle newrelic/nri-bundle \
 --set global.licenseKey=eu01xx48059720c231a1080bc348906513e7NRAL \
 --set global.cluster=minikube \
 --namespace=kube-system \
 --set newrelic-infrastructure.privileged=true \
 --set global.lowDataMode=true \
 --set ksm.enabled=true \
 --set kubeEvents.enabled=true 
```

Nota:Si no tenemos instalado Helm sigue estas breves instrucciones.
```shell
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```
![PracticaImg](images/proyecto/newrelic453.png "newrelic453.png")

Tendremos que esperar a que new relic recopile los primeros datos necesarios para monitorizar nuestro cluster.
![PracticaImg](images/proyecto/newrelic454.png "newrelic454.png")
![PracticaImg](images/proyecto/newrelic455.png "newrelic454.png")

Una vez finalizado el proceso podremos explorar el cluster monitorizado!
![PracticaImg](images/proyecto/newrelic456.png "newrelic456.png")
Como podemos comprobar nos muestra nuestro proyecto realizado anteriormente el cual constaba de 3 maquinas (controlador y 2 workers).

Como podemos comprobar
![PracticaImg](images/proyecto/newrelic457.png "newrelic457.png")

![PracticaImg](images/proyecto/newrelic458.png "newrelic458.png")
![PracticaImg](images/proyecto/newrelic459.png "newrelic459.png")

</details>

<hr id="lista42" >
<br>
<details open>
<summary>

## 4.2 Monitorizar Conexiones HTTP(Navegador)
</summary>

Comenzaremos monitorizando del trafico de nuestro navegador

![PracticaImg](images/proyecto/newrelic41.png "newrelic41.png")
![PracticaImg](images/proyecto/newrelic411.png "newrelic411.png")

![PracticaImg](images/proyecto/newrelicnetwork2.png "newrelicnetwork2.png")


![PracticaImg](images/proyecto/newrelicnetwork3.png "newrelicnetwork3.png")
```shell
fran@debian:~$ docker run -d --name ktranslate-ipfix --restart unless-stopped --net=host \
> -v `pwd`/snmp-base.yaml:/snmp-base.yaml \
> -e NEW_RELIC_API_KEY=eu01xxecd80a49b9c4fc36c38f31aadaFFFFNRAL  \
> kentik/ktranslate:v2 \
>   -snmp /snmp-base.yaml \
>   -nr_account_id=3333111 \
>   -log_level=info \
>   -metrics=jchf \
>   -flow_only=true \
>   -nf.source=ipfix \
>   -tee_logs=true \
>   -service_name=ipfix \
>   -nr_region=EU \
>   nr1.flow
Unable to find image 'kentik/ktranslate:v2' locally
v2: Pulling from kentik/ktranslate
97518928ae5f: Pull complete 
c5ab775387cf: Pull complete 
3fb672fad4c3: Pull complete 
6e1574d9f562: Pull complete 
d84e6cfa7dfa: Pull complete 
2c08d50c8195: Pull complete 
801ef62de11b: Pull complete 
009b5c293950: Pull complete 
d7216316c0e3: Pull complete 
8d149d0516da: Pull complete 
7dc919990f13: Pull complete 
Digest: sha256:5ab5a1e2b753bad01911be240ff2df5deae2f65ec985b21b731c1885a720831e
Status: Downloaded newer image for kentik/ktranslate:v2
ec4c1cd7df1e240d62825ed0b0353046687592f3f5da9d5b23bfd8e627eadf97
```


![PracticaImg](images/proyecto/newrelicnetwork4.png "newrelicnetwork4.png")




</details>

<hr id="lista43" >
<br>
<details open>
<summary>

## 4.3 Mostrar eventos
</summary>

La API de eventos de New Relic es una forma de informar eventos personalizados a New Relic, permite enviar datos de eventos personalizados a nuestra cuenta con un comando POST. Luego, estos eventos se pueden consultar y crear gráficos mediante NRQL(Lenguaje de consulta de New Relic).
![PracticaImg](images/proyecto/newreliceventos.png "newreliceventos.png")

Eventos en New Relic:
En New Relic, los eventos tienen varios atributos (pares clave-valor) adjuntos. Los datos de los eventos se utilizan en algunos gráficos y tablas de la interfaz de usuario, y también podemos consultarlos. El tiempo que permanecen disponibles los datos de eventos está determinado por las reglas de retención de datos(Que podemos modficar).
![PracticaImg](images/proyecto/newreliceventos2.png "newreliceventos2.png")

Existen bastantes eventos de manera prederterminada, que se dividen dependiendo los productos que tenemos configurados en new relic(Listado de tipos de eventos)[https://docs.newrelic.com/docs/data-apis/understand-data/event-data/default-events-reported-new-relic-products/].

</details>

<hr id="lista44" >
<br>
<details open>
<summary>

## 4.4 Gestión de Logs
</summary>

New relic gestiona los registros de manera rapida y sencilla, podemos buscar instántaneamente los registro, visualizarlos directamente desde la IU de registros, ademas podemos crear graficos y alertas(Que las veremos en el siguiente punto 4.5).
![PracticaImg](images/proyecto/newreliclogs.png "newreliclogs.png")

Podremos buscar atraves de una interfaz sencilla el registro que necesitemos, también podemos desglosar el log y buscar datos similares como podemos apreciar en la siguiente imagen en la que para el mismo registro tenemos varias ips diferentes:
![PracticaImg](images/proyecto/newreliclogs2.png "newreliclogs2.png")
![PracticaImg](images/proyecto/newreliclogs3.png "newreliclogs3.png")

Además podremos ver de forma detalla el log segmentado.
![PracticaImg](images/proyecto/newreliclogs4.png "newreliclogs4.png")

</details>

<hr id="lista45" >
<br>
<details open>
<summary>

## 4.5 Fijar alertas
</summary>

La alertas nos permiten configurar políticas de manera sólida y personalizada para cualquier cosa que pueda monitorizarse, New relic cuenta con alertas predeterminadas para(hosts,cluster de kubernetes,bdd,etc...) y tambien la creación de nuevas alertas para las todos los objetos monitorizados.
![PracticaImg](images/proyecto/newrelicalertasyai.png "foto del panel de control de las alertas")

Las alertas se dividen dependiendo del objeto que monitorizen, **golden signals** son las que se utilizan de manera general pero tambien podemos contar con alertas relacionadas en este caso a kubernete la cual cuenta con un interfaz aparte y tambien vienen recogidas en otra sección.

- Alertas relacionadas con el cluster de kubernetes que tenemos creado:
![PracticaImg](images/proyecto/newrelicalerts.png "newrelicalerts.png")
![PracticaImg](images/proyecto/newrelicalert3.png "newrelicalert3.png")
![PracticaImg](images/proyecto/newrelicalert4.png "newrelicalert4.png")

- Alertas globales o **golden signals**:
![PracticaImg](images/proyecto/newrelicalertlogs2.png "newrelicalertlogs2.png")

También podemos crear nosotros mismo alertas en función de nuestras necesidades. Podemos crear alertas de dos maneras diferentes, mediante codigo:
![PracticaImg](images/proyecto/newrelicalertlogs.png "newrelicalertlogs.png")

O atraves de su plataforma, la cual cuenta con bastantes opciones y ademas podremos hacer una mezcla entra ambas y generar una alerta que luego podamos modificar atraves de su codigo.
![PracticaImg](images/proyecto/newrelicalert2.png "newrelicalert2.png")

Podremos configurar tambien que nos mande avisos de algunas de las alertas mas importantes de manera predeterminada:
![PracticaImg](images/proyecto/newrelicalert5.png "newrelicalert5.png")

Por otra parte si se cumple alguna de las alertas creadas nos mandará un aviso a nuestro correo(se pueden poner mas de uno). En mi caso cree una simple para que me avisara cuando en el log apareciese la palabra "OpenVPN", cuando encendí mi ordenador en casa y volvio a conectarse genero un log que este hizo que la alerta fuese enviada.
![PracticaImg](images/proyecto/newreliccorreo.png "newreliccorreo.png")
![PracticaImg](images/proyecto/newreliccorreo2.png "newreliccorreo2.png")

Si entramos en los detalles de la alerta nos viene de manera gáfica cuando se genero:
![PracticaImg](images/proyecto/newreliccorreo3.png "newreliccorreo3.png")

</details>

<hr id="lista46" >
<br>
<details open>
<summary>

## 4.6 Estadísticas de rendimiento
</summary>



</details>

<hr id="lista47" >
<br>
<details open>
<summary>

## 4.7 Creación y gestión de nuevas Dashboard
</summary>

![PracticaImg](images/proyecto/newreliccreardashboard.png "newreliccreardashboard.png")


</details>

</details>

<script type="text/javascript">
;window.NREUM||(NREUM={});NREUM.init={distributed_tracing:{enabled:true},privacy:{cookies_enabled:true},ajax:{deny_list:["bam.eu01.nr-data.net"]}};
window.NREUM||(NREUM={}),__nr_require=function(t,e,n){function r(n){if(!e[n]){var o=e[n]={exports:{}};t[n][0].call(o.exports,function(e){var o=t[n][1][e];return r(o||e)},o,o.exports)}return e[n].exports}if("function"==typeof __nr_require)return __nr_require;for(var o=0;o<n.length;o++)r(n[o]);return r}({1:[function(t,e,n){function r(t){try{s.console&&console.log(t)}catch(e){}}var o,i=t("ee"),a=t(32),s={};try{o=localStorage.getItem("__nr_flags").split(","),console&&"function"==typeof console.log&&(s.console=!0,o.indexOf("dev")!==-1&&(s.dev=!0),o.indexOf("nr_dev")!==-1&&(s.nrDev=!0))}catch(c){}s.nrDev&&i.on("internal-error",function(t){r(t.stack)}),s.dev&&i.on("fn-err",function(t,e,n){r(n.stack)}),s.dev&&(r("NR AGENT IN DEVELOPMENT MODE"),r("flags: "+a(s,function(t,e){return t}).join(", ")))},{}],2:[function(t,e,n){function r(t,e,n,r,s){try{l?l-=1:o(s||new UncaughtException(t,e,n),!0)}catch(f){try{i("ierr",[f,c.now(),!0])}catch(d){}}return"function"==typeof u&&u.apply(this,a(arguments))}function UncaughtException(t,e,n){this.message=t||"Uncaught error with no additional information",this.sourceURL=e,this.line=n}function o(t,e){var n=e?null:c.now();i("err",[t,n])}var i=t("handle"),a=t(33),s=t("ee"),c=t("loader"),f=t("gos"),u=window.onerror,d=!1,p="nr@seenError";if(!c.disabled){var l=0;c.features.err=!0,t(1),window.onerror=r;try{throw new Error}catch(h){"stack"in h&&(t(14),t(13),"addEventListener"in window&&t(7),c.xhrWrappable&&t(15),d=!0)}s.on("fn-start",function(t,e,n){d&&(l+=1)}),s.on("fn-err",function(t,e,n){d&&!n[p]&&(f(n,p,function(){return!0}),this.thrown=!0,o(n))}),s.on("fn-end",function(){d&&!this.thrown&&l>0&&(l-=1)}),s.on("internal-error",function(t){i("ierr",[t,c.now(),!0])})}},{}],3:[function(t,e,n){var r=t("loader");r.disabled||(r.features.ins=!0)},{}],4:[function(t,e,n){function r(){U++,L=g.hash,this[u]=y.now()}function o(){U--,g.hash!==L&&i(0,!0);var t=y.now();this[h]=~~this[h]+t-this[u],this[d]=t}function i(t,e){E.emit("newURL",[""+g,e])}function a(t,e){t.on(e,function(){this[e]=y.now()})}var s="-start",c="-end",f="-body",u="fn"+s,d="fn"+c,p="cb"+s,l="cb"+c,h="jsTime",m="fetch",v="addEventListener",w=window,g=w.location,y=t("loader");if(w[v]&&y.xhrWrappable&&!y.disabled){var x=t(11),b=t(12),E=t(9),R=t(7),O=t(14),T=t(8),P=t(15),S=t(10),M=t("ee"),N=M.get("tracer"),C=t(23);t(17),y.features.spa=!0;var L,U=0;M.on(u,r),b.on(p,r),S.on(p,r),M.on(d,o),b.on(l,o),S.on(l,o),M.buffer([u,d,"xhr-resolved"]),R.buffer([u]),O.buffer(["setTimeout"+c,"clearTimeout"+s,u]),P.buffer([u,"new-xhr","send-xhr"+s]),T.buffer([m+s,m+"-done",m+f+s,m+f+c]),E.buffer(["newURL"]),x.buffer([u]),b.buffer(["propagate",p,l,"executor-err","resolve"+s]),N.buffer([u,"no-"+u]),S.buffer(["new-jsonp","cb-start","jsonp-error","jsonp-end"]),a(T,m+s),a(T,m+"-done"),a(S,"new-jsonp"),a(S,"jsonp-end"),a(S,"cb-start"),E.on("pushState-end",i),E.on("replaceState-end",i),w[v]("hashchange",i,C(!0)),w[v]("load",i,C(!0)),w[v]("popstate",function(){i(0,U>1)},C(!0))}},{}],5:[function(t,e,n){function r(){var t=new PerformanceObserver(function(t,e){var n=t.getEntries();s(v,[n])});try{t.observe({entryTypes:["resource"]})}catch(e){}}function o(t){if(s(v,[window.performance.getEntriesByType(w)]),window.performance["c"+p])try{window.performance[h](m,o,!1)}catch(t){}else try{window.performance[h]("webkit"+m,o,!1)}catch(t){}}function i(t){}if(window.performance&&window.performance.timing&&window.performance.getEntriesByType){var a=t("ee"),s=t("handle"),c=t(14),f=t(13),u=t(6),d=t(23),p="learResourceTimings",l="addEventListener",h="removeEventListener",m="resourcetimingbufferfull",v="bstResource",w="resource",g="-start",y="-end",x="fn"+g,b="fn"+y,E="bstTimer",R="pushState",O=t("loader");if(!O.disabled){O.features.stn=!0,t(9),"addEventListener"in window&&t(7);var T=NREUM.o.EV;a.on(x,function(t,e){var n=t[0];n instanceof T&&(this.bstStart=O.now())}),a.on(b,function(t,e){var n=t[0];n instanceof T&&s("bst",[n,e,this.bstStart,O.now()])}),c.on(x,function(t,e,n){this.bstStart=O.now(),this.bstType=n}),c.on(b,function(t,e){s(E,[e,this.bstStart,O.now(),this.bstType])}),f.on(x,function(){this.bstStart=O.now()}),f.on(b,function(t,e){s(E,[e,this.bstStart,O.now(),"requestAnimationFrame"])}),a.on(R+g,function(t){this.time=O.now(),this.startPath=location.pathname+location.hash}),a.on(R+y,function(t){s("bstHist",[location.pathname+location.hash,this.startPath,this.time])}),u()?(s(v,[window.performance.getEntriesByType("resource")]),r()):l in window.performance&&(window.performance["c"+p]?window.performance[l](m,o,d(!1)):window.performance[l]("webkit"+m,o,d(!1))),document[l]("scroll",i,d(!1)),document[l]("keypress",i,d(!1)),document[l]("click",i,d(!1))}}},{}],6:[function(t,e,n){e.exports=function(){return"PerformanceObserver"in window&&"function"==typeof window.PerformanceObserver}},{}],7:[function(t,e,n){function r(t){for(var e=t;e&&!e.hasOwnProperty(u);)e=Object.getPrototypeOf(e);e&&o(e)}function o(t){s.inPlace(t,[u,d],"-",i)}function i(t,e){return t[1]}var a=t("ee").get("events"),s=t("wrap-function")(a,!0),c=t("gos"),f=XMLHttpRequest,u="addEventListener",d="removeEventListener";e.exports=a,"getPrototypeOf"in Object?(r(document),r(window),r(f.prototype)):f.prototype.hasOwnProperty(u)&&(o(window),o(f.prototype)),a.on(u+"-start",function(t,e){var n=t[1];if(null!==n&&("function"==typeof n||"object"==typeof n)){var r=c(n,"nr@wrapped",function(){function t(){if("function"==typeof n.handleEvent)return n.handleEvent.apply(n,arguments)}var e={object:t,"function":n}[typeof n];return e?s(e,"fn-",null,e.name||"anonymous"):n});this.wrapped=t[1]=r}}),a.on(d+"-start",function(t){t[1]=this.wrapped||t[1]})},{}],8:[function(t,e,n){function r(t,e,n){var r=t[e];"function"==typeof r&&(t[e]=function(){var t=i(arguments),e={};o.emit(n+"before-start",[t],e);var a;e[m]&&e[m].dt&&(a=e[m].dt);var s=r.apply(this,t);return o.emit(n+"start",[t,a],s),s.then(function(t){return o.emit(n+"end",[null,t],s),t},function(t){throw o.emit(n+"end",[t],s),t})})}var o=t("ee").get("fetch"),i=t(33),a=t(32);e.exports=o;var s=window,c="fetch-",f=c+"body-",u=["arrayBuffer","blob","json","text","formData"],d=s.Request,p=s.Response,l=s.fetch,h="prototype",m="nr@context";d&&p&&l&&(a(u,function(t,e){r(d[h],e,f),r(p[h],e,f)}),r(s,"fetch",c),o.on(c+"end",function(t,e){var n=this;if(e){var r=e.headers.get("content-length");null!==r&&(n.rxSize=r),o.emit(c+"done",[null,e],n)}else o.emit(c+"done",[t],n)}))},{}],9:[function(t,e,n){var r=t("ee").get("history"),o=t("wrap-function")(r);e.exports=r;var i=window.history&&window.history.constructor&&window.history.constructor.prototype,a=window.history;i&&i.pushState&&i.replaceState&&(a=i),o.inPlace(a,["pushState","replaceState"],"-")},{}],10:[function(t,e,n){function r(t){function e(){f.emit("jsonp-end",[],l),t.removeEventListener("load",e,c(!1)),t.removeEventListener("error",n,c(!1))}function n(){f.emit("jsonp-error",[],l),f.emit("jsonp-end",[],l),t.removeEventListener("load",e,c(!1)),t.removeEventListener("error",n,c(!1))}var r=t&&"string"==typeof t.nodeName&&"script"===t.nodeName.toLowerCase();if(r){var o="function"==typeof t.addEventListener;if(o){var a=i(t.src);if(a){var d=s(a),p="function"==typeof d.parent[d.key];if(p){var l={};u.inPlace(d.parent,[d.key],"cb-",l),t.addEventListener("load",e,c(!1)),t.addEventListener("error",n,c(!1)),f.emit("new-jsonp",[t.src],l)}}}}}function o(){return"addEventListener"in window}function i(t){var e=t.match(d);return e?e[1]:null}function a(t,e){var n=t.match(l),r=n[1],o=n[3];return o?a(o,e[r]):e[r]}function s(t){var e=t.match(p);return e&&e.length>=3?{key:e[2],parent:a(e[1],window)}:{key:t,parent:window}}var c=t(23),f=t("ee").get("jsonp"),u=t("wrap-function")(f);if(e.exports=f,o()){var d=/[?&](?:callback|cb)=([^&#]+)/,p=/(.*)\.([^.]+)/,l=/^(\w+)(\.|$)(.*)$/,h=["appendChild","insertBefore","replaceChild"];Node&&Node.prototype&&Node.prototype.appendChild?u.inPlace(Node.prototype,h,"dom-"):(u.inPlace(HTMLElement.prototype,h,"dom-"),u.inPlace(HTMLHeadElement.prototype,h,"dom-"),u.inPlace(HTMLBodyElement.prototype,h,"dom-")),f.on("dom-start",function(t){r(t[0])})}},{}],11:[function(t,e,n){var r=t("ee").get("mutation"),o=t("wrap-function")(r),i=NREUM.o.MO;e.exports=r,i&&(window.MutationObserver=function(t){return this instanceof i?new i(o(t,"fn-")):i.apply(this,arguments)},MutationObserver.prototype=i.prototype)},{}],12:[function(t,e,n){function r(t){var e=i.context(),n=s(t,"executor-",e,null,!1),r=new f(n);return i.context(r).getCtx=function(){return e},r}var o=t("wrap-function"),i=t("ee").get("promise"),a=t("ee").getOrSetContext,s=o(i),c=t(32),f=NREUM.o.PR;e.exports=i,f&&(window.Promise=r,["all","race"].forEach(function(t){var e=f[t];f[t]=function(n){function r(t){return function(){i.emit("propagate",[null,!o],a,!1,!1),o=o||!t}}var o=!1;c(n,function(e,n){Promise.resolve(n).then(r("all"===t),r(!1))});var a=e.apply(f,arguments),s=f.resolve(a);return s}}),["resolve","reject"].forEach(function(t){var e=f[t];f[t]=function(t){var n=e.apply(f,arguments);return t!==n&&i.emit("propagate",[t,!0],n,!1,!1),n}}),f.prototype["catch"]=function(t){return this.then(null,t)},f.prototype=Object.create(f.prototype,{constructor:{value:r}}),c(Object.getOwnPropertyNames(f),function(t,e){try{r[e]=f[e]}catch(n){}}),o.wrapInPlace(f.prototype,"then",function(t){return function(){var e=this,n=o.argsToArray.apply(this,arguments),r=a(e);r.promise=e,n[0]=s(n[0],"cb-",r,null,!1),n[1]=s(n[1],"cb-",r,null,!1);var c=t.apply(this,n);return r.nextPromise=c,i.emit("propagate",[e,!0],c,!1,!1),c}}),i.on("executor-start",function(t){t[0]=s(t[0],"resolve-",this,null,!1),t[1]=s(t[1],"resolve-",this,null,!1)}),i.on("executor-err",function(t,e,n){t[1](n)}),i.on("cb-end",function(t,e,n){i.emit("propagate",[n,!0],this.nextPromise,!1,!1)}),i.on("propagate",function(t,e,n){this.getCtx&&!e||(this.getCtx=function(){if(t instanceof Promise)var e=i.context(t);return e&&e.getCtx?e.getCtx():this})}),r.toString=function(){return""+f})},{}],13:[function(t,e,n){var r=t("ee").get("raf"),o=t("wrap-function")(r),i="equestAnimationFrame";e.exports=r,o.inPlace(window,["r"+i,"mozR"+i,"webkitR"+i,"msR"+i],"raf-"),r.on("raf-start",function(t){t[0]=o(t[0],"fn-")})},{}],14:[function(t,e,n){function r(t,e,n){t[0]=a(t[0],"fn-",null,n)}function o(t,e,n){this.method=n,this.timerDuration=isNaN(t[1])?0:+t[1],t[0]=a(t[0],"fn-",this,n)}var i=t("ee").get("timer"),a=t("wrap-function")(i),s="setTimeout",c="setInterval",f="clearTimeout",u="-start",d="-";e.exports=i,a.inPlace(window,[s,"setImmediate"],s+d),a.inPlace(window,[c],c+d),a.inPlace(window,[f,"clearImmediate"],f+d),i.on(c+u,r),i.on(s+u,o)},{}],15:[function(t,e,n){function r(t,e){d.inPlace(e,["onreadystatechange"],"fn-",s)}function o(){var t=this,e=u.context(t);t.readyState>3&&!e.resolved&&(e.resolved=!0,u.emit("xhr-resolved",[],t)),d.inPlace(t,y,"fn-",s)}function i(t){x.push(t),m&&(E?E.then(a):w?w(a):(R=-R,O.data=R))}function a(){for(var t=0;t<x.length;t++)r([],x[t]);x.length&&(x=[])}function s(t,e){return e}function c(t,e){for(var n in t)e[n]=t[n];return e}t(7);var f=t("ee"),u=f.get("xhr"),d=t("wrap-function")(u),p=t(23),l=NREUM.o,h=l.XHR,m=l.MO,v=l.PR,w=l.SI,g="readystatechange",y=["onload","onerror","onabort","onloadstart","onloadend","onprogress","ontimeout"],x=[];e.exports=u;var b=window.XMLHttpRequest=function(t){var e=new h(t);try{u.emit("new-xhr",[e],e),e.addEventListener(g,o,p(!1))}catch(n){try{u.emit("internal-error",[n])}catch(r){}}return e};if(c(h,b),b.prototype=h.prototype,d.inPlace(b.prototype,["open","send"],"-xhr-",s),u.on("send-xhr-start",function(t,e){r(t,e),i(e)}),u.on("open-xhr-start",r),m){var E=v&&v.resolve();if(!w&&!v){var R=1,O=document.createTextNode(R);new m(a).observe(O,{characterData:!0})}}else f.on("fn-end",function(t){t[0]&&t[0].type===g||a()})},{}],16:[function(t,e,n){function r(t){if(!s(t))return null;var e=window.NREUM;if(!e.loader_config)return null;var n=(e.loader_config.accountID||"").toString()||null,r=(e.loader_config.agentID||"").toString()||null,f=(e.loader_config.trustKey||"").toString()||null;if(!n||!r)return null;var h=l.generateSpanId(),m=l.generateTraceId(),v=Date.now(),w={spanId:h,traceId:m,timestamp:v};return(t.sameOrigin||c(t)&&p())&&(w.traceContextParentHeader=o(h,m),w.traceContextStateHeader=i(h,v,n,r,f)),(t.sameOrigin&&!u()||!t.sameOrigin&&c(t)&&d())&&(w.newrelicHeader=a(h,m,v,n,r,f)),w}function o(t,e){return"00-"+e+"-"+t+"-01"}function i(t,e,n,r,o){var i=0,a="",s=1,c="",f="";return o+"@nr="+i+"-"+s+"-"+n+"-"+r+"-"+t+"-"+a+"-"+c+"-"+f+"-"+e}function a(t,e,n,r,o,i){var a="btoa"in window&&"function"==typeof window.btoa;if(!a)return null;var s={v:[0,1],d:{ty:"Browser",ac:r,ap:o,id:t,tr:e,ti:n}};return i&&r!==i&&(s.d.tk=i),btoa(JSON.stringify(s))}function s(t){return f()&&c(t)}function c(t){var e=!1,n={};if("init"in NREUM&&"distributed_tracing"in NREUM.init&&(n=NREUM.init.distributed_tracing),t.sameOrigin)e=!0;else if(n.allowed_origins instanceof Array)for(var r=0;r<n.allowed_origins.length;r++){var o=h(n.allowed_origins[r]);if(t.hostname===o.hostname&&t.protocol===o.protocol&&t.port===o.port){e=!0;break}}return e}function f(){return"init"in NREUM&&"distributed_tracing"in NREUM.init&&!!NREUM.init.distributed_tracing.enabled}function u(){return"init"in NREUM&&"distributed_tracing"in NREUM.init&&!!NREUM.init.distributed_tracing.exclude_newrelic_header}function d(){return"init"in NREUM&&"distributed_tracing"in NREUM.init&&NREUM.init.distributed_tracing.cors_use_newrelic_header!==!1}function p(){return"init"in NREUM&&"distributed_tracing"in NREUM.init&&!!NREUM.init.distributed_tracing.cors_use_tracecontext_headers}var l=t(29),h=t(18);e.exports={generateTracePayload:r,shouldGenerateTrace:s}},{}],17:[function(t,e,n){function r(t){var e=this.params,n=this.metrics;if(!this.ended){this.ended=!0;for(var r=0;r<p;r++)t.removeEventListener(d[r],this.listener,!1);e.aborted||(n.duration=a.now()-this.startTime,this.loadCaptureCalled||4!==t.readyState?null==e.status&&(e.status=0):i(this,t),n.cbTime=this.cbTime,s("xhr",[e,n,this.startTime,this.endTime,"xhr"],this))}}function o(t,e){var n=c(e),r=t.params;r.hostname=n.hostname,r.port=n.port,r.protocol=n.protocol,r.host=n.hostname+":"+n.port,r.pathname=n.pathname,t.parsedOrigin=n,t.sameOrigin=n.sameOrigin}function i(t,e){t.params.status=e.status;var n=v(e,t.lastSize);if(n&&(t.metrics.rxSize=n),t.sameOrigin){var r=e.getResponseHeader("X-NewRelic-App-Data");r&&(t.params.cat=r.split(", ").pop())}t.loadCaptureCalled=!0}var a=t("loader");if(a.xhrWrappable&&!a.disabled){var s=t("handle"),c=t(18),f=t(16).generateTracePayload,u=t("ee"),d=["load","error","abort","timeout"],p=d.length,l=t("id"),h=t(24),m=t(22),v=t(19),w=t(23),g=NREUM.o.REQ,y=window.XMLHttpRequest;a.features.xhr=!0,t(15),t(8),u.on("new-xhr",function(t){var e=this;e.totalCbs=0,e.called=0,e.cbTime=0,e.end=r,e.ended=!1,e.xhrGuids={},e.lastSize=null,e.loadCaptureCalled=!1,e.params=this.params||{},e.metrics=this.metrics||{},t.addEventListener("load",function(n){i(e,t)},w(!1)),h&&(h>34||h<10)||t.addEventListener("progress",function(t){e.lastSize=t.loaded},w(!1))}),u.on("open-xhr-start",function(t){this.params={method:t[0]},o(this,t[1]),this.metrics={}}),u.on("open-xhr-end",function(t,e){"loader_config"in NREUM&&"xpid"in NREUM.loader_config&&this.sameOrigin&&e.setRequestHeader("X-NewRelic-ID",NREUM.loader_config.xpid);var n=f(this.parsedOrigin);if(n){var r=!1;n.newrelicHeader&&(e.setRequestHeader("newrelic",n.newrelicHeader),r=!0),n.traceContextParentHeader&&(e.setRequestHeader("traceparent",n.traceContextParentHeader),n.traceContextStateHeader&&e.setRequestHeader("tracestate",n.traceContextStateHeader),r=!0),r&&(this.dt=n)}}),u.on("send-xhr-start",function(t,e){var n=this.metrics,r=t[0],o=this;if(n&&r){var i=m(r);i&&(n.txSize=i)}this.startTime=a.now(),this.listener=function(t){try{"abort"!==t.type||o.loadCaptureCalled||(o.params.aborted=!0),("load"!==t.type||o.called===o.totalCbs&&(o.onloadCalled||"function"!=typeof e.onload))&&o.end(e)}catch(n){try{u.emit("internal-error",[n])}catch(r){}}};for(var s=0;s<p;s++)e.addEventListener(d[s],this.listener,w(!1))}),u.on("xhr-cb-time",function(t,e,n){this.cbTime+=t,e?this.onloadCalled=!0:this.called+=1,this.called!==this.totalCbs||!this.onloadCalled&&"function"==typeof n.onload||this.end(n)}),u.on("xhr-load-added",function(t,e){var n=""+l(t)+!!e;this.xhrGuids&&!this.xhrGuids[n]&&(this.xhrGuids[n]=!0,this.totalCbs+=1)}),u.on("xhr-load-removed",function(t,e){var n=""+l(t)+!!e;this.xhrGuids&&this.xhrGuids[n]&&(delete this.xhrGuids[n],this.totalCbs-=1)}),u.on("xhr-resolved",function(){this.endTime=a.now()}),u.on("addEventListener-end",function(t,e){e instanceof y&&"load"===t[0]&&u.emit("xhr-load-added",[t[1],t[2]],e)}),u.on("removeEventListener-end",function(t,e){e instanceof y&&"load"===t[0]&&u.emit("xhr-load-removed",[t[1],t[2]],e)}),u.on("fn-start",function(t,e,n){e instanceof y&&("onload"===n&&(this.onload=!0),("load"===(t[0]&&t[0].type)||this.onload)&&(this.xhrCbStart=a.now()))}),u.on("fn-end",function(t,e){this.xhrCbStart&&u.emit("xhr-cb-time",[a.now()-this.xhrCbStart,this.onload,e],e)}),u.on("fetch-before-start",function(t){function e(t,e){var n=!1;return e.newrelicHeader&&(t.set("newrelic",e.newrelicHeader),n=!0),e.traceContextParentHeader&&(t.set("traceparent",e.traceContextParentHeader),e.traceContextStateHeader&&t.set("tracestate",e.traceContextStateHeader),n=!0),n}var n,r=t[1]||{};"string"==typeof t[0]?n=t[0]:t[0]&&t[0].url?n=t[0].url:window.URL&&t[0]&&t[0]instanceof URL&&(n=t[0].href),n&&(this.parsedOrigin=c(n),this.sameOrigin=this.parsedOrigin.sameOrigin);var o=f(this.parsedOrigin);if(o&&(o.newrelicHeader||o.traceContextParentHeader))if("string"==typeof t[0]||window.URL&&t[0]&&t[0]instanceof URL){var i={};for(var a in r)i[a]=r[a];i.headers=new Headers(r.headers||{}),e(i.headers,o)&&(this.dt=o),t.length>1?t[1]=i:t.push(i)}else t[0]&&t[0].headers&&e(t[0].headers,o)&&(this.dt=o)}),u.on("fetch-start",function(t,e){this.params={},this.metrics={},this.startTime=a.now(),this.dt=e,t.length>=1&&(this.target=t[0]),t.length>=2&&(this.opts=t[1]);var n,r=this.opts||{},i=this.target;"string"==typeof i?n=i:"object"==typeof i&&i instanceof g?n=i.url:window.URL&&"object"==typeof i&&i instanceof URL&&(n=i.href),o(this,n);var s=(""+(i&&i instanceof g&&i.method||r.method||"GET")).toUpperCase();this.params.method=s,this.txSize=m(r.body)||0}),u.on("fetch-done",function(t,e){this.endTime=a.now(),this.params||(this.params={}),this.params.status=e?e.status:0;var n;"string"==typeof this.rxSize&&this.rxSize.length>0&&(n=+this.rxSize);var r={txSize:this.txSize,rxSize:n,duration:a.now()-this.startTime};s("xhr",[this.params,r,this.startTime,this.endTime,"fetch"],this)})}},{}],18:[function(t,e,n){var r={};e.exports=function(t){if(t in r)return r[t];var e=document.createElement("a"),n=window.location,o={};e.href=t,o.port=e.port;var i=e.href.split("://");!o.port&&i[1]&&(o.port=i[1].split("/")[0].split("@").pop().split(":")[1]),o.port&&"0"!==o.port||(o.port="https"===i[0]?"443":"80"),o.hostname=e.hostname||n.hostname,o.pathname=e.pathname,o.protocol=i[0],"/"!==o.pathname.charAt(0)&&(o.pathname="/"+o.pathname);var a=!e.protocol||":"===e.protocol||e.protocol===n.protocol,s=e.hostname===document.domain&&e.port===n.port;return o.sameOrigin=a&&(!e.hostname||s),"/"===o.pathname&&(r[t]=o),o}},{}],19:[function(t,e,n){function r(t,e){var n=t.responseType;return"json"===n&&null!==e?e:"arraybuffer"===n||"blob"===n||"json"===n?o(t.response):"text"===n||""===n||void 0===n?o(t.responseText):void 0}var o=t(22);e.exports=r},{}],20:[function(t,e,n){function r(){}function o(t,e,n,r){return function(){return u.recordSupportability("API/"+e+"/called"),i(t+e,[f.now()].concat(s(arguments)),n?null:this,r),n?void 0:this}}var i=t("handle"),a=t(32),s=t(33),c=t("ee").get("tracer"),f=t("loader"),u=t(25),d=NREUM;"undefined"==typeof window.newrelic&&(newrelic=d);var p=["setPageViewName","setCustomAttribute","setErrorHandler","finished","addToTrace","inlineHit","addRelease"],l="api-",h=l+"ixn-";a(p,function(t,e){d[e]=o(l,e,!0,"api")}),d.addPageAction=o(l,"addPageAction",!0),d.setCurrentRouteName=o(l,"routeName",!0),e.exports=newrelic,d.interaction=function(){return(new r).get()};var m=r.prototype={createTracer:function(t,e){var n={},r=this,o="function"==typeof e;return i(h+"tracer",[f.now(),t,n],r),function(){if(c.emit((o?"":"no-")+"fn-start",[f.now(),r,o],n),o)try{return e.apply(this,arguments)}catch(t){throw c.emit("fn-err",[arguments,this,t],n),t}finally{c.emit("fn-end",[f.now()],n)}}}};a("actionText,setName,setAttribute,save,ignore,onEnd,getContext,end,get".split(","),function(t,e){m[e]=o(h,e)}),newrelic.noticeError=function(t,e){"string"==typeof t&&(t=new Error(t)),u.recordSupportability("API/noticeError/called"),i("err",[t,f.now(),!1,e])}},{}],21:[function(t,e,n){function r(t){if(NREUM.init){for(var e=NREUM.init,n=t.split("."),r=0;r<n.length-1;r++)if(e=e[n[r]],"object"!=typeof e)return;return e=e[n[n.length-1]]}}e.exports={getConfiguration:r}},{}],22:[function(t,e,n){e.exports=function(t){if("string"==typeof t&&t.length)return t.length;if("object"==typeof t){if("undefined"!=typeof ArrayBuffer&&t instanceof ArrayBuffer&&t.byteLength)return t.byteLength;if("undefined"!=typeof Blob&&t instanceof Blob&&t.size)return t.size;if(!("undefined"!=typeof FormData&&t instanceof FormData))try{return JSON.stringify(t).length}catch(e){return}}}},{}],23:[function(t,e,n){var r=!1;try{var o=Object.defineProperty({},"passive",{get:function(){r=!0}});window.addEventListener("testPassive",null,o),window.removeEventListener("testPassive",null,o)}catch(i){}e.exports=function(t){return r?{passive:!0,capture:!!t}:!!t}},{}],24:[function(t,e,n){var r=0,o=navigator.userAgent.match(/Firefox[\/\s](\d+\.\d+)/);o&&(r=+o[1]),e.exports=r},{}],25:[function(t,e,n){function r(t,e){var n=[a,t,{name:t},e];return i("storeMetric",n,null,"api"),n}function o(t,e){var n=[s,t,{name:t},e];return i("storeEventMetrics",n,null,"api"),n}var i=t("handle"),a="sm",s="cm";e.exports={constants:{SUPPORTABILITY_METRIC:a,CUSTOM_METRIC:s},recordSupportability:r,recordCustom:o}},{}],26:[function(t,e,n){function r(){return s.exists&&performance.now?Math.round(performance.now()):(i=Math.max((new Date).getTime(),i))-a}function o(){return i}var i=(new Date).getTime(),a=i,s=t(34);e.exports=r,e.exports.offset=a,e.exports.getLastTimestamp=o},{}],27:[function(t,e,n){function r(t){return!(!t||!t.protocol||"file:"===t.protocol)}e.exports=r},{}],28:[function(t,e,n){function r(t,e){var n=t.getEntries();n.forEach(function(t){"first-paint"===t.name?p("timing",["fp",Math.floor(t.startTime)]):"first-contentful-paint"===t.name&&p("timing",["fcp",Math.floor(t.startTime)])})}function o(t,e){var n=t.getEntries();if(n.length>0){var r=n[n.length-1];if(c&&c<r.startTime)return;p("lcp",[r])}}function i(t){t.getEntries().forEach(function(t){t.hadRecentInput||p("cls",[t])})}function a(t){if(t instanceof v&&!g){var e=Math.round(t.timeStamp),n={type:t.type};e<=l.now()?n.fid=l.now()-e:e>l.offset&&e<=Date.now()?(e-=l.offset,n.fid=l.now()-e):e=l.now(),g=!0,p("timing",["fi",e,n])}}function s(t){"hidden"===t&&(c=l.now(),p("pageHide",[c]))}if(!("init"in NREUM&&"page_view_timing"in NREUM.init&&"enabled"in NREUM.init.page_view_timing&&NREUM.init.page_view_timing.enabled===!1)){var c,f,u,d,p=t("handle"),l=t("loader"),h=t(31),m=t(23),v=NREUM.o.EV;if("PerformanceObserver"in window&&"function"==typeof window.PerformanceObserver){f=new PerformanceObserver(r);try{f.observe({entryTypes:["paint"]})}catch(w){}u=new PerformanceObserver(o);try{u.observe({entryTypes:["largest-contentful-paint"]})}catch(w){}d=new PerformanceObserver(i);try{d.observe({type:"layout-shift",buffered:!0})}catch(w){}}if("addEventListener"in document){var g=!1,y=["click","keydown","mousedown","pointerdown","touchstart"];y.forEach(function(t){document.addEventListener(t,a,m(!1))})}h(s)}},{}],29:[function(t,e,n){function r(){function t(){return e?15&e[n++]:16*Math.random()|0}var e=null,n=0,r=window.crypto||window.msCrypto;r&&r.getRandomValues&&(e=r.getRandomValues(new Uint8Array(31)));for(var o,i="xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx",a="",s=0;s<i.length;s++)o=i[s],"x"===o?a+=t().toString(16):"y"===o?(o=3&t()|8,a+=o.toString(16)):a+=o;return a}function o(){return a(16)}function i(){return a(32)}function a(t){function e(){return n?15&n[r++]:16*Math.random()|0}var n=null,r=0,o=window.crypto||window.msCrypto;o&&o.getRandomValues&&Uint8Array&&(n=o.getRandomValues(new Uint8Array(31)));for(var i=[],a=0;a<t;a++)i.push(e().toString(16));return i.join("")}e.exports={generateUuid:r,generateSpanId:o,generateTraceId:i}},{}],30:[function(t,e,n){function r(t,e){if(!o)return!1;if(t!==o)return!1;if(!e)return!0;if(!i)return!1;for(var n=i.split("."),r=e.split("."),a=0;a<r.length;a++)if(r[a]!==n[a])return!1;return!0}var o=null,i=null,a=/Version\/(\S+)\s+Safari/;if(navigator.userAgent){var s=navigator.userAgent,c=s.match(a);c&&s.indexOf("Chrome")===-1&&s.indexOf("Chromium")===-1&&(o="Safari",i=c[1])}e.exports={agent:o,version:i,match:r}},{}],31:[function(t,e,n){function r(t){function e(){t(s&&document[s]?document[s]:document[i]?"hidden":"visible")}"addEventListener"in document&&a&&document.addEventListener(a,e,o(!1))}var o=t(23);e.exports=r;var i,a,s;"undefined"!=typeof document.hidden?(i="hidden",a="visibilitychange",s="visibilityState"):"undefined"!=typeof document.msHidden?(i="msHidden",a="msvisibilitychange"):"undefined"!=typeof document.webkitHidden&&(i="webkitHidden",a="webkitvisibilitychange",s="webkitVisibilityState")},{}],32:[function(t,e,n){function r(t,e){var n=[],r="",i=0;for(r in t)o.call(t,r)&&(n[i]=e(r,t[r]),i+=1);return n}var o=Object.prototype.hasOwnProperty;e.exports=r},{}],33:[function(t,e,n){function r(t,e,n){e||(e=0),"undefined"==typeof n&&(n=t?t.length:0);for(var r=-1,o=n-e||0,i=Array(o<0?0:o);++r<o;)i[r]=t[e+r];return i}e.exports=r},{}],34:[function(t,e,n){e.exports={exists:"undefined"!=typeof window.performance&&window.performance.timing&&"undefined"!=typeof window.performance.timing.navigationStart}},{}],ee:[function(t,e,n){function r(){}function o(t){function e(t){return t&&t instanceof r?t:t?f(t,c,a):a()}function n(n,r,o,i,a){if(a!==!1&&(a=!0),!l.aborted||i){t&&a&&t(n,r,o);for(var s=e(o),c=m(n),f=c.length,u=0;u<f;u++)c[u].apply(s,r);var p=d[y[n]];return p&&p.push([x,n,r,s]),s}}function i(t,e){g[t]=m(t).concat(e)}function h(t,e){var n=g[t];if(n)for(var r=0;r<n.length;r++)n[r]===e&&n.splice(r,1)}function m(t){return g[t]||[]}function v(t){return p[t]=p[t]||o(n)}function w(t,e){l.aborted||u(t,function(t,n){e=e||"feature",y[n]=e,e in d||(d[e]=[])})}var g={},y={},x={on:i,addEventListener:i,removeEventListener:h,emit:n,get:v,listeners:m,context:e,buffer:w,abort:s,aborted:!1};return x}function i(t){return f(t,c,a)}function a(){return new r}function s(){(d.api||d.feature)&&(l.aborted=!0,d=l.backlog={})}var c="nr@context",f=t("gos"),u=t(32),d={},p={},l=e.exports=o();e.exports.getOrSetContext=i,l.backlog=d},{}],gos:[function(t,e,n){function r(t,e,n){if(o.call(t,e))return t[e];var r=n();if(Object.defineProperty&&Object.keys)try{return Object.defineProperty(t,e,{value:r,writable:!0,enumerable:!1}),r}catch(i){}return t[e]=r,r}var o=Object.prototype.hasOwnProperty;e.exports=r},{}],handle:[function(t,e,n){function r(t,e,n,r){o.buffer([t],r),o.emit(t,e,n)}var o=t("ee").get("handle");e.exports=r,r.ee=o},{}],id:[function(t,e,n){function r(t){var e=typeof t;return!t||"object"!==e&&"function"!==e?-1:t===window?0:a(t,i,function(){return o++})}var o=1,i="nr@id",a=t("gos");e.exports=r},{}],loader:[function(t,e,n){function r(){if(!P++){var t=T.info=NREUM.info,e=v.getElementsByTagName("script")[0];if(setTimeout(f.abort,3e4),!(t&&t.licenseKey&&t.applicationID&&e))return f.abort();c(R,function(e,n){t[e]||(t[e]=n)});var n=a();s("mark",["onload",n+T.offset],null,"api"),s("timing",["load",n]);var r=v.createElement("script");0===t.agent.indexOf("http://")||0===t.agent.indexOf("https://")?r.src=t.agent:r.src=h+"://"+t.agent,e.parentNode.insertBefore(r,e)}}function o(){"complete"===v.readyState&&i()}function i(){s("mark",["domContent",a()+T.offset],null,"api")}var a=t(26),s=t("handle"),c=t(32),f=t("ee"),u=t(30),d=t(27),p=t(21),l=t(23),h=p.getConfiguration("ssl")===!1?"http":"https",m=window,v=m.document,w="addEventListener",g="attachEvent",y=m.XMLHttpRequest,x=y&&y.prototype,b=!d(m.location);NREUM.o={ST:setTimeout,SI:m.setImmediate,CT:clearTimeout,XHR:y,REQ:m.Request,EV:m.Event,PR:m.Promise,MO:m.MutationObserver};var E=""+location,R={beacon:"bam.nr-data.net",errorBeacon:"bam.nr-data.net",agent:"js-agent.newrelic.com/nr-spa-1212.min.js"},O=y&&x&&x[w]&&!/CriOS/.test(navigator.userAgent),T=e.exports={offset:a.getLastTimestamp(),now:a,origin:E,features:{},xhrWrappable:O,userAgent:u,disabled:b};if(!b){t(20),t(28),v[w]?(v[w]("DOMContentLoaded",i,l(!1)),m[w]("load",r,l(!1))):(v[g]("onreadystatechange",o),m[g]("onload",r)),s("mark",["firstbyte",a.getLastTimestamp()],null,"api");var P=0}},{}],"wrap-function":[function(t,e,n){function r(t,e){function n(e,n,r,c,f){function nrWrapper(){var i,a,u,p;try{a=this,i=d(arguments),u="function"==typeof r?r(i,a):r||{}}catch(l){o([l,"",[i,a,c],u],t)}s(n+"start",[i,a,c],u,f);try{return p=e.apply(a,i)}catch(h){throw s(n+"err",[i,a,h],u,f),h}finally{s(n+"end",[i,a,p],u,f)}}return a(e)?e:(n||(n=""),nrWrapper[p]=e,i(e,nrWrapper,t),nrWrapper)}function r(t,e,r,o,i){r||(r="");var s,c,f,u="-"===r.charAt(0);for(f=0;f<e.length;f++)c=e[f],s=t[c],a(s)||(t[c]=n(s,u?c+r:r,o,c,i))}function s(n,r,i,a){if(!h||e){var s=h;h=!0;try{t.emit(n,r,i,e,a)}catch(c){o([c,n,r,i],t)}h=s}}return t||(t=u),n.inPlace=r,n.flag=p,n}function o(t,e){e||(e=u);try{e.emit("internal-error",t)}catch(n){}}function i(t,e,n){if(Object.defineProperty&&Object.keys)try{var r=Object.keys(t);return r.forEach(function(n){Object.defineProperty(e,n,{get:function(){return t[n]},set:function(e){return t[n]=e,e}})}),e}catch(i){o([i],n)}for(var a in t)l.call(t,a)&&(e[a]=t[a]);return e}function a(t){return!(t&&t instanceof Function&&t.apply&&!t[p])}function s(t,e){var n=e(t);return n[p]=t,i(t,n,u),n}function c(t,e,n){var r=t[e];t[e]=s(r,n)}function f(){for(var t=arguments.length,e=new Array(t),n=0;n<t;++n)e[n]=arguments[n];return e}var u=t("ee"),d=t(33),p="nr@original",l=Object.prototype.hasOwnProperty,h=!1;e.exports=r,e.exports.wrapFunction=s,e.exports.wrapInPlace=c,e.exports.argsToArray=f},{}]},{},["loader",2,17,5,3,4]);
;NREUM.loader_config={accountID:"3333111",trustKey:"3333111",agentID:"322545816",licenseKey:"NRJS-3964827d17422b7affe",applicationID:"322545816"}
;NREUM.info={beacon:"bam.eu01.nr-data.net",errorBeacon:"bam.eu01.nr-data.net",licenseKey:"NRJS-3964827d17422b7affe",applicationID:"322545816",sa:1}
</script>
