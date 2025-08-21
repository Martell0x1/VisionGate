import { Injectable } from '@nestjs/common';
import { existsSync, mkdirSync } from 'fs';
import * as fs from 'fs';
import * as path from 'path';
import { CarsService } from 'src/car/car.service';
import { MlService } from 'src/ml/ml.service';

@Injectable()
export class espDetectionService {
  constructor(
    private readonly mlService: MlService,
    private readonly carService: CarsService,
  ) {}
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
  public async processFile(file: Express.Multer.File) {
    const data = await this.mlService.recognize(file);
    return data;
  }

  public async getData(licensePlate: string) {
    const user = await this.carService.findUserByLicensePlate(licensePlate);
    const car = await this.carService.findCarWithLicensePlate(licensePlate);
    return { user, car };
  }

  public async uploadFile(file: Express.Multer.File) {
    if (!file) {
      return { status: 'error', message: 'No file uploaded' };
    }

    const ext = path.extname(file.originalname).toLowerCase();
    // console.log('before');
    if (!this.AllowedExts.includes(ext)) {
      return { status: 'error', uploaded: false, message: 'Invalid file type' };
    }

    const uploadPath = path.join(__dirname, '../../', 'uploads');
    if (!existsSync(uploadPath)) {
      mkdirSync(uploadPath, { recursive: true });
      console.log('Created upload directory');
    }
    console.log('after');

    // const newFilename = `${timestamp}-${Math.floor(Math.random() * 1e9)}${ext}`;
    const newFilename = `file${ext}`;
    const newPath = path.join(uploadPath, newFilename);

    fs.renameSync(file.path, newPath);

    return {
      status: 'Uploaded',
      uploaded: true,
      message: 'File uploaded',
      filename: newFilename,
    };
  }
}
