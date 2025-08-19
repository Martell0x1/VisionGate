import { Module } from '@nestjs/common';
import { MlService } from './ml.service';
import { HttpModule, HttpService } from '@nestjs/axios';

@Module({
  imports: [HttpModule],
  providers: [MlService],
  exports: [MlService],
})
export class MlModule {}
