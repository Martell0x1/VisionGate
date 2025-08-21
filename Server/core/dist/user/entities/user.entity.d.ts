import { Car } from '../../car/entities/car.entity';
export declare class User {
    user_id: number;
    first_name: string;
    last_name: string;
    address: string;
    phone: string;
    dob: Date;
    email: string;
    NAID: string;
    password: string;
    cars: Car[];
}
