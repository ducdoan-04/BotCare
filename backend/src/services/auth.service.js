const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const { generateTokens } = require('../utils/jwt.util');

const prisma = new PrismaClient();

class AuthService {
  async register(data) {
    const { email, password } = data;
    const full_name = data.full_name || data.fullName;

    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      throw new Error('Email already registered');
    }

    const salt = await bcrypt.genSalt(10);
    const password_hash = await bcrypt.hash(password, salt);

    const username = email.split('@')[0] + '_' + Math.floor(Math.random() * 1000);

    const user = await prisma.user.create({
      data: {
        username,
        email,
        password_hash,
        full_name,
      },
    });

    return user;
  }

  async login(email, password) {
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      throw new Error('Incorrect email or password');
    }

    const isValidPassword = await bcrypt.compare(password, user.password_hash);

    if (!isValidPassword) {
      throw new Error('Incorrect email or password');
    }

    const tokens = generateTokens(user);

    return {
      user: {
        id: user.id,
        email: user.email,
        full_name: user.full_name,
      },
      ...tokens,
    };
  }
}

module.exports = new AuthService();
