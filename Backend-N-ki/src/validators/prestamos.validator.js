const { z } = require('zod');

const frecuenciaEnum = z.enum(['Diario', 'Semanal', 'Quincenal', 'Mensual']);
const estadoEnum = z.enum(['Activo', 'Pagado', 'Vencido']);

const createPrestamoSchema = z.object({
  body: z.object({
    clienteId: z.number({ coerce: true }).int().positive(),
    tasaId: z.number({ coerce: true }).int().positive().optional(),
    montoCapital: z.number({ coerce: true }).positive(),
    tasaInteres: z.number({ coerce: true }).positive(),
    frecuenciaPago: frecuenciaEnum,
    fechaInicio: z.string().min(10),
    fechaVencimiento: z.string().min(10),
    numeroCuotas: z.number({ coerce: true }).int().positive().max(240)
  })
});

const updatePrestamoSchema = z.object({
  params: z.object({ id: z.string().regex(/^[0-9]+$/) }),
  body: z.object({
    tasaId: z.number({ coerce: true }).int().positive().optional(),
    tasaInteres: z.number({ coerce: true }).positive().optional(),
    frecuenciaPago: frecuenciaEnum.optional(),
    fechaVencimiento: z.string().min(10).optional(),
    estado: estadoEnum.optional()
  }).strict()
});

const getPrestamoSchema = z.object({
  params: z.object({ id: z.string().regex(/^[0-9]+$/) })
});

module.exports = {
  createPrestamoSchema,
  updatePrestamoSchema,
  getPrestamoSchema
};
