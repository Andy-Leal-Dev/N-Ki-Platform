const express = require('express');
const controller = require('../controllers/auth.controller');
const { authLimiter } = require('../middlewares/rateLimiter');
const { validate } = require('../middlewares/validate');
const { asyncHandler } = require('../utils/asyncHandler');
const {
  registerSchema,
  loginSchema,
  forgotPasswordSchema,
  verifyCodeSchema,
  resetPasswordSchema,
  refreshTokenSchema,
  googleSignInSchema
} = require('../validators/auth.validator');

const router = express.Router();

router.use(authLimiter);
router.post('/register', validate(registerSchema), asyncHandler(controller.register));
router.post('/login', validate(loginSchema), asyncHandler(controller.login));
router.post('/google', validate(googleSignInSchema), asyncHandler(controller.googleSignIn));
router.post('/refresh', validate(refreshTokenSchema), asyncHandler(controller.refresh));
router.post('/logout', validate(refreshTokenSchema), asyncHandler(controller.logout));
router.post('/forgot-password', validate(forgotPasswordSchema), asyncHandler(controller.forgotPassword));
router.post('/verify-reset-code', validate(verifyCodeSchema), asyncHandler(controller.verifyResetCode));
router.post('/reset-password', validate(resetPasswordSchema), asyncHandler(controller.resetPassword));

module.exports = router;
