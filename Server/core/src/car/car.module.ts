import { Module } from '@nestjs/common';
import { CarsService } from './car.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Car } from './entities/car.entity';
import { CarsController } from './car.controller';

@Module({
  controllers: [CarsController],
  imports: [TypeOrmModule.forFeature([Car])],
  exports: [CarsService],
  providers: [CarsService],
})
export class CarModule {}
