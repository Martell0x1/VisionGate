import { UserService } from './user.service';
export declare class UserController {
    private readonly userService;
    constructor(userService: UserService);
    findUserByEmail(body: any): Promise<import("./entities/user.entity").User | null>;
}
