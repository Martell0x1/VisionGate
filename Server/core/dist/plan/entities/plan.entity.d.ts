import { Car } from '../../car/entities/car.entity';
export declare class Plan {
    plan_id: number;
    value: number;
    unit: string;
    price: number;
    cars: Car[];
}
