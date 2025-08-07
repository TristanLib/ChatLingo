import { Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { sendSuccess, sendError, sendValidationError } from '../utils/response';
import { AuthTokens, UserPayload } from '../types';

// Mock user data - will be replaced with database
const mockUsers = [
  {
    id: '1',
    email: 'demo@chatlingo.com',
    username: 'demo_user',
    firstName: 'Demo',
    lastName: 'User',
    password: '$2a$10$rOvuLvdN/qzYKmXNJGBNwO5KHs7vKD.k7PJwgB4p.iBdMdIi8Q2Te', // "password123"
    isActive: true,
    isVerified: true,
    subscriptionTier: 'free',
    createdAt: new Date(),
    lastLoginAt: null as Date | null
  }
];

const generateTokens = (user: UserPayload): AuthTokens => {
  const secret = process.env.JWT_SECRET || 'fallback-secret';
  
  const accessToken = jwt.sign(
    { id: user.id, email: user.email, username: user.username },
    secret,
    { expiresIn: '7d' }
  );

  const refreshToken = jwt.sign(
    { id: user.id },
    secret,
    { expiresIn: '30d' }
  );

  return { accessToken, refreshToken };
};

export const register = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, username, firstName, lastName, password } = req.body;

    // Validation
    const errors: string[] = [];
    if (!email) errors.push('Email is required');
    if (!username) errors.push('Username is required');  
    if (!password) errors.push('Password is required');
    if (password && password.length < 8) errors.push('Password must be at least 8 characters');

    if (errors.length > 0) {
      sendValidationError(res, errors);
      return;
    }

    // Check if user exists
    const existingUser = mockUsers.find(u => u.email === email || u.username === username);
    if (existingUser) {
      sendError(res, 'User already exists with this email or username', 409);
      return;
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user (mock)
    const newUser = {
      id: String(mockUsers.length + 1),
      email,
      username,
      firstName: firstName || '',
      lastName: lastName || '',
      password: hashedPassword,
      isActive: true,
      isVerified: false,
      subscriptionTier: 'free',
      createdAt: new Date(),
      lastLoginAt: null as Date | null
    };

    mockUsers.push(newUser);

    // Generate tokens
    const userPayload: UserPayload = {
      id: newUser.id,
      email: newUser.email,
      username: newUser.username
    };
    const tokens = generateTokens(userPayload);

    // Return user data without password
    const { password: _, ...userResponse } = newUser;

    sendSuccess(res, {
      user: userResponse,
      tokens
    }, 'User registered successfully', 201);

  } catch (error) {
    console.error('Registration error:', error);
    sendError(res, 'Registration failed', 500);
  }
};

export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, password } = req.body;

    // Validation
    if (!email || !password) {
      sendError(res, 'Email and password are required', 400);
      return;
    }

    // Find user
    const user = mockUsers.find(u => u.email === email);
    if (!user) {
      sendError(res, 'Invalid credentials', 401);
      return;
    }

    // Check password
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      sendError(res, 'Invalid credentials', 401);
      return;
    }

    // Check if account is active
    if (!user.isActive) {
      sendError(res, 'Account is deactivated', 401);
      return;
    }

    // Update last login
    user.lastLoginAt = new Date();

    // Generate tokens
    const userPayload: UserPayload = {
      id: user.id,
      email: user.email,
      username: user.username
    };
    const tokens = generateTokens(userPayload);

    // Return user data without password
    const { password: _, ...userResponse } = user;

    sendSuccess(res, {
      user: userResponse,
      tokens
    }, 'Login successful');

  } catch (error) {
    console.error('Login error:', error);
    sendError(res, 'Login failed', 500);
  }
};

export const getProfile = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.id;
    
    if (!userId) {
      sendError(res, 'User not authenticated', 401);
      return;
    }

    // Find user
    const user = mockUsers.find(u => u.id === userId);
    if (!user) {
      sendError(res, 'User not found', 404);
      return;
    }

    // Return user data without password
    const { password: _, ...userResponse } = user;
    sendSuccess(res, userResponse, 'Profile retrieved successfully');

  } catch (error) {
    console.error('Get profile error:', error);
    sendError(res, 'Failed to retrieve profile', 500);
  }
};

export const updateProfile = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.id;
    const { firstName, lastName, bio, learningGoal } = req.body;
    
    if (!userId) {
      sendError(res, 'User not authenticated', 401);
      return;
    }

    // Find user
    const userIndex = mockUsers.findIndex(u => u.id === userId);
    if (userIndex === -1) {
      sendError(res, 'User not found', 404);
      return;
    }

    // Update user data
    const user = mockUsers[userIndex];
    if (firstName !== undefined) user.firstName = firstName;
    if (lastName !== undefined) user.lastName = lastName;
    // Note: bio and learningGoal would be added to the user model

    // Return updated user data without password
    const { password: _, ...userResponse } = user;
    sendSuccess(res, userResponse, 'Profile updated successfully');

  } catch (error) {
    console.error('Update profile error:', error);
    sendError(res, 'Failed to update profile', 500);
  }
};