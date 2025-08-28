import { Repository } from 'typeorm';
import { Car } from './entities/car.entity';
export declare class CarsService {
    private readonly carRepo;
    constructor(carRepo: Repository<Car>);
    findAll(): Promise<Car[]>;
    findOne(license_plate: string): Promise<Car>;
    findCarWithLicensePlate(licensePlate: string): Promise<Car | null>;
    findUserByLicensePlate(licensePlate: string): Promise<import("../user/entities/user.entity").User | undefined>;
    getUserCars(id: number): Promise<Car[]>;
    create(carData: Partial<Car>): Promise<Car>;
    update(car_id: string, updateData: Partial<Car>): Promise<Car>;
    remove(car_id: string): Promise<void>;
}
