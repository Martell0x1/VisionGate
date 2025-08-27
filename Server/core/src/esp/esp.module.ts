import { Module } from '@nestjs/common';
import { espController } from './esp.controller';
import { espDetectionService } from './esp.service';
import { MulterModule } from '@nestjs/platform-express';
import { diskStorage, memoryStorage } from 'multer';
import { MlModule } from 'src/ml/ml.module';
import { CarModule } from 'src/car/car.module';
import { MqttModule } from 'src/mqtt/mqtt.module';

@Module({
  imports: [
    MulterModule.register({
      storage: memoryStorage(),
    }),
    MlModule,
    CarModule,
    MqttModule,
  ],
  controllers: [espController],
  providers: [espDetectionService],
  exports: [espDetectionService],
})
export class espModule {}
