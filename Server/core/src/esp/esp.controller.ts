import {
  Body,
  Controller,
  HttpCode,
  HttpException,
  HttpStatus,
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
    console.log('controller');
    const { uploaded } = await this.espService.uploadFile(file);
    if (!uploaded) {
      throw new HttpException('File upload failed', HttpStatus.BAD_REQUEST);
    }
    const data = await this.espService.processFile(file);
    const result = await this.espService.getData(data.licensePlate);
    return data;
  }
}
