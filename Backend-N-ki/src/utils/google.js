const { OAuth2Client } = require('google-auth-library');
const { config } = require('../config');

const client = new OAuth2Client({
  clientId: config.google.clientId,
  clientSecret: config.google.clientSecret,
  redirectUri: config.google.redirectUri
});

const verifyGoogleIdToken = async (idToken) => {
  const ticket = await client.verifyIdToken({
    idToken,
    audience: config.google.clientId
  });
  const payload = ticket.getPayload();
  if (!payload) {
    throw new Error('Google token payload missing');
  }
  return {
    googleId: payload.sub,
    email: payload.email,
    emailVerified: payload.email_verified,
    givenName: payload.given_name,
    familyName: payload.family_name,
    picture: payload.picture
  };
};

module.exports = {
  verifyGoogleIdToken
};
