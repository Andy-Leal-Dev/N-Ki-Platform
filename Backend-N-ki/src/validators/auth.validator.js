const { z } = require('zod');

const registerSchema = z.object({
  body: z.object({
    nombre: z.string().min(1),
    apellido: z.string().min(1),
    correo: z.string().email(),
    password: z.string().min(8),
    fechaNacimiento: z.string().optional()
  })
});

const loginSchema = z.object({
  body: z.object({
    correo: z.string().email(),
    password: z.string().min(1)
  })
});

const googleSignInSchema = z.object({
  body: z.object({
    idToken: z.string().min(10)
  })
});

const forgotPasswordSchema = z.object({
  body: z.object({
    correo: z.string().email()
  })
});

const verifyCodeSchema = z.object({
  body: z.object({
    correo: z.string().email(),
    code: z.string().length(6)
  })
});

const resetPasswordSchema = z.object({
  body: z.object({
    correo: z.string().email(),
    resetToken: z.string().min(20),
    password: z.string().min(8)
  })
});

const refreshTokenSchema = z.object({
  body: z.object({
    refreshToken: z.string().min(20)
  })
});

module.exports = {
  registerSchema,
  loginSchema,
  googleSignInSchema,
  forgotPasswordSchema,
  verifyCodeSchema,
  resetPasswordSchema,
  refreshTokenSchema
};
