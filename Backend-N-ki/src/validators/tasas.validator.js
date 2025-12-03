const { z } = require('zod');

const tasaBody = z.object({
  fecha: z.string().min(10),
  tasaDiaria: z.number({ coerce: true }).positive()
});

const createTasaSchema = z.object({
  body: tasaBody
});

const updateTasaSchema = z.object({
  params: z.object({ id: z.string().regex(/^[0-9]+$/) }),
  body: tasaBody.partial()
});

const getTasaSchema = z.object({
  params: z.object({ id: z.string().regex(/^[0-9]+$/) })
});

module.exports = {
  createTasaSchema,
  updateTasaSchema,
  getTasaSchema
};
