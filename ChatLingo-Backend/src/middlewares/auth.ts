import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { sendError } from '../utils/response';
import { UserPayload } from '../types';

declare global {
  namespace Express {
    interface Request {
      user?: UserPayload;
    }
  }
}

export const authenticate = (req: Request, res: Response, next: NextFunction): void => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader) {
      sendError(res, 'Authorization header missing', 401);
      return;
    }

    const token = authHeader.split(' ')[1]; // Bearer <token>
    
    if (!token) {
      sendError(res, 'Token missing', 401);
      return;
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback-secret') as UserPayload;
    req.user = decoded;
    
    next();
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      sendError(res, 'Invalid token', 401);
    } else {
      sendError(res, 'Authentication failed', 401);
    }
  }
};

export const optionalAuth = (req: Request, res: Response, next: NextFunction): void => {
  try {
    const authHeader = req.headers.authorization;
    
    if (authHeader) {
      const token = authHeader.split(' ')[1];
      if (token) {
        const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback-secret') as UserPayload;
        req.user = decoded;
      }
    }
    
    next();
  } catch (error) {
    // For optional auth, continue even if token is invalid
    next();
  }
};