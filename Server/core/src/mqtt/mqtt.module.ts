import { Module } from '@nestjs/common';
import { MqttService } from './mqtt.service';

@Module({
  exports: [MqttService],
  providers: [MqttService],
})
export class MqttModule {}
