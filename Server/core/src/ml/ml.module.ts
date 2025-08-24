import { Module } from '@nestjs/common';
import { MlService } from './ml.service';
import { HttpModule } from '@nestjs/axios';
import { MulterModule } from '@nestjs/platform-express';
import { memoryStorage } from 'multer';

@Module({
  imports: [HttpModule, MulterModule.register({ storage: memoryStorage() })],
  providers: [MlService],
  exports: [MlService],
})
export class MlModule {}
