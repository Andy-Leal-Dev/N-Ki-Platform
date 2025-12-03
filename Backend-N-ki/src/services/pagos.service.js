const { prisma } = require('../prismaClient');
const pagosRepository = require('../repositories/pagos.repository');

const createPago = async (usuarioId, cuotaId, data) => {
  const cuota = await prisma.cuota.findFirst({
    where: { id: cuotaId, deletedAt: null },
    include: { prestamo: true }
  });

  if (!cuota || cuota.prestamo.usuarioId !== usuarioId) {
    const error = new Error('Cuota no encontrada');
    error.status = 404;
    throw error;
  }

  const pago = await prisma.$transaction(async (tx) => {
    const created = await tx.pago.create({
      data: {
        cuotaId,
        monto: data.monto,
        fecha: new Date(data.fecha),
        referencia: data.referencia,
        observaciones: data.observaciones
      }
    });

    const pagosCuota = await tx.pago.aggregate({
      where: { cuotaId, deletedAt: null },
      _sum: { monto: true }
    });

    const totalPagosCuota = Number(pagosCuota._sum.monto ?? 0);
    if (totalPagosCuota >= Number(cuota.montoTotalCuota)) {
      await tx.cuota.update({ where: { id: cuotaId }, data: { diasRetraso: 0 } });
    }

    const saldoRestante = Number(cuota.prestamo.saldoPendiente) - data.monto;

    const prestamo = await tx.prestamo.update({
      where: { id: cuota.prestamoId },
      data: {
        saldoPendiente: saldoRestante <= 0 ? 0 : saldoRestante,
        estado: saldoRestante <= 0 ? 'Pagado' : cuota.prestamo.estado
      }
    });

    return { pago: created, prestamo };
  });

  return pago.pago;
};

const listPagos = async (usuarioId, cuotaId) => {
  const cuota = await prisma.cuota.findFirst({
    where: { id: cuotaId, deletedAt: null },
    include: { prestamo: true }
  });

  if (!cuota || cuota.prestamo.usuarioId !== usuarioId) {
    const error = new Error('Cuota no encontrada');
    error.status = 404;
    throw error;
  }

  return pagosRepository.listPagosByCuota(cuotaId);
};

module.exports = {
  createPago,
  listPagos
};
