const resumenService = require('../services/resumen.service');

const getResumen = async (req, res) => {
  const data = await resumenService.getResumen(req.query);
  res.json({ data });
};

module.exports = {
  getResumen
};
