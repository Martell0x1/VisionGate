import { Body, Controller, Post } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}
  @Post('findByEmail')
  findUserByEmail(@Body() body) {
    return this.userService.findUserByEmail(body.email);
  }
}
