import { Injectable } from '@nestjs/common';
import { existsSync, mkdirSync } from 'fs';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class UploadService {
  private readonly AllowedExts = [
    '.apng',
    '.png',
    '.avif',
    '.gif',
    '.jpg',
    '.jpeg',
    '.jfif',
    '.pjpeg',
    '.pjp',
    '.svg',
    '.webp',
    '.bmp',
    '.ico',
    '.cur',
    '.tif',
    '.tiff',
  ];

  public async uploadFile(file: Express.Multer.File, timestamp: string) {
    if (!file) {
      return { status: 'error', message: 'No file uploaded' };
    }

    const ext = path.extname(file.originalname).toLowerCase();
    if (!this.AllowedExts.includes(ext)) {
      return { status: 'error', message: 'Invalid file type' };
    }

    const uploadPath = path.join(__dirname, '../../', 'uploads');
    if (!existsSync(uploadPath)) {
      mkdirSync(uploadPath, { recursive: true });
    }

    const newFilename = `${timestamp}-${Math.floor(Math.random() * 1e9)}${ext}`;
    const newPath = path.join(uploadPath, newFilename);

    fs.renameSync(file.path, newPath);

    return {
      status: 'Uploaded',
      message: 'File uploaded',
      filename: newFilename,
    };
  }
}
