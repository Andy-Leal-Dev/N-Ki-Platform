const { prisma } = require('../prismaClient');
const prestamosRepository = require('../repositories/prestamos.repository');
const clientesRepository = require('../repositories/clientes.repository');
const tasasRepository = require('../repositories/tasas.repository');

const round2 = (value) => Math.round(value * 100) / 100;

const frequencyToDays = {
  Diario: 1,
  Semanal: 7,
  Quincenal: 15,
  Mensual: 30
};

const generateSchedule = ({ montoCapital, tasaInteres, numeroCuotas, fechaInicio, frecuenciaPago }) => {
  const cuotas = [];
  const principalPerCuota = round2(montoCapital / numeroCuotas);
  const interesTotal = montoCapital * (tasaInteres / 100);
  const interesPerCuota = round2(interesTotal / numeroCuotas);

  let fecha = new Date(fechaInicio);
  for (let i = 1; i <= numeroCuotas; i += 1) {
    if (i > 1) {
      fecha = new Date(fecha.getTime() + frequencyToDays[frecuenciaPago] * 24 * 60 * 60 * 1000);
    }
    const capital = i === numeroCuotas ? round2(montoCapital - principalPerCuota * (numeroCuotas - 1)) : principalPerCuota;
    const interes = i === numeroCuotas ? round2(interesTotal - interesPerCuota * (numeroCuotas - 1)) : interesPerCuota;
    const monto = round2(capital + interes);
    cuotas.push({
      numeroCuota: i,
      fechaVencimiento: fecha,
      capitalCuota: capital,
      interesCuota: interes,
      montoTotalCuota: monto
    });
  }
  return cuotas;
};

const listPrestamos = (usuarioId) => prestamosRepository.listPrestamos(usuarioId);

const getPrestamo = async (usuarioId, id) => {
  const prestamo = await prestamosRepository.findPrestamoById(usuarioId, id);
  if (!prestamo) {
    const error = new Error('Préstamo no encontrado');
    error.status = 404;
    throw error;
  }
  return prestamo;
};

const createPrestamo = async (usuarioId, payload) => {
  const cliente = await clientesRepository.findClienteById(usuarioId, payload.clienteId);
  if (!cliente) {
    const error = new Error('Cliente no válido');
    error.status = 400;
    throw error;
  }
  let tasa = null;
  if (payload.tasaId) {
    tasa = await tasasRepository.findTasaById(payload.tasaId);
    if (!tasa) {
      const error = new Error('Tasa no válida');
      error.status = 400;
      throw error;
    }
  }

  const fechaInicio = new Date(payload.fechaInicio);
  const fechaVencimiento = new Date(payload.fechaVencimiento);
  const cuotas = generateSchedule({
    montoCapital: payload.montoCapital,
    tasaInteres: payload.tasaInteres,
    numeroCuotas: payload.numeroCuotas,
    fechaInicio,
    frecuenciaPago: payload.frecuenciaPago
  });
  const totalInteres = cuotas.reduce((acc, cuota) => acc + cuota.interesCuota, 0);
  const saldoPendiente = payload.montoCapital + totalInteres;

  const prestamo = await prisma.$transaction(async (tx) => {
    const created = await tx.prestamo.create({
      data: {
        usuarioId,
        clienteId: payload.clienteId,
        tasaId: payload.tasaId,
        montoCapital: payload.montoCapital,
        tasaInteres: payload.tasaInteres,
        frecuenciaPago: payload.frecuenciaPago,
        fechaInicio,
        fechaVencimiento,
        estado: 'Activo',
        totalInteres: round2(totalInteres),
        saldoPendiente: round2(saldoPendiente)
      }
    });

    await tx.cuota.createMany({
      data: cuotas.map((cuota) => ({
        prestamoId: created.id,
        numeroCuota: cuota.numeroCuota,
        fechaVencimiento: cuota.fechaVencimiento,
        capitalCuota: cuota.capitalCuota,
        interesCuota: cuota.interesCuota,
        montoTotalCuota: cuota.montoTotalCuota
      }))
    });

    return created;
  });

  return getPrestamo(usuarioId, prestamo.id);
};

const updatePrestamo = async (usuarioId, id, data) => {
  await getPrestamo(usuarioId, id);
  await prestamosRepository.updatePrestamo(id, {
    tasaId: data.tasaId,
    tasaInteres: data.tasaInteres,
    frecuenciaPago: data.frecuenciaPago,
    fechaVencimiento: data.fechaVencimiento ? new Date(data.fechaVencimiento) : undefined,
    estado: data.estado
  });
  return getPrestamo(usuarioId, id);
};

const deletePrestamo = async (usuarioId, id) => {
  await getPrestamo(usuarioId, id);
  await prestamosRepository.softDeletePrestamo(id);
};

module.exports = {
  listPrestamos,
  getPrestamo,
  createPrestamo,
  updatePrestamo,
  deletePrestamo
};
