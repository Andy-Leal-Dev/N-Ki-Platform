const bcrypt = require('bcryptjs');

const hashPassword = async (plain) => {
  return bcrypt.hash(plain, 12);
};

const comparePassword = async (plain, hash) => {
  return bcrypt.compare(plain, hash);
};

const hashCode = async (code) => bcrypt.hash(code, 10);
const compareCode = async (code, hash) => bcrypt.compare(code, hash);

module.exports = {
  hashPassword,
  comparePassword,
  hashCode,
  compareCode
};
