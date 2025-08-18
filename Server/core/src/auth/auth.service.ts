import {
  ConflictException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { UserService } from 'src/user/user.service';
import { JwtService } from '@nestjs/jwt';
import { RegisterDto } from './dtos/register.dto';

import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}
  async login(email: string, password: string) {
    const user = await this.userService.findUserByEmail(email);

    if (!user) {
      throw new NotFoundException(`user ${email} not found`);
    }

    const isPaasswordValid = await bcrypt.compare(password, user.password);

    if (!isPaasswordValid) {
      throw new UnauthorizedException(`Invalid credentials for user ${email}`);
    }

    const payload = { sub: user.user_id, email: user.email };

    return {
      accessToken: this.jwtService.sign(payload, { expiresIn: '7d' }),
    };
  }

  async register(registerData: RegisterDto) {
    const existingUser = await this.userService.findUserByEmail(
      registerData.email,
    );
    if (existingUser) {
      throw new ConflictException(`User ${registerData.email} already exists`);
    }
    try {
      const hashedPassword = await bcrypt.hash(registerData.password, 10);
      //   console.log(hashedPassword);
      const result = await this.userService.CreateUser({
        ...registerData,
        password: hashedPassword,
      });
      return {
        message: 'User registered successfully',
        accessToken: this.jwtService.sign({
          sub: result.user_id,
          email: result.email,
        }),
      };
    } catch (error) {
      throw new InternalServerErrorException(
        `Error registering user: ${error.message}`,
      );
    }
  }
}
