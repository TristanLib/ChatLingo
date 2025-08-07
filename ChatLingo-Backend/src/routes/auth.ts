import { Router } from 'express';
import { authenticate } from '../middlewares/auth';
import {
  register,
  login,
  getProfile,
  updateProfile
} from '../controllers/authController';

const router = Router();

// Public authentication routes
router.post('/register', register);
router.post('/login', login);

// Protected profile routes
router.get('/profile', authenticate, getProfile);
router.put('/profile', authenticate, updateProfile);

export default router;