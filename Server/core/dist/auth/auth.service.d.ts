import { UserService } from 'src/user/user.service';
import { JwtService } from '@nestjs/jwt';
import { RegisterDto } from './dtos/register.dto';
export declare class AuthService {
    private readonly userService;
    private readonly jwtService;
    constructor(userService: UserService, jwtService: JwtService);
    login(email: string, password: string): Promise<{
        accessToken: string;
    }>;
    register(registerData: RegisterDto): Promise<{
        message: string;
        accessToken: string;
    }>;
}
