const { z } = require('zod');

const clienteBody = z.object({
  cedula: z.string().min(5).max(20),
  nombre: z.string().min(1).max(300),
  telefono: z.string().max(20).optional().or(z.literal('')).transform((val) => val || undefined),
  direccion: z.string().max(300).optional().or(z.literal('')).transform((val) => val || undefined),
  tipo: z.enum(['Nuevo', 'Recurrente']).optional()
});

const createClienteSchema = z.object({
  body: clienteBody
});

const updateClienteSchema = z.object({
  params: z.object({ id: z.string().regex(/^[0-9]+$/) }),
  body: clienteBody.partial()
});

const getClienteSchema = z.object({
  params: z.object({ id: z.string().regex(/^[0-9]+$/) })
});

module.exports = {
  createClienteSchema,
  updateClienteSchema,
  getClienteSchema
};
