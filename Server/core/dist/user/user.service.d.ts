import { User } from './entities/user.entity';
import { Repository } from 'typeorm';
export declare class UserService {
    private userRepository;
    constructor(userRepository: Repository<User>);
    findUserById(user_id: number): Promise<User | null>;
    findUserByEmail(email: string): Promise<User | null>;
    CreateUser(userData: Partial<User>): Promise<User>;
}
