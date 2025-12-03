const nodemailer = require('nodemailer');
const { config } = require('../config');
const { logger } = require('./logger');

let transporter;

if (config.mail.host) {
  transporter = nodemailer.createTransport({
    host: config.mail.host,
    port: config.mail.port,
    secure: config.mail.secure,
    auth: config.mail.user && config.mail.pass ? {
      user: config.mail.user,
      pass: config.mail.pass
    } : undefined
  });

  transporter.verify().then(() => {
    logger.info('SMTP transporter listo');
  }).catch((error) => {
    logger.warn('No se pudo verificar el transporte SMTP: %s', error.message);
  });
} else {
  logger.warn('SMTP no configurado; se omitirán envíos de correo.');
}

const sendPasswordResetCode = async ({ to, code, name }) => {
  const subject = 'Código de verificación N-Ki';
  const html = `
    <p>Hola ${name ?? ''},</p>
    <p>Recibimos una solicitud para restablecer tu contraseña en N-Ki.</p>
    <p>Utiliza el siguiente código para continuar:</p>
    <p style="font-size:24px;font-weight:bold;letter-spacing:4px;">${code}</p>
    <p>El código expira en 10 minutos. Si no solicitaste este correo, ignóralo.</p>
    <p>— Equipo N-Ki</p>
  `;

  if (!transporter) {
    logger.warn('Correo no enviado: SMTP no configurado.');
    return;
  }

  await transporter.sendMail({
    from: config.mail.from,
    to,
    subject,
    html
  });
};

const sendPasswordResetLink = async ({ to, link, name }) => {
  const subject = 'Restablece tu contraseña en N-Ki';
  const html = `
    <p>Hola ${name ?? ''},</p>
    <p>Haz clic en el siguiente enlace para restablecer tu contraseña:</p>
    <p><a href="${link}" target="_blank" rel="noopener">Restablecer contraseña</a></p>
    <p>El enlace expira en 10 minutos.</p>
    <p>— Equipo N-Ki</p>
  `;

  if (!transporter) {
    logger.warn('Correo no enviado: SMTP no configurado.');
    return;
  }

  await transporter.sendMail({
    from: config.mail.from,
    to,
    subject,
    html
  });
};

module.exports = {
  sendPasswordResetCode,
  sendPasswordResetLink
};
