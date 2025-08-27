import { Injectable } from '@nestjs/common';
import { existsSync, mkdirSync } from 'fs';
import * as fs from 'fs';
import * as path from 'path';
import { CarsService } from 'src/car/car.service';
import { MlService } from 'src/ml/ml.service';
import { MqttService } from 'src/mqtt/mqtt.service';

@Injectable()
export class espDetectionService {
  constructor(
    private readonly mlService: MlService,
    private readonly carService: CarsService,
    private readonly mqttService: MqttService,
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
    if (!car) {
      console.log('no fucking car');
    }
    console.log(car);
    return { user, car };
  }

  public async uploadFile(file: Express.Multer.File) {
    if (!file) {
      return { status: 'error', message: 'No file uploaded' };
    }

    const ext = path.extname(file.originalname).toLowerCase();
    if (!this.AllowedExts.includes(ext)) {
      return { status: 'error', uploaded: false, message: 'Invalid file type' };
    }

    const uploadPath = path.join(__dirname, '../../', 'uploads');
    if (!existsSync(uploadPath)) {
      mkdirSync(uploadPath, { recursive: true });
    }

    const newFilename = `file${ext}`;
    const newPath = path.join(uploadPath, newFilename);

    // Save buffer to disk
    // fs.writeFileSync(newPath, file.buffer);

    return {
      status: 'Uploaded',
      uploaded: true,
      message: 'File uploaded',
      filename: newFilename,
    };
  }
  async notifyDetection(plate: string) {
    const topic = 'esp/servo';
    const message = JSON.stringify({ plate, timestamp: Date.now() });
    this.mqttService.publish(topic, message);
  }
}
