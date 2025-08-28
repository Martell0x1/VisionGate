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
    return this.carRepo.find({});
  }

  async findOne(license_plate: string): Promise<Car> {
    const car = await this.carRepo.findOne({
      where: { license_plate },
    });

    if (!car)
      throw new NotFoundException(`Car with ID ${license_plate} not found`);

    return car;
  }

  async findCarWithLicensePlate(licensePlate: string) {
    const car = await this.carRepo.findOne({
      where: { license_plate: licensePlate },
    });
    if (!car) {
      // throw new NotFoundException(
      //   `Car with license plate ${licensePlate} not found`,
      // );
      console.log(`Car with license plate ${licensePlate} not found`);
    }

    return car;
  }

  async findUserByLicensePlate(licensePlate: string) {
    const car = await this.carRepo.findOne({
      where: { license_plate: licensePlate },
      relationLoadStrategy: 'join',
      relations: ['user'],
    });

    if (!car) {
      console.log(`user doesn't found`);
    }

    return car?.user;
  }

  async getUserCars(id: number) {
    const cars = await this.carRepo.find({
      where: { user_id: id },
      // relations: ['user', 'plan'], // <-- load related user and plan entities
    });

    if (!cars || cars.length === 0) {
      throw new NotFoundException(
        `User with id ${id} does not have any cars or the user does not exist.`,
      );
    }

    return cars;
  }

  async create(carData: Partial<Car>): Promise<Car> {
    const car = this.carRepo.create(carData);
    console.log(carData); // for test
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
