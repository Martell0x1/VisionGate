import { lastValueFrom } from 'rxjs';
import FormData from 'form-data';

import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';

@Injectable()
export class MlService {
  constructor(private readonly http: HttpService) {}

  async recognize(file: Express.Multer.File) {
    const formData = new FormData();
    formData.append('file', file.buffer, file.originalname);

    const response = await lastValueFrom(
      this.http.post(
        process.env.ML_SERVER_URL ??
          (() => {
            throw new Error('ML_SERVER_URL is not defined');
          })(),
        formData,
        {
          headers: formData.getHeaders(),
        },
      ),
    );
    // console.log(response.data);
    return response.data;
  }
}
