import {
  Body,
  Controller,
  Post,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { UploadService } from './esp.service';
import { UploadFileEspDTO } from './dtos/UploadFileEspDTO';

@Controller('esp')
export class UploadController {
  constructor(private readonly espService: UploadService) {}

  @Post('detect')
  @UseInterceptors(FileInterceptor('file'))
  uploadFile(
    @UploadedFile() file: Express.Multer.File,
    @Body() body: UploadFileEspDTO,
  ) {
    const { timestamp } = body;
    return this.espService.uploadFile(file, timestamp);
  }
}
