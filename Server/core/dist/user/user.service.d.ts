import { User } from './entities/user.entity';
import { Car } from 'src/car/entities/car.entity';
import { Repository } from 'typeorm';
export declare class UserService {
    private userRepository;
    constructor(userRepository: Repository<User>);
    findUserById(user_id: number): Promise<User | null>;
    findUserByEmail(email: string): Promise<User | null>;
    CreateUser(userData: Partial<User>): Promise<User>;
    findUserCars(userId: number): Promise<Car[] | null>;
}
