const { z } = require('zod');

const createPagoSchema = z.object({
  params: z.object({ cuotaId: z.string().regex(/^[0-9]+$/) }),
  body: z.object({
    monto: z.number({ coerce: true }).positive(),
    fecha: z.string().min(10),
    referencia: z.string().max(100).optional().or(z.literal('')).transform((val) => val || undefined),
    observaciones: z.string().max(500).optional().or(z.literal('')).transform((val) => val || undefined)
  })
});

module.exports = {
  createPagoSchema
};
