import React from 'react'

const About = () => (
  <>
    <h1>Sobre Mí</h1>
    <p>Estudiante de sysadmin en IES Gonzalo Nazareno (Dos Hermanas, Sevilla).</p>

    <div id="lista">
      <ul>
        <li type="disc">ABD → Administración de Sistemas Gestores de Bases de Datos </li>
        <li type="disc">ASO → Administración de Sistemas Operativos </li>
        <li type="disc">EIE → Empresa e iniciativa emprendedora (Grado superior) </li>
        <li type="disc">HLC → Cloud Computing (Hora de libre configuración)</li>
        <li type="disc">IAW → Implantación de Aplicaciones Web </li>
        <li type="disc">SAD → Seguridad y alta disponibilidad </li>
        <li type="disc">SRI → Servicios de Red e Internet </li>
     </ul>
    </div>

    <div id="trabajos">
      <div id="escultor">
        Pagina web diseñada y desarrollada para un Imaginero-Escultor de Sevilla, Alojada en Comvive.
        <p>HTML,CSS y JavaScript +Lib<br>
        </br><a href="https://www.imagineromarianosanchezdelpino.es/" target="_blank">https://www.imagineromarianosanchezdelpino.es/</a></p>
      </div>

      <div id="torneo">
        Aplicación creada para ver un Ranking a tiempo real de todas las cuentas(elo) de league of legends de un grupo de amigos.
        <p>Aplicación creada en python:<br></br>
        <a href="https://forobarcosclub.herokuapp.com/" target="_blank">https://forobarcosclub.herokuapp.com/</a></p>
        <p>https://github.com/franmadu6/forobarcosclub</p>  
      </div>
    </div>
  </>
)

export default About
