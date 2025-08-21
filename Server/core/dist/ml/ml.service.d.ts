import { HttpService } from '@nestjs/axios';
export declare class MlService {
    private readonly http;
    constructor(http: HttpService);
    recognize(file: Express.Multer.File): Promise<any>;
}
