import { AuthService } from './auth.service';
import { LoginDto } from './dtos/login.dto';
import { RegisterDto } from './dtos/register.dto';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
    login(loginData: LoginDto): Promise<{
        accessToken: string;
    }>;
    register(registerData: RegisterDto): Promise<{
        message: string;
        accessToken: string;
    }>;
    verify(): {
        verified: boolean;
    };
}
