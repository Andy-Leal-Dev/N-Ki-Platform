const durationRegex = /^(\d+)([smhdw])$/i;

const unitToMs = {
  s: 1000,
  m: 60 * 1000,
  h: 60 * 60 * 1000,
  d: 24 * 60 * 60 * 1000,
  w: 7 * 24 * 60 * 60 * 1000
};

const parseDurationToMs = (duration) => {
  if (!duration) return undefined;
  if (durationRegex.test(duration)) {
    const [, value, unit] = durationRegex.exec(duration);
    return parseInt(value, 10) * unitToMs[unit.toLowerCase()];
  }
  const numeric = Number(duration);
  return Number.isFinite(numeric) ? numeric : undefined;
};

const addDuration = (duration) => {
  const ms = parseDurationToMs(duration);
  if (!ms) {
    throw new Error(`Duración inválida: ${duration}`);
  }
  return new Date(Date.now() + ms);
};

module.exports = {
  parseDurationToMs,
  addDuration
};
