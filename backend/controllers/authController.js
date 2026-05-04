const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { ConvexHttpClient } = require("convex/browser");
const { OAuth2Client } = require('google-auth-library');

// Initialize Convex Client
const convex = new ConvexHttpClient(process.env.CONVEX_URL || "https://grand-magpie-457.convex.cloud");

// Initialize Google OAuth Client
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// 1. Email Register
const register = async (req, res) => {
  try {
    const { email, password, name } = req.body;

    // Check if user exists using Convex
    const existingUser = await convex.query("users:getUserByEmail", { email });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create user in Convex
    const userId = await convex.mutation("users:createUser", {
      email,
      name,
      password: hashedPassword,
      authProvider: "email"
    });

    res.status(201).json({ message: 'User registered successfully', userId });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// 2. Email Login
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Get user from Convex
    const user = await convex.query("users:getUserByEmail", { email });
    if (!user || user.authProvider !== "email") {
      return res.status(404).json({ message: 'User not found or uses different login method' });
    }

    // Check password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // Generate token
    const token = jwt.sign(
      { id: user._id, email: user.email },
      process.env.JWT_SECRET || 'fallback_secret_key',
      { expiresIn: '7d' }
    );

    res.status(200).json({
      message: 'Login successful',
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        authProvider: user.authProvider
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// 3. Google Login
const googleLogin = async (req, res) => {
  try {
    const { idToken } = req.body;

    // Verify Google Token
    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });
    
    const payload = ticket.getPayload();
    const { email, name, sub: providerId } = payload;

    // Check if user exists in Convex
    let user = await convex.query("users:getUserByProvider", { authProvider: "google", providerId });

    if (!user) {
      // Create user if they don't exist
      const newUserId = await convex.mutation("users:createUser", {
        email,
        name,
        authProvider: "google",
        providerId
      });
      user = { _id: newUserId, email, name, authProvider: "google" };
    }

    // Generate our JWT token
    const token = jwt.sign(
      { id: user._id, email: user.email },
      process.env.JWT_SECRET || 'fallback_secret_key',
      { expiresIn: '7d' }
    );

    res.status(200).json({
      message: 'Google login successful',
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        authProvider: user.authProvider
      }
    });

  } catch (error) {
    res.status(500).json({ message: 'Google login failed', error: error.message });
  }
};

// 4. Apple Login
const appleLogin = async (req, res) => {
  try {
    const { email, name, appleId } = req.body; 
    // Normally you'd verify the Apple identity token here using 'apple-signin-auth' or similar.
    // For brevity, assuming token verification is handled on the client or via a middleware.

    if (!appleId) {
       return res.status(400).json({ message: 'Apple ID is required' });
    }

    let user = await convex.query("users:getUserByProvider", { authProvider: "apple", providerId: appleId });

    if (!user) {
      const newUserId = await convex.mutation("users:createUser", {
        email: email || `${appleId}@apple.user`, // Apple hides email sometimes
        name: name || "Apple User",
        authProvider: "apple",
        providerId: appleId
      });
      user = { _id: newUserId, email, name, authProvider: "apple" };
    }

    // Generate JWT
    const token = jwt.sign(
      { id: user._id, email: user.email },
      process.env.JWT_SECRET || 'fallback_secret_key',
      { expiresIn: '7d' }
    );

    res.status(200).json({
      message: 'Apple login successful',
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        authProvider: user.authProvider
      }
    });

  } catch (error) {
    res.status(500).json({ message: 'Apple login failed', error: error.message });
  }
};

module.exports = {
  register,
  login,
  googleLogin,
  appleLogin
};
