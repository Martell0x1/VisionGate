import { CarsService } from './car.service';
import { Car } from './entities/car.entity';
export declare class CarsController {
    private readonly carsService;
    constructor(carsService: CarsService);
    findAll(): Promise<Car[]>;
    getUserByLicensePlate(licensePlate: string): Promise<Car | null>;
    findOne(id: string): Promise<Car>;
    getUserCars(id: number): Promise<Car[]>;
    create(carData: Partial<Car>): Promise<Car>;
    update(id: string, updateData: Partial<Car>): Promise<Car>;
    remove(id: string): Promise<void>;
}
