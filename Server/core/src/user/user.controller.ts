import { Body, Controller, Post, Get } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}
  @Post('findByEmail')
  findUserByEmail(@Body() body) {
    return this.userService.findUserByEmail(body.email);
  }

  @Get('test')
  findUserCars(@Body() body) {
    return this.userService.findUserCars(+body.userId);
  }
}
