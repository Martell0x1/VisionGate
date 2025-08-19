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
  constructor(private readonly espService: espDetectionService) {}

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
      const result = await this.espService.getData(data.licensePlate);
      return result;
    }
  }
}
