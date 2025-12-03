const validate = (schema) => (req, res, next) => {
  const data = {
    body: req.body,
    params: req.params,
    query: req.query
  };

  try {
    schema.parse(data);
    next();
  } catch (error) {
    const details = error.errors?.map((e) => ({ path: e.path, message: e.message }));
    next(Object.assign(new Error('Datos de entrada inválidos'), { status: 422, details }));
  }
};

module.exports = { validate };
