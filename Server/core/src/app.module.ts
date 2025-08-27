import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { DatabaseConfigModule } from './databaseConfig/databaseConfig.module';
import { ConfigModule } from '@nestjs/config';
import { DatabaseConfigController } from './databaseConfig/databaseConfig.controller';
import { UserModule } from './user/user.module';
import { espModule } from './esp/esp.module';
import { CarModule } from './car/car.module';
import { PlanModule } from './plan/plan.module';
import { AuthModule } from './auth/auth.module';
import { MlModule } from './ml/ml.module';
import { MqttModule } from './mqtt/mqtt.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.local.env'],
    }),
    DatabaseConfigModule,
    UserModule,
    espModule,
    CarModule,
    PlanModule,
    AuthModule,
    MlModule,
    MqttModule,
  ],
  controllers: [AppController, DatabaseConfigController],
  providers: [AppService],
})
export class AppModule {}
