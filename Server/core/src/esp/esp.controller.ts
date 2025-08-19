import {
  Body,
  Controller,
  Post,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { espDetectionService } from './esp.service';
import { UploadFileEspDTO } from './dtos/UploadFileEspDTO';
import { CarsService } from 'src/car/car.service';

@Controller('esp')
export class espController {
  constructor(
    private readonly espService: espDetectionService,
    private readonly carService: CarsService,
  ) {}

  @Post('detect')
  @UseInterceptors(FileInterceptor('file'))
  async uploadFile(
    @UploadedFile() file: Express.Multer.File,
    @Body() body: UploadFileEspDTO,
  ) {
    const { timestamp } = body;
    const { uploaded } = await this.espService.uploadFile(file, timestamp);
    if (uploaded) {
      const { data } = await this.espService.processFile(file);
      const user = await this.carService.findUserByLicensePlate(
        data.licensePlate,
      );
      const car = await this.carService.findCarWithLicensePlate(
        data.licensePlate,
      );
      return { user, car };
    }
  }
}
