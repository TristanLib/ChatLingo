import { Response } from 'express';
import { ApiResponse, PaginatedResponse } from '../types';

export const sendSuccess = <T>(res: Response, data?: T, message?: string, statusCode = 200): Response => {
  return res.status(statusCode).json({
    success: true,
    data,
    message,
  } as ApiResponse<T>);
};

export const sendError = (res: Response, error: string, statusCode = 500): Response => {
  return res.status(statusCode).json({
    success: false,
    error,
  } as ApiResponse);
};

export const sendPaginated = <T>(
  res: Response, 
  data: T[], 
  page: number, 
  limit: number, 
  total: number,
  message?: string
): Response => {
  const totalPages = Math.ceil(total / limit);
  
  return res.status(200).json({
    success: true,
    data,
    message,
    pagination: {
      page,
      limit,
      total,
      totalPages,
    },
  } as PaginatedResponse<T>);
};

export const sendValidationError = (res: Response, errors: string[]): Response => {
  return res.status(400).json({
    success: false,
    error: 'Validation failed',
    details: errors,
  });
};