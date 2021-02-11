import React from 'react'
import Helmet from 'react-helmet'
import Layout from '../layout'
import config from '../../data/SiteConfig'

const ContactPage = () => (
  <Layout>
    <main>
      <Helmet title={`Contact | ${config.siteTitle}`} />
      <h1>Contacta conmigo</h1>
      <h3>Correo: <mail>frandh1997@gmail.com</mail></h3>
    </main>
  </Layout>
)
export default ContactPage
