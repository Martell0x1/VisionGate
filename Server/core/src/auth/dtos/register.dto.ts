import {
  IsEmail,
  IsString,
  IsStrongPassword,
  IsDate,
  Length,
} from 'class-validator';

export class RegisterDto {
  @IsEmail()
  email: string;
  @IsStrongPassword({
    minLength: 8,
    minUppercase: 1,
    minLowercase: 1,
    minNumbers: 1,
    minSymbols: 1,
  })
  @IsString()
  password: string;
  @IsString()
  first_name: string;
  @IsString()
  last_name: string;
  @IsString()
  @Length(14, 14)
  NAID: string;
  @IsString()
  address: string;
  @IsString()
  phone: string;
  @IsDate()
  dob: Date;
}
