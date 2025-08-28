import { User } from '../../user/entities/user.entity';
export declare class Car {
    license_plate: string;
    company: string;
    car_model: string;
    subscription_start: Date;
    user_id: number;
    plan_id: number;
    user: User;
}
