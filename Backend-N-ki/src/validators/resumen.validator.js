const { z } = require('zod');

const resumenQuerySchema = z.object({
  query: z.object({
    fechaInicio: z.string().optional(),
    fechaFin: z.string().optional()
  })
});

module.exports = {
  resumenQuerySchema
};
