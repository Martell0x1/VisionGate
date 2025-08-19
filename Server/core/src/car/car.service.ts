import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Car } from './entities/car.entity';

@Injectable()
export class CarsService {
  constructor(
    @InjectRepository(Car) private readonly carRepo: Repository<Car>,
  ) {}

  async findAll(): Promise<Car[]> {
    return this.carRepo.find({ relations: ['user', 'plan'] });
  }

  async findOne(car_id: string): Promise<Car> {
    const car = await this.carRepo.findOne({
      where: { car_id },
      relations: ['user', 'plan'],
    });

    if (!car) throw new NotFoundException(`Car with ID ${car_id} not found`);

    return car;
  }

  async findCarWithLicensePlate(licensePlate: string) {
    const car = await this.carRepo.findOne({
      where: { license_plate: licensePlate },
      relations: ['user', 'plan'],
    });
    if (!car)
      throw new NotFoundException(
        `Car with license plate ${licensePlate} not found`,
      );

    return car;
  }

  async findUserByLicensePlate(licensePlate: string) {
    const car = await this.carRepo.findOne({
      where: { license_plate: licensePlate },
      relations: ['user'], // eager load the user
    });

    if (!car) {
      throw new NotFoundException(
        `Car with license plate ${licensePlate} not found`,
      );
    }

    return car.user;
  }

  async create(carData: Partial<Car>): Promise<Car> {
    const car = this.carRepo.create(carData);
    return this.carRepo.save(car);
  }

  async update(car_id: string, updateData: Partial<Car>): Promise<Car> {
    await this.carRepo.update(car_id, updateData);
    return this.findOne(car_id);
  }

  async remove(car_id: string): Promise<void> {
    const result = await this.carRepo.delete(car_id);
    if (result.affected === 0) {
      throw new NotFoundException(`Car with ID ${car_id} not found`);
    }
  }
}
