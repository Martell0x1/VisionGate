import { IsNotEmpty, IsDateString } from 'class-validator';
export class UploadFileEspDTO {
  @IsNotEmpty()
  readonly file: Express.Multer.File;

  @IsDateString()
  readonly timestamp: string;
}
