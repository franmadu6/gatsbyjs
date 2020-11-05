import React from 'react'
import Helmet from 'react-helmet'
import Layout from '../layout'
import config from '../../data/SiteConfig'

const ContactPage = () => (
  <Layout>
    <main>
      <Helmet title={`Contact | ${config.siteTitle}`} />
      <h1>Contacta conmigo</h1>
      <p>Correo: <mail>frandh1997@gmail.com</mail></p>
    </main>
  </Layout>
)
export default ContactPage
