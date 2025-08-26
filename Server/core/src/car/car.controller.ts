import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
} from '@nestjs/common';
import { CarsService } from './car.service';
import { Car } from './entities/car.entity';

@Controller('cars')
export class CarsController {
  constructor(private readonly carsService: CarsService) {}

  @Get()
  findAll(): Promise<Car[]> {
    return this.carsService.findAll();
  }
  @Get('user/:licensePlate')
  async getUserByLicensePlate(@Param('licensePlate') licensePlate: string) {
    return this.carsService.findUserByLicensePlate(licensePlate);
  }
  @Get(':id')
  findOne(@Param('id') id: string): Promise<Car> {
    return this.carsService.findOne(id);
  }

  @Get('usercars/:id')
  async getUserCars(@Param('id') id: number) {
    return this.carsService.getUserCars(id);
  }

  @Post()
  create(@Body() carData: Partial<Car>): Promise<Car> {
    return this.carsService.create(carData);
  }

  @Put(':id')
  update(
    @Param('id') id: string,
    @Body() updateData: Partial<Car>,
  ): Promise<Car> {
    return this.carsService.update(id, updateData);
  }

  @Delete(':id')
  remove(@Param('id') id: string): Promise<void> {
    return this.carsService.remove(id);
  }
}
