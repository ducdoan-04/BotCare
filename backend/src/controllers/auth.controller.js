const authService = require('../services/auth.service');

class AuthController {
  async register(req, res) {
    try {
      const user = await authService.register(req.body);
      res.status(201).json({
        message: 'User registered successfully',
        user: { id: user.id, email: user.email },
      });
    } catch (error) {
      if (error.message === 'Email already registered') {
        return res.status(400).json({ error: error.message });
      }
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  async login(req, res) {
    try {
      const { email, password } = req.body;
      
      if (!email || !password) {
        return res.status(400).json({ error: 'Email and password are required' });
      }

      const result = await authService.login(email, password);
      
      res.status(200).json({
        message: 'Login successful',
        ...result,
      });
    } catch (error) {
      if (error.message === 'Incorrect email or password') {
        return res.status(401).json({ error: error.message });
      }
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}

module.exports = new AuthController();
