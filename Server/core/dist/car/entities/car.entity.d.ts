import { User } from '../../user/entities/user.entity';
import { Plan } from '../../plan/entities/plan.entity';
export declare class Car {
    car_id: string;
    company: string;
    car_model: string;
    subscription_start: Date;
    license_plate: string;
    user: User;
    plan: Plan;
}
