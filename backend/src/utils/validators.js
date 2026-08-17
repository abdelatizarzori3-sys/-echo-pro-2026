/**
 * Joi Validation Schemas
 * For complex validation beyond express-validator
 */
const Joi = require('joi');

const schemas = {
  user: {
    register: Joi.object({
      email: Joi.string().email().required(),
      password: Joi.string()
        .min(8)
        .pattern(/[A-Z]/, 'uppercase')
        .pattern(/[0-9]/, 'number')
        .required(),
      name: Joi.string().min(2).max(50).optional(),
    }),
    login: Joi.object({
      email: Joi.string().email().required(),
      password: Joi.string().required(),
    }),
  },
  chat: {
    message: Joi.object({
      content: Joi.string().min(1).max(4000).required(),
      sessionId: Joi.string().uuid().optional(),
    }),
    session: Joi.object({
      title: Joi.string().max(100).optional(),
    }),
  },
  ai: {
    generate: Joi.object({
      prompt: Joi.string().min(1).max(8000).required(),
      model: Joi.string().valid('moonshot-v1-8k', 'moonshot-v1-32k').optional(),
      temperature: Joi.number().min(0).max(2).default(0.7),
      maxTokens: Joi.number().min(1).max(8192).default(2048),
    }),
  },
};

const validate = (schema) => (data) => {
  const { error, value } = schema.validate(data, {
    abortEarly: false,
    stripUnknown: true,
  });
  if (error) {
    throw new Error(
      error.details.map((d) => d.message).join(', ')
    );
  }
  return value;
};

module.exports = { schemas, validate };
